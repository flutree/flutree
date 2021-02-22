import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linktree_iqfareez_flutter/views/auth/signin.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/app_page.dart';
import 'package:linktree_iqfareez_flutter/views/preview/basicPage.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseble.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                        .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text)
                        .then((value) {
                      print('Register email password done');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppPage(),
                          ));
                    }).catchError(() {
                      setState(() {
                        _isLoading = false;
                        print('WE HAVE ERROR REGISTER');
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
                    : Text('Register'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
                child: Text(
                  'Already have an account. Login here.',
                  style: TextStyle(
                      decorationStyle: TextDecorationStyle.dotted,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
