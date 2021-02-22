import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linktree_iqfareez_flutter/views/preview/basicPage.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseble.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _authInstance = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo/applogo.png',
                width: 100,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 10),
              RaisedButton(
                onPressed: () {
                  //TODO: Signin
                },
                child: Text('Sign in'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              HorizontalOrLine(label: 'OR'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () async {
                        int response = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                  'You are entering preview mode. No edit access unless you signed in.'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Cancel')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(0),
                                    child: Text('I\'m okay with it')),
                              ],
                            );
                          },
                        );

                        if (response == 0) {
                          await _authInstance.signInAnonymously().then((value) {
                            print('UserCredential is $value');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BasicPage(),
                                ));
                          });
                        }
                      },
                      icon: FaIcon(FontAwesomeIcons.user, size: 15),
                      label: Text('Sign in anonymously')),
                  SizedBox(width: 10),
                  RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.google, size: 15),
                      label: Text('Sign in with Google'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
