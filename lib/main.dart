import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutree/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';
import 'views/auth/auth_home.dart';
import 'views/profilebuilder/editing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox(kMainBoxName);
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: [kTestDeviceId2, kTestDeviceId3]));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _authUser = FirebaseAuth.instance.currentUser;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kIsWeb ? 'Flutree Create' : 'Flutree',
      theme: ThemeData(
        fontFamily: GoogleFonts.karla().fontFamily,
        primarySwatch: Colors.blueGrey,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          titleTextStyle:
              GoogleFonts.karla(color: Colors.blueGrey.shade700, fontSize: 18),
        ),
      ),
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: _analytics)],
      home: _authUser == null ? const AuthHome() : const EditPage(),
    );
  }
}
