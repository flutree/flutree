import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../widgets/reuseable.dart';
import '../../CONSTANTS.dart';
import '../../models/firestore_users_model.dart';
import 'not_found.dart';
import 'user_card.dart';

class EnterCode extends StatelessWidget {
  const EnterCode({Key? key, required this.userCode}) : super(key: key);
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
                  const Align(
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
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Align(
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
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class VersionInfoText extends StatelessWidget {
  const VersionInfoText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
          if (snapshot.hasData) {
            return Text('V${snapshot.data?.version}');
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class InputCodeArea extends StatefulWidget {
  const InputCodeArea({Key? key, required this.userCode}) : super(key: key);
  final String userCode;

  @override
  _InputCodeAreaState createState() => _InputCodeAreaState();
}

class _InputCodeAreaState extends State<InputCodeArea> {
  bool _isLoading = false;
  bool hasTryAccessProfile = false;
  late String userCode;

  @override
  void initState() {
    super.initState();
    userCode = widget.userCode;

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

    var profileRef = Uri.parse('$kFirestoreDocRef/users/$code');
    var response = await http.get(profileRef);
    switch (response.statusCode) {
      case 200:
        setState(() => _isLoading = false);
        var profileData =
            FirestoreUsersModel.fromJson(jsonDecode(response.body));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => UserCard(profileData, code)));
        break;
      case 404:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const NotFound()));
        break;
      default:
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Text('Unexpected error; ${response.statusCode}'),
            );
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (userCode.isNotEmpty) _codeController.text = userCode;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (!hasTryAccessProfile && userCode.isNotEmpty) {
        accessProfile(userCode.trim());
      }
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Loading...', style: TextStyle(fontSize: 26)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 60.0),
          child: !_isLoading
              ? Text('Acccessing $userCode')
              : const LoadingIndicator(),
        ),
      ],
    );
  }
}
