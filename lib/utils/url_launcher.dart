import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'snackbar.dart';

///lauch URL to a new web browser
launchURL(BuildContext context, String url) async {
  print('Launching url: $url');
  try {
    launch(url);
  } catch (e) {
    CustomSnack.showErrorSnack(context,
        message: 'Could not launch $url. Please check url');
  }
}
