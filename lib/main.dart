import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/ads_helper.dart';
import 'views/auth/signin.dart';
import 'views/customizable/editing_page.dart';
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
