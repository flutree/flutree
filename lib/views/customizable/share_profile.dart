import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../PRIVATE.dart';
import '../../constants.dart';
import '../../utils/copy_link.dart';
import '../../utils/url_launcher.dart';
import '../screens/qr_code_page.dart';
import '../widgets/reuseable.dart';
import 'advanced_link.dart';

class LiveGuide extends StatefulWidget {
  const LiveGuide({Key? key, this.userCode, this.docs}) : super(key: key);
  final String? userCode;
  final DocumentSnapshot<Map<String, dynamic>>? docs;

  @override
  _LiveGuideState createState() => _LiveGuideState();
}

class _LiveGuideState extends State<LiveGuide> {
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;
  int _numInterstitialLoadAttempts = 0;
  String? _profileLink;
  bool _isIntersAdLoaded = false;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _profileLink = '$kWebappUrl/${widget.userCode}';
    // _createInterstitialAd();
    _createBannerAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: kInterstitialShareUnitId,
      request: const AdRequest(keywords: [
        'share',
        'profile',
        'social',
        'online',
        'social media',
        'engagement',
        'business'
      ]),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          _isIntersAdLoaded = true;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= kMaxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: kShareBannerUnitId,
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _bannerAd!.load();
  }

  void _showInterstitialAd() async {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      Navigator.pop(context);
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();

        _createInterstitialAd();
        Navigator.of(context).pop();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
        Navigator.of(context).pop();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
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
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 25),
                          infoWidget(),
                          const SizedBox(height: 5),
                          advancedLinkButton(context),
                          // const SizedBox(height: 5),
                          // AskSquishCard(context: context),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: generateQrCode(_profileLink),
                          ),
                          _isBannerAdLoaded
                              ? bannerAdWidget()
                              : const SizedBox.shrink(),
                        ],
                      ),
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
                                infoWidget(),
                                const SizedBox(height: 5),
                                advancedLinkButton(context),
                                _isBannerAdLoaded
                                    ? bannerAdWidget()
                                    : const SizedBox.shrink(),
                              ],
                            )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    // AskSquishCard(context: context),
                                    generateQrCode(_profileLink),
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

  Widget advancedLinkButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvancedLink(
            userInfo: widget.docs,
            uniqueLink: 'https://$_profileLink',
            uniqueCode: widget.userCode,
          ),
        ),
      ),
      label: const Text('Advanced link...'),
      icon: const FaIcon(FontAwesomeIcons.angleDoubleRight, size: 11),
    );
  }

  Widget generateQrCode(String? url) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => QrPage(url: url))),
      child: QrImage(
        data: 'https://$url',
        size: 210,
        embeddedImage: const AssetImage(
          'images/logo/qrlogo.png',
        ),
      ),
    );
  }

  Widget infoWidget() {
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
                      text: widget.userCode,
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
              onPressed: () => CopyLink.copy(url: 'https://$_profileLink'),
              icon: const FaIcon(
                FontAwesomeIcons.copy,
                size: 18,
              ),
            ),
            TextButton.icon(
              label: const Text('Open'),
              onPressed: () => launchURL(context, 'https://$_profileLink'),
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

  Widget bannerAdWidget() {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        child: AdWidget(ad: _bannerAd!),
        width: _bannerAd!.size.width.toDouble(),
        height: 100.0,
        alignment: Alignment.center,
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
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
