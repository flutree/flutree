import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_iqfareez_flutter/utils/ad_manager.dart';
import 'package:linktree_iqfareez_flutter/views/basicPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
