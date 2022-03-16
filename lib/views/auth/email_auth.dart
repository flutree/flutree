import 'package:flutter/material.dart';
import 'email_register.dart';
import 'email_signin.dart';

class EmailAuth extends StatefulWidget {
  const EmailAuth({Key? key}) : super(key: key);

  @override
  State<EmailAuth> createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 430) {
              return Scaffold(
                appBar: TabBar(
                  controller: _tabController,
                  labelColor: Colors.blueGrey,
                  indicatorColor: Colors.blueGrey,
                  tabs: const [
                    Tab(
                      text: 'Register',
                    ),
                    Tab(
                      text: 'Sign In',
                    ),
                  ],
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    Register(
                      tabController: _tabController,
                    ),
                    EmailSignIn(
                      tabController: _tabController,
                    )
                  ],
                ),
              );
            } else {
              _tabController!.addListener(() {
                if (_tabController!.indexIsChanging) {
                  setState(() {});
                }
              });
              return Scaffold(
                body: Row(
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.blueGrey,
                        indicatorColor: Colors.blueGrey,
                        labelPadding: const EdgeInsets.symmetric(vertical: 24),
                        tabs: const [
                          RotatedBox(quarterTurns: 1, child: Text('Register')),
                          RotatedBox(quarterTurns: 1, child: Text('Sign In'))
                        ],
                      ),
                    ),
                    Expanded(
                        child: [
                      Register(tabController: _tabController),
                      EmailSignIn(tabController: _tabController)
                    ][_tabController!.index])
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
