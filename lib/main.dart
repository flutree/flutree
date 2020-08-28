import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_iqfareez_flutter/utils/urlLauncher.dart';
import 'CONSTANTS.dart' as Constants;
import 'views/appPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linktree Clone',
      theme: ThemeData(
        primarySwatch: Colors.lime,
        //karla is font use in real linktree
        textTheme: GoogleFonts.karlaTextTheme(),
      ),
      home: BasicPage(),
    );
  }
}

class BasicPage extends StatelessWidget {
  final bool showCopyrightText = Constants.kShowCopyrightText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPage(),
      floatingActionButton: PressableDough(
        child: FloatingActionButton(
          onPressed: () {
            launchURL('https://github.com/fareezMaple/linktree-clone-flutter');
          },
          backgroundColor: Colors.purple.shade800,
          tooltip: 'Open GitHub',
          mini: true,
          child: Icon(
            FontAwesomeIcons.github,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Text(
        showCopyrightText
            ? 'Made with Flutter\n${Constants.kCopyright}\n'
            : 'Made with Flutter\n\n',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    );
  }
}
