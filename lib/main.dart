import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'views/auth/signin.dart';
import 'views/customizable/editing_page.dart';
import 'views/view/enter_code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetStorage.init();

  if (!kIsWeb) {
    MobileAds.instance.initialize();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _authUser = FirebaseAuth.instance.currentUser;
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutree',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: GoogleFonts.karlaTextTheme(),
      ),
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: _analytics)],
      onGenerateRoute: (settings) {
        // I don't even know how this works, thanks to stack Overflow lol
        // https://stackoverflow.com/a/59755970/13617136
        List<String> pathComponents = settings.name.split('/');
        print(settings.name);
        switch (settings.name) {
          case '/':
            print('/');
            return MaterialPageRoute(
              builder: (context) => EnterCode(userCode: ''),
            );
            break;
          default:
            print('default');
            return MaterialPageRoute(
              builder: (context) => EnterCode(
                userCode: pathComponents.last,
              ),
            );
        }
      },
      home: kIsWeb
          ? EnterCode(userCode: '')
          : _authUser == null
              ? SignIn()
              : EditPage(),
      //
    );
  }
}
