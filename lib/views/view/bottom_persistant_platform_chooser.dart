import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../CONSTANTS.dart';
import '../../utils/url_launcher.dart';

class PersistentPlatformChooser {
  static Future showPlatformChooser(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 120,
          child: Column(
            children: [
              Expanded(
                child: SizedBox.expand(
                  child: TextButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.googlePlay),
                    onPressed: () => launchURL(context, kDynamicLink),
                    label: const Text(
                      'Continue in app (Recommended)',
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox.expand(
                  child: TextButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.chrome),
                    onPressed: () =>
                        launchURL(context, 'https://$kWebCreateUrl'),
                    label: const Text(
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
