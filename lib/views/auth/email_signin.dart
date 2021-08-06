import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linktree_iqfareez_flutter/utils/snackbar.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/editing_page.dart';
import '../widgets/reuseable.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key key, @required this.tabController}) : super(key: key);
  final TabController tabController;
  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignInLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
          child: Column(
            children: [
              const Spacer(),
              EmailTextField(emailController: _emailController),
              const SizedBox(height: 10),
              PasswordTextField(passwordController: _passwordController),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isSignInLoading
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).unfocus();
                          setState(() => _isSignInLoading = true);
                          _authInstance
                              .signInWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim())
                              .then((value) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (builder) => const EditPage()),
                                (route) => false);
                          }).catchError((error) {
                            print('ERROR: $error');
                            setState(() {
                              _isSignInLoading = false;
                              CustomSnack.showErrorSnack(context,
                                  message: '${error.message}');
                            });
                          });
                        }
                      },
                child: _isSignInLoading
                    ? const LoadingIndicator()
                    : const Text('Sign in'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              const Spacer(flex: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            bool _isResetPasswordLoading = false;

                            return StatefulBuilder(
                              builder: (context, setDialogState) {
                                return AlertDialog(
                                  title: const Text(
                                      'Enter email you used to register with Flutree'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      EmailTextField(
                                        emailController: _emailController,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'A reset password link will be sent to your email.',
                                      )
                                    ],
                                  ),
                                  actions: [
                                    _isResetPasswordLoading
                                        ? const LoadingIndicator()
                                        : const SizedBox.shrink(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (_emailController.text.isNotEmpty) {
                                          setDialogState(() =>
                                              _isResetPasswordLoading = true);
                                          try {
                                            await _authInstance
                                                .sendPasswordResetEmail(
                                                    email: _emailController.text
                                                        .trim());
                                            setDialogState(() =>
                                                _isResetPasswordLoading =
                                                    false);
                                            Navigator.pop(context);
                                            CustomSnack.showSnack(context,
                                                message: 'Email sent');
                                          } on FirebaseAuthException catch (e) {
                                            setDialogState(() =>
                                                _isResetPasswordLoading =
                                                    false);
                                            Navigator.pop(context);
                                            CustomSnack.showErrorSnack(context,
                                                message: e.message);
                                          } catch (e) {
                                            setDialogState(() =>
                                                _isResetPasswordLoading =
                                                    false);
                                            CustomSnack.showErrorSnack(context,
                                                message: 'Unknown err');
                                            Navigator.pop(context);
                                            rethrow;
                                          }
                                        }
                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.redAccent, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.tabController.animateTo(0);
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
