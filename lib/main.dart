import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/view/enter_code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutree Web',
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
        home: EnterCode(userCode: ''));
  }
}
