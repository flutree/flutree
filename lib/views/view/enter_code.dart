import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../utils/snackbar.dart';
import '../widgets/reuseable.dart';
import 'user_card.dart';
import 'bottom_persistant_platform_chooser.dart';

class EnterCode extends StatefulWidget {
  EnterCode([this.userCode = '']);
  final String userCode;
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();

  bool _isLoading = false;

  bool hasTryAccessProfile = false;

  void accessProfile(String code) async {
    setState(() {
      _isLoading = true;
      hasTryAccessProfile = true;
    });
    try {
      _usersCollection.doc(code).get().then((value) {
        setState(() => _isLoading = false);
        if (value.exists) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => UserCard(value, widget.userCode)));
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
    _codeController.text = widget.userCode;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!hasTryAccessProfile && widget.userCode.isNotEmpty) {
        print(widget.userCode);
        accessProfile(widget.userCode.trim());
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
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
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/logo/applogo.png', width: 100),
                  Text('Enter Flutree code', style: TextStyle(fontSize: 28)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 60.0),
                    child: Form(
                      key: _formKey,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () async {
                      PersistentPlatformChooser.showPlatformChooser(context);
                    },
                    child: Text('Make your own Flutree profile!',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.orange.shade700,
                            decorationStyle: TextDecorationStyle.dotted,
                            decoration: TextDecoration.underline)),
                  ),
                )),
          ],
        ),
      ),
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
          Text(
              'User not found. Please try again or check the code if entered correctly.')
        ],
      ),
    );
  }
}
