import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linktree_iqfareez_flutter/utils/url_launcher.dart';

import '../../CONSTANTS.dart';

class PersistentPlatformChooser {
  static Future showPlatformChooser(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 120,
          child: Column(
            children: [
              Expanded(
                child: SizedBox.expand(
                  child: TextButton.icon(
                    icon: FaIcon(FontAwesomeIcons.googlePlay),
                    onPressed: () => launchURL(context, kGetAndroidApp),
                    label: Text(
                      'Continue in app (Recommended)',
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox.expand(
                  child: TextButton.icon(
                    icon: FaIcon(FontAwesomeIcons.chrome),
                    onPressed: () =>
                        launchURL(context, 'https://$kWebCreateUrl'),
                    label: Text(
                      'Continue on browser',
                      maxLines: 3,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
