import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linktree_iqfareez_flutter/views/auth/signin.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/edit_page.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseable.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _authInstance = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
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
              NameTextField(nameController: _nameController),
              SizedBox(height: 10),
              EmailTextField(emailController: _emailController),
              SizedBox(height: 10),
              PasswordTextField(passwordController: _passwordController),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => _isLoading = true);
                    try {
                      UserCredential user =
                          await _authInstance.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);

                      await user.user
                          .updateProfile(displayName: _nameController.text);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(),
                          ));
                    } on FirebaseAuthException catch (e) {
                      setState(() => _isLoading = false);
                      print('ERROROR: ${e.message}');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Error: ${e.message}'),
                        behavior: SnackBarBehavior.floating,
                      ));
                    } catch (e) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Unknown error occured'),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  }
                },
                child: _isLoading ? LoadingIndicator() : Text('Register'),
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
                  'Already have an account? Login here.',
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
