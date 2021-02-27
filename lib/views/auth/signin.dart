import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linktree_iqfareez_flutter/utils/snackbar.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/editing_page.dart';
import 'package:linktree_iqfareez_flutter/views/preview/ads_wrapper.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseable.dart';

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
  bool _isGoogleLoading = false;
  bool _isPreviewLoading = false;

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
              Hero(
                tag: 'dpImage',
                child: Image.asset(
                  'images/logo/applogo.png',
                  width: 100,
                ),
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
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim())
                        .then((value) {
                      print('Sign in email password done');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(),
                          ));
                    }).catchError((error) {
                      print('ERROR: $error');
                      setState(() {
                        _isLoading = false;
                        CustomSnack.showErrorSnack(context,
                            message: 'Error: ${error.message}');
                      });
                    });
                  }
                },
                child: _isLoading ? LoadingIndicator() : Text('Sign in'),
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
                        setState(() {
                          _isPreviewLoading = true;
                        });
                        try {
                          await _authInstance.signInAnonymously().then((value) {
                            print('UserCredential is $value');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreviewPage(),
                              ),
                            ).then((value) =>
                                setState(() => _isPreviewLoading = false));
                          });
                        } on FirebaseAuthException catch (e) {
                          print('AUth error: $e');
                          setState(() => _isPreviewLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('ERROR: ${e.message}'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ));
                        } catch (e) {
                          setState(() => _isPreviewLoading = false);
                          print('Error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Unknown error occured'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: FaIcon(FontAwesomeIcons.eye, size: 15),
                      label: _isPreviewLoading
                          ? LoadingIndicator()
                          : Text('Preview only')),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onPressed: () async {
                        setState(() => _isGoogleLoading = true);
                        try {
                          // Trigger the authentication flow
                          final GoogleSignInAccount googleUser =
                              await GoogleSignIn().signIn();

                          // Obtain the auth details from the request
                          final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;

                          // Create a new credential
                          final GoogleAuthCredential credential =
                              GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );

                          // Once signed in, return the UserCredential
                          await FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPage(),
                                ));
                          });
                        } on FirebaseAuthException catch (e) {
                          print('Error: $e');
                          setState(() => _isGoogleLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('ERROR: ${e.message}')));
                        } catch (e) {
                          print('UNKNOWN ERROR CAUGHT GOOGLE SIGN IN: $e');
                          setState(() => _isGoogleLoading = false);
                        }
                      },
                      icon: FaIcon(FontAwesomeIcons.google, size: 15),
                      label: _isGoogleLoading
                          ? LoadingIndicator()
                          : Text('Sign in with Google'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
