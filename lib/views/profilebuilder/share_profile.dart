import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../PRIVATE.dart';
import '../../constants.dart';
import '../../model/my_user.dart';
import '../../utils/copy_link.dart';
import '../../utils/url_launcher.dart';
import '../screens/qr_code_page.dart';
import '../widgets/reuseable.dart';
import 'advanced_link.dart';

class LiveGuide extends StatefulWidget {
  const LiveGuide({Key? key, this.docs}) : super(key: key);
  final DocumentSnapshot<Map<String, dynamic>>? docs;

  @override
  _LiveGuideState createState() => _LiveGuideState();
}

class _LiveGuideState extends State<LiveGuide> {
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAdPotrait;
  BannerAd? _bannerAdLandscape; // Smaller height ad
  String? _profileLink;
  bool _isPotraitBannerAdLoaded = false;
  bool _isLandscapeBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _profileLink = '$kWebappUrl/${MyUser.profileCode}';
    // _createInterstitialAd();
    _createPotraitBannerAd();
    _createLandscapeBannerAd();
  }

  void _createPotraitBannerAd() {
    _bannerAdPotrait = BannerAd(
      adUnitId: kShareBannerUnitId,
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isPotraitBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _bannerAdPotrait!.load();
  }

  void _createLandscapeBannerAd() {
    _bannerAdLandscape = BannerAd(
      adUnitId: kShareBannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isLandscapeBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _bannerAdLandscape!.load();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //to dismiss selectable text
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.blueGrey),
          actionsIconTheme: const IconThemeData(color: Colors.blueGrey),
          elevation: 0.0,
          title: Text(
            'Share your Flutree profile',
            style: TextStyle(color: Colors.blueGrey.shade700),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.shareAlt),
              onPressed: () {
                Share.share(
                    'Hey. Visit my profile page on https://$_profileLink',
                    subject: 'Sharing my Flutree profile');
              },
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: SizedBox(
              width: double.infinity,
              child: OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 25),
                        InfoWidget(profileLink: _profileLink!),
                        const SizedBox(height: 5),
                        AdvancedLinkButton(
                            userDocs: widget.docs, profileLink: _profileLink!),
                        // const SizedBox(height: 5),
                        // AskSquishCard(context: context),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: ProfileQrCode(profileLink: _profileLink!),
                        ),
                        const Spacer(),
                        if (_isPotraitBannerAdLoaded)
                          MyBannerAd(_bannerAdPotrait!),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                InfoWidget(profileLink: _profileLink!),
                                const SizedBox(height: 5),
                                AdvancedLinkButton(
                                    userDocs: widget.docs,
                                    profileLink: _profileLink!),
                                if (_isLandscapeBannerAdLoaded)
                                  MyBannerAd(_bannerAdLandscape!),
                              ],
                            )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    // AskSquishCard(context: context),
                                    ProfileQrCode(profileLink: _profileLink!),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _bannerAdPotrait?.dispose();
    super.dispose();
  }
}

// TODO: enabled balik nanti
// class AskSquishCard extends StatelessWidget {
//   const AskSquishCard({
//     Key key,
//     @required this.context,
//   }) : super(key: key);

//   final BuildContext context;

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AssetGiffyDialog(
//               onlyOkButton: true,
//               onOkButtonPressed: () => Navigator.pop(context),
//               image: Image.asset(
//                 'images/intro.gif',
//               ),
//               title: const Text(
//                   'Try this out!\nSquishable (or dough effect) UI elements'),
//             );
//           },
//         );
//       },
//       child: Text(
//         'Ask others to squish the cards 👀',
//         style: dottedUnderlinedStyle(),
//       ),
//     );
//   }
// }

class InfoWidget extends StatelessWidget {
  const InfoWidget({Key? key, required this.profileLink}) : super(key: key);

  final String profileLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Your profile link:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        LinkContainer(
          child: Text.rich(
            TextSpan(
                style: const TextStyle(
                  fontSize: 21,
                ),
                children: [
                  const TextSpan(text: '$kWebappUrl/'),
                  TextSpan(
                      text: MyUser.profileCode,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              label: const Text('Copy'),
              onPressed: () => CopyLink.copy(url: 'https://$profileLink'),
              icon: const FaIcon(
                FontAwesomeIcons.copy,
                size: 18,
              ),
            ),
            TextButton.icon(
              label: const Text('Open'),
              onPressed: () => launchURL(context, 'https://$profileLink'),
              icon: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                size: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AdvancedLinkButton extends StatelessWidget {
  const AdvancedLinkButton(
      {Key? key, required this.userDocs, required this.profileLink})
      : super(key: key);

  final DocumentSnapshot<Map<String, dynamic>>? userDocs;
  final String profileLink;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvancedLink(
            userInfo: userDocs,
            uniqueLink: 'https://$profileLink',
            uniqueCode: MyUser.profileCode,
          ),
        ),
      ),
      label: const Text('Advanced link...'),
      icon: const FaIcon(FontAwesomeIcons.angleDoubleRight, size: 11),
    );
  }
}

class ProfileQrCode extends StatelessWidget {
  const ProfileQrCode({Key? key, required this.profileLink}) : super(key: key);

  final String profileLink;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QrPage(url: profileLink)),
        ),
        child: QrImage(
          data: 'https://$profileLink',
          size: 210,
          embeddedImage: const AssetImage(
            'images/logo/qrlogo.png',
          ),
        ),
      );
}

class MyBannerAd extends StatefulWidget {
  const MyBannerAd(this.bannerAd, {Key? key}) : super(key: key);

  final BannerAd bannerAd;

  @override
  State<MyBannerAd> createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AdWidget(ad: widget.bannerAd),
      width: widget.bannerAd.size.width.toDouble(),
      height: 100.0,
      alignment: Alignment.center,
    );
  }
}
