import 'package:url_launcher/url_launcher.dart';

///lauch URL to a new web browser
launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
