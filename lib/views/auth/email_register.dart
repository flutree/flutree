import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/snackbar.dart';
import '../customizable/editing_page.dart';
import '../widgets/reuseable.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.tabController}) : super(key: key);
  final TabController? tabController;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isRegisterLoading = false;
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
              const Spacer(flex: 1),
              NameTextField(nameController: _nameController),
              const SizedBox(height: 10),
              EmailTextField(emailController: _emailController),
              const SizedBox(height: 10),
              PasswordTextField(passwordController: _passwordController),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isRegisterLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          setState(() => _isRegisterLoading = true);
                          try {
                            UserCredential user = await _authInstance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim());

                            await user.user!
                                .updateDisplayName(_nameController.text.trim());

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (builder) => const EditPage()),
                                (route) => false);
                          } on FirebaseAuthException catch (e) {
                            setState(() => _isRegisterLoading = false);
                            CustomSnack.showErrorSnack(context,
                                message: e.message!);
                          } catch (e) {
                            setState(() => _isRegisterLoading = false);
                            CustomSnack.showErrorSnack(context,
                                message:
                                    'Failed to login due to unknown error');
                            rethrow;
                          }
                        }
                      },
                child: _isRegisterLoading
                    ? const LoadingIndicator()
                    : const Text('Register'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              const Spacer(flex: 3),
              TextButton(
                onPressed: () {
                  widget.tabController!.animateTo(1);
                },
                child: const Text(
                  'Already have an account? Login here.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
