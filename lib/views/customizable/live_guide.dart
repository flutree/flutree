import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart';
import 'package:linktree_iqfareez_flutter/utils/snackbar.dart';
import 'package:linktree_iqfareez_flutter/utils/urlLauncher.dart';
import 'package:share_plus/share_plus.dart';

class LiveGuide extends StatelessWidget {
  LiveGuide(this.userCode);
  final String userCode;
  final containerTextColour = Colors.blueGrey.shade100.withAlpha(105);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        actionsIconTheme: IconThemeData(color: Colors.blueGrey),
        elevation: 0.0,
        title: Text(
          'Share your Flutree profile',
          style: TextStyle(color: Colors.blueGrey.shade700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: FaIcon(FontAwesomeIcons.shareAlt),
              onPressed: () {
                Share.share(
                    'Go to $kWebappUrl on your browser and enter code: $userCode');
              })
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Go to page:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: kWebappUrl))
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Copied URL.'),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        textColor: Colors.blueGrey.shade100,
                        label: 'Open in browser',
                        onPressed: () =>
                            launchURL(context, 'http://$kWebappUrl'),
                      ),
                    ));
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.blueGrey.shade100.withAlpha(105)),
                  child: Text(
                    kWebappUrl,
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Then enter code:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: userCode))
                      .then((value) {
                    CustomSnack.showSnack(context, message: 'Copied code');
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: containerTextColour),
                  child: Text(userCode ?? 'Error',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 10,
                      )),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 36),
                child: Image.asset(
                  'images/devices.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
