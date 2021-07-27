import 'package:flutter/material.dart';
import 'email_register.dart';
import 'email_signin.dart';

class EmailAuth extends StatelessWidget {
  const EmailAuth({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: const Scaffold(
              appBar: TabBar(
                labelColor: Colors.blueGrey,
                indicatorColor: Colors.blueGrey,
                tabs: [
                  Tab(
                    text: 'Register',
                  ),
                  Tab(
                    text: 'Sign In',
                  ),
                ],
              ),
              body: TabBarView(
                children: [Register(), EmailSignIn()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
