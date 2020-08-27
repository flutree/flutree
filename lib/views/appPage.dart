import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;
import 'package:linktree_iqfareez_flutter/utils/HexToColour.dart';

import 'linkCard.dart';

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
                //TODO:check if web 50, klw android kecik skit
                radius: 50.0,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    //can also use assetImage, replace NetworkImage widget by with 'AssetImage('images/sample.jpg')' . Also replace sample.jpg with our own file. Edit pubspec.yaml if necessary
                    Constants.kImageUrl),
              ),
            ),
            SizedBox(
              height: 28.0,
            ),
            Text(
              '@${Constants.kNickname}',
              style: TextStyle(fontSize: 20),
            ), //just a plain text
            SizedBox.shrink(),
            Text(Constants.kSubtitle),
            SizedBox(
              height: 34.0,
            ),
            //change or remove this part accordingliy
            LinkCard(
                icon: FontAwesomeIcons.whatsapp,
                title: 'WhatsApp',
                url: Constants.kLinkWhatsapp,
                color: Colors.teal.shade800),
            LinkCard(
                icon: FontAwesomeIcons.telegram,
                title: 'Telegram',
                url: Constants.kLinkTelegram,
                color: Colors.blue.shade800),
            LinkCard(
                icon: FontAwesomeIcons.instagram,
                title: 'Instagram',
                url: Constants.kLinkInstagram,
                color: Colors.orange.shade700),
            LinkCard(
                icon: FontAwesomeIcons.youtube,
                title: 'YouTube',
                url: Constants.kLinkYoutube,
                color: hexToColor('#F80000')),
            LinkCard(
                icon: FontAwesomeIcons.linkedin,
                title: 'LinkedIn',
                url: Constants.kLinkLinkedin, //addmelol
                color: Colors.blue.shade900),
            SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}
