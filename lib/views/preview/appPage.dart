import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;
import 'package:linktree_iqfareez_flutter/utils/HexToColour.dart';
import 'package:linktree_iqfareez_flutter/views/auth/signin.dart';

import '../linkCard.dart';

class AppPage extends StatelessWidget {
  final bool isShowSubtitle = Constants.kShowSubtitleText;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25.0,
              ),
              PressableDough(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('images/sample.jpg'),
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
              isShowSubtitle ? Text(Constants.kSubtitle) : SizedBox.shrink(),
              SizedBox(
                height: 25.0,
              ),
              //change or remove this part accordingliy
              LinkCard(
                icon: FontAwesomeIcons.whatsapp,
                title: 'WhatsApp',
                url: Constants.kLinkWhatsapp,
                color: Colors.teal.shade800,
                isSample: true, //make this to false to open link when clicked
              ),
              LinkCard(
                icon: FontAwesomeIcons.telegram,
                title: 'Telegram',
                url: Constants.kLinkTelegram,
                color: Colors.blue.shade800,
                isSample: true,
              ),
              LinkCard(
                icon: FontAwesomeIcons.twitter,
                title: 'Twitter',
                url: Constants.kLinkTwitter,
                color: hexToColor('#1DA1F2'),
                isSample: false,
              ),
              LinkCard(
                icon: FontAwesomeIcons.instagram,
                title: 'Instagram',
                url: Constants.kLinkInstagram,
                color: Colors.orange.shade700,
                isSample: true,
              ),
              LinkCard(
                icon: FontAwesomeIcons.youtube,
                title: 'YouTube',
                url: Constants.kLinkYoutube,
                color: hexToColor('#F80000'),
                isSample: false,
              ),
              LinkCard(
                icon: FontAwesomeIcons.linkedin,
                title: 'LinkedIn',
                url: Constants.kLinkLinkedin, //addmelol
                color: Colors.blue.shade900,
                isSample: true,
              ),
              SizedBox(height: 60.0),
              TextButton(
                onPressed: () async {
                  int response = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Exit preview?'),
                        content: Text('You will be returned to sign in page'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(0);
                              },
                              child: Text('Yes, proceed.')),
                        ],
                      );
                    },
                  );
                  if (response == 0) {
                    //TODO: Show ads
                    FirebaseAuth.instance.signOut().then((_) => {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => SignIn()))
                        });
                  }
                },
                child: Text('Exit preview'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}