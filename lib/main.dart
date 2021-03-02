import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/ads_helper.dart';
import 'views/auth/signin.dart';
import 'views/customizable/editing_page.dart';
import 'views/preview/ads_wrapper.dart';
import 'views/view/enter_code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!kIsWeb) {
    AdsHelper.initialize();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _authUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutree',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: GoogleFonts.karlaTextTheme(),
      ),
      home: kIsWeb
          ? EnterCode()
          : _authUser == null
              ? SignIn()
              : _authUser.isAnonymous
                  ? PreviewPage()
                  : EditPage(),
    );
  }
}
