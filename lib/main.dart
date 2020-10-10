import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_iqfareez_flutter/views/basicPage.dart';

void main() async {
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
