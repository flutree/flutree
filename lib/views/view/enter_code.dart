import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linktree_iqfareez_flutter/views/widgets/reuseable.dart';

class EnterCode extends StatefulWidget {
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
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
                            value.length != 5 ? 'Code must be 5 digit' : null,
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
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate()) {
                        setState(() => isLoading = true);
                        String code = _codeController.text.trim();
                        print('pressed');
                        DocumentSnapshot snapshot = await _usersCollection
                            .doc(code)
                            .get()
                            .then((value) {
                          setState(() => isLoading = false);
                          print('snapshot is ${value.data()}');
                        }).catchError((Object error) {
                          print('Error: $error');
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }
                    },
                    child: !isLoading ? Text('Go') : LoadingIndicator(),
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
                  child: Text('Want to make your own?',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.orange.shade700,
                          decorationStyle: TextDecorationStyle.dotted,
                          decoration: TextDecoration.underline)),
                )),
          ],
        ),
      ),
    );
  }
}
