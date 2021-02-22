import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/app_page.dart';
import 'package:linktree_iqfareez_flutter/views/preview/basicPage.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseble.dart';

import 'register.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _authInstance = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
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
              EmailTextField(emailController: _emailController),
              SizedBox(height: 10),
              PasswordTextField(passwordController: _passwordController),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() => _isLoading = true);
                    _authInstance
                        .signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text)
                        .then((value) {
                      print('Sign in email password done');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppPage(),
                          ));
                    }).catchError(() {
                      setState(() {
                        _isLoading = false;
                        print('WE HAVE ERROR SIGN IN');
                      });
                    });
                  }
                },
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Text('Sign in'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Text(
                  'Didn\'t have an account? Register here.',
                  style: TextStyle(
                      decorationStyle: TextDecorationStyle.dotted,
                      decoration: TextDecoration.underline),
                ),
              ),
              HorizontalOrLine(label: 'OR'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[350],
                        onPrimary: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
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
                              ),
                            );
                          });
                        }
                      },
                      icon: FaIcon(FontAwesomeIcons.eye, size: 15),
                      label: Text('Preview only')),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onPressed: () {
                        GoogleSignIn().signIn().then((value) {
                          print('Sign in google complete');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppPage(),
                              ));
                        });
                      },
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
