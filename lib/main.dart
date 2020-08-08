import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
          child: Icon(
            FontAwesomeIcons.github,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Text(
        'Made with Flutter\n© Fareez Iqmal 2020\n',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    );
  }
}

class AppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.0,
            ),
            PressableDough(
              child: CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    //can also use assetImage, replace NetworkImage widget by with 'AssetImage('images/sample.jpg')' . Also replace sample.jpg with our own file. Edit pubspec.yaml if necessary
                    'https://firebasestorage.googleapis.com/v0/b/linktree-clone-flutter.appspot.com/o/IMG_20190927_135510.jpg?alt=media&token=254a96dd-c270-4f21-96f4-9f9261827aa7'),
              ),
            ),
            SizedBox(
              height: 28.0,
            ),
            Text(
              '@fareeziqmal',
              style: TextStyle(fontSize: 20),
            ), //just a plain text
            SizedBox.shrink(),
            Text('IIUM'),
            SizedBox(
              height: 34.0,
            ),
            //change or remove this part accordingliy
            linkCard(FontAwesomeIcons.whatsapp, 'WhatsApp',
                'https://api.whatsapp.com/60193988482', Colors.teal.shade800),
            linkCard(FontAwesomeIcons.telegram, 'Telegram',
                'https://telegram.org/', Colors.blue.shade800),
            linkCard(
                FontAwesomeIcons.instagram,
                'Instagram',
                'https://www.instagram.com/maple.cat/?hl=en',
                Colors.orange.shade700),
            linkCard(FontAwesomeIcons.youtube, 'YouTube',
                'https://www.youtube.com/', hexToColor('#F80000')),
            linkCard(
                FontAwesomeIcons.linkedin,
                'LinkedIn',
                'https://www.linkedin.com/in/muhammad-iqfareez/', //addmelol
                Colors.blue.shade900),
            SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}

Widget linkCard(IconData icon, String title, String url, Color color) {
  return PressableDough(
    child: Card(
      color: color,
      child: InkWell(
        splashColor: Colors.pink.withAlpha(10),
        onTap: () {
          launchURL(url);
        },
        child: ListTile(
          leading: FaIcon(
            icon,
            color: Colors.white,
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          trailing: Icon(null),
        ),
      ),
    ),
  );
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

/// Construct a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
