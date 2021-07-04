import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../CONSTANTS.dart';
import '../../utils/snackbar.dart';
import '../../utils/url_launcher.dart';
import '../widgets/reuseable.dart';
import 'user_card.dart';

class EnterCode extends StatelessWidget {
  const EnterCode([this.userCode]);
  final String userCode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (ctx, constraints) {
            if (constraints.maxWidth < 460) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: VersionInfoText(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('images/logo/applogo.png', width: 100),
                        InputCodeArea(
                          userCode: userCode,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MakeFlutreeButton(),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                      alignment: Alignment.topRight, child: VersionInfoText()),
                  Expanded(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Image.asset(
                              'images/logo/applogo.png',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: InputCodeArea(
                            userCode: userCode,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  MakeFlutreeButton(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class MakeFlutreeButton extends StatelessWidget {
  const MakeFlutreeButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () => launchURL(context, kDynamicLink),
        child: Text('Make your own Flutree profile!',
            style: TextStyle(
                fontSize: 15,
                color: Colors.orange.shade700,
                decorationStyle: TextDecorationStyle.dotted,
                decoration: TextDecoration.underline)),
      ),
    );
  }
}

class VersionInfoText extends StatelessWidget {
  const VersionInfoText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
          if (snapshot.hasData) {
            return Text('V${snapshot.data.version}');
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class InputCodeArea extends StatefulWidget {
  const InputCodeArea({Key key, this.userCode}) : super(key: key);
  final userCode;

  @override
  _InputCodeAreaState createState() => _InputCodeAreaState();
}

class _InputCodeAreaState extends State<InputCodeArea> {
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool hasTryAccessProfile = false;
  String userCode;

  @override
  void initState() {
    super.initState();
    userCode = widget.userCode ?? '';

    // Remove additional parameter in url if exist
    if (userCode.contains('?')) {
      int index = userCode.indexOf('?');
      userCode = userCode.substring(0, index);
      print('Removed additional parameter');
    }
  }

  void accessProfile(String code) async {
    setState(() {
      _isLoading = true;
      hasTryAccessProfile = true;
    });
    try {
      _usersCollection.doc(code).get().then((value) {
        setState(() => _isLoading = false);
        if (value.exists) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => UserCard(value, code)));
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: NotFoundDialog(),
              );
            },
          );
        }
      });
    } catch (e) {
      print('Unknown error: $e');
      setState(() => _isLoading = false);
      CustomSnack.showErrorSnack(context, message: 'Unknown err.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userCode.isNotEmpty) _codeController.text = userCode;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!hasTryAccessProfile && userCode.isNotEmpty) {
        accessProfile(userCode.trim());
      }
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Enter Flutree code', style: TextStyle(fontSize: 26)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 60.0),
          child: Form(
            key: _formKey,
            child: Container(
              width: 360,
              child: TextFormField(
                textAlign: TextAlign.center,
                validator: (value) =>
                    value.length < 5 ? 'Not enough character' : null,
                controller: _codeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState.validate()) {
                    accessProfile(_codeController.text.trim());
                  }
                },
          child: !_isLoading ? Text('Go') : LoadingIndicator(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        )
      ],
    );
  }
}

class NotFoundDialog extends StatelessWidget {
  const NotFoundDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/undraw_page_not_found_su7k.png',
              width: 400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'User not found. Please try again or check the link if entered correctly.'),
          ),
        ],
      ),
    );
  }
}
