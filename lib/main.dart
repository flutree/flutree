import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';
import 'views/view/enter_code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutree Web',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: GoogleFonts.karlaTextTheme(),
      ),
      onGenerateRoute: (settings) {
        // https://stackoverflow.com/a/59755970/13617136
        List<String> pathComponents = settings.name!.split('/');
        return MaterialPageRoute(
          builder: (context) => EnterCode(
            userCode: pathComponents.last,
          ),
        );
      },
    );
  }
}
