import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../constants.dart';

class DynamicLinkApi {
  static Future<String> generateShortUrl(
      {String profileUrl,
      DocumentSnapshot<Map<String, dynamic>> userInfo}) async {
    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://$kPageUrl',
      link: Uri.parse(profileUrl),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(
        campaign: 'advanced-link',
        medium: 'social',
        source: 'app',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: '${userInfo.data()["nickname"]}',
          description:
              'Flutree. Connect audiences to all of your content with just one link.',
          imageUrl: Uri.parse(userInfo.data()["dpUrl"])),
    );

    var shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl.toString();
  }
}
