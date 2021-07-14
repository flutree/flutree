import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../CONSTANTS.dart';
import '../../PRIVATE.dart';
import '../../utils/copy_link.dart';
import '../../utils/url_launcher.dart';
import '../widgets/reuseable.dart';
import '../screens/qr_code_page.dart';
import 'advanced_link.dart';

class LiveGuide extends StatefulWidget {
  LiveGuide({this.userCode, this.docs});
  final String userCode;
  final DocumentSnapshot<Map<String, dynamic>> docs;

  @override
  _LiveGuideState createState() => _LiveGuideState();
}

class _LiveGuideState extends State<LiveGuide> {
  InterstitialAd _interstitialAd;
  BannerAd _bannerAd;
  int _numInterstitialLoadAttempts = 0;
  String _profileLink;
  bool _isIntersAdLoaded = false;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _profileLink = '$kWebappUrl/${widget.userCode}';
    _createInterstitialAd();
    _createBannerAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: kInterstitialShareUnitId,
      request: AdRequest(keywords: [
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
      request: AdRequest(),
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

    _bannerAd.load();
  }

  void _showInterstitialAd() async {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      Navigator.pop(context);
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
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
    _interstitialAd.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    print('_adsIsLoaded is $_isIntersAdLoaded');
    return WillPopScope(
      onWillPop: () async {
        // if (kIsWeb) return true else false;
        _showInterstitialAd();
        return kIsWeb;
      },
      child: GestureDetector(
        //to dismiss selectable text
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
                      'Hey. Visit my profile page on https://$_profileLink',
                      subject: 'Sharing my Flutree profile');
                },
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Container(
                width: double.infinity,
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    if (orientation == Orientation.portrait) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 25),
                            infoWidget(),
                            SizedBox(height: 5),
                            advancedLinkButton(context),
                            SizedBox(height: 5),
                            AskSquishCard(context: context),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: generateQrCode(_profileLink),
                            ),
                            _isBannerAdLoaded
                                ? bannerAdWidget()
                                : SizedBox.shrink(),
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
                                  SizedBox(height: 5),
                                  advancedLinkButton(context),
                                  _isBannerAdLoaded
                                      ? bannerAdWidget()
                                      : SizedBox.shrink(),
                                ],
                              )),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      AskSquishCard(context: context),
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
      label: Text('Advanced link...'),
      icon: FaIcon(FontAwesomeIcons.angleDoubleRight, size: 11),
    );
  }

  Widget generateQrCode(String url) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => QrPage(url: url))),
      child: QrImage(
        data: 'https://$url',
        size: 210,
        embeddedImage: AssetImage(
          'images/logo/qrlogo.png',
        ),
      ),
    );
  }

  Widget infoWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Your profile link:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 5),
        LinkContainer(
          child: Text.rich(
            TextSpan(
                style: TextStyle(
                  fontSize: 21,
                ),
                children: [
                  TextSpan(text: '$kWebappUrl/'),
                  TextSpan(
                      text: widget.userCode,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              label: Text('Copy'),
              onPressed: () => CopyLink.copy(url: 'https://$_profileLink'),
              icon: FaIcon(
                FontAwesomeIcons.copy,
                size: 18,
              ),
            ),
            TextButton.icon(
              label: Text('Open'),
              onPressed: () => launchURL(context, 'https://$_profileLink'),
              icon: FaIcon(
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
        child: AdWidget(ad: _bannerAd),
        width: _bannerAd.size.width.toDouble(),
        height: 100.0,
        alignment: Alignment.center,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: is ? really necessary?
    _interstitialAd.dispose();
    _bannerAd.dispose();
    super.dispose();
  }
}

class AskSquishCard extends StatelessWidget {
  const AskSquishCard({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AssetGiffyDialog(
              onlyOkButton: true,
              onOkButtonPressed: () => Navigator.pop(context),
              image: Image.asset(
                'images/intro.gif',
              ),
              title: Text(
                  'Try this out!\nSquishable (or dough effect) UI elements'),
            );
          },
        );
      },
      child: Text(
        'Ask others to squish the cards 👀',
        style: dottedUnderlinedStyle(),
      ),
    );
  }
}
