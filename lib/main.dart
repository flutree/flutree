import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_iqfareez_flutter/utils/ad_manager.dart';
import 'package:linktree_iqfareez_flutter/views/auth/signin.dart';
import 'package:linktree_iqfareez_flutter/views/customizable/app_page.dart';
import 'package:linktree_iqfareez_flutter/views/preview/basicPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!kIsWeb) {
    FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttree',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: GoogleFonts.karlaTextTheme(),
      ),
      home: Builder(
        builder: (context) {
          if (_auth == null) {
            return SignIn();
          } else {
            if (_auth.isAnonymous) {
              return BasicPage();
            } else {
              return AppPage();
            }
          }
        },
      ),
    );
  }
}
