import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linktree_iqfareez_flutter/utils/urlLauncher.dart';
// import 'package:linktree_iqfareez_flutter/views/auth/signin.dart';

import '../../CONSTANTS.dart';

class PersistentPlatformChooser {
  static Future showPlatformChooser(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          // height: 170,
          height: 95,
          child: Column(
            children: [
              Expanded(
                child: SizedBox.expand(
                  child: TextButton.icon(
                      icon: FaIcon(FontAwesomeIcons.googlePlay),
                      onPressed: () => launchURL(context, kPlayStoreUrl),
                      label: Text(
                        'Get app from Google Play Store\n(Recommended)',
                        maxLines: 3,
                      )),
                ),
              ),
              // Expanded(
              //   child: SizedBox.expand(
              //     child: TextButton.icon(
              //         icon: FaIcon(FontAwesomeIcons.chrome),
              //         onPressed: () => Navigator.push(context,
              //             MaterialPageRoute(builder: (context) => SignIn())),
              //         label: Text(
              //           'Continue on browser\n(Beta)',
              //           maxLines: 3,
              //         )),
              //   ),
              // )
            ],
          ),
        );
      },
    );
  }
}
