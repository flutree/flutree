import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CONSTANTS.dart' as Constants;

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
        'Made with Flutter\n${Constants.COPYRIGHT}\n',
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
                    Constants.IMAGE_URL),
              ),
            ),
            SizedBox(
              height: 28.0,
            ),
            Text(
              '@${Constants.NICKNAME}',
              style: TextStyle(fontSize: 20),
            ), //just a plain text
            SizedBox.shrink(),
            Text(Constants.SUBTITLE),
            SizedBox(
              height: 34.0,
            ),
            //change or remove this part accordingliy
            linkCard(FontAwesomeIcons.whatsapp, 'WhatsApp',
                Constants.LINK_WHATSHAPP, Colors.teal.shade800),
            linkCard(FontAwesomeIcons.telegram, 'Telegram',
                Constants.LINK_TELEGRAM, Colors.blue.shade800),
            linkCard(FontAwesomeIcons.instagram, 'Instagram',
                Constants.LINK_INSTAGRAM, Colors.orange.shade700),
            linkCard(FontAwesomeIcons.youtube, 'YouTube',
                Constants.LINK_YOUTUBE, hexToColor('#F80000')),
            linkCard(
                FontAwesomeIcons.linkedin,
                'LinkedIn',
                Constants.LINK_LINKEDIN, //addmelol
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
