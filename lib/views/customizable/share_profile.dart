import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'advanced_link.dart';
import 'qr_code_page.dart';

class LiveGuide extends StatefulWidget {
  LiveGuide({this.userCode, this.docs});
  final String userCode;
  final DocumentSnapshot<Map<String, dynamic>> docs;

  @override
  _LiveGuideState createState() => _LiveGuideState();
}

class _LiveGuideState extends State<LiveGuide> {
  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  String _profileLink;
  bool _adsIsLoaded = false;

  @override
  void initState() {
    super.initState();
    _profileLink = '$kWebappUrl/${widget.userCode}';
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: kInterstitialShareUnitId,
      request: AdRequest(keywords: ['share', 'profile', 'social', 'online']),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          _adsIsLoaded = true;
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
    print('_adsIsLoaded is $_adsIsLoaded');
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
                            SizedBox(height: 20),
                            advancedLinkButton(context),
                            AskSquishCard(context: context),
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: generateQrCode(_profileLink),
                            ),
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
                                  SizedBox(height: 15),
                                  advancedLinkButton(context),
                                ],
                              )),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: generateQrCode(_profileLink)),
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

  OutlinedButton advancedLinkButton(BuildContext context) {
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
          'Your unique link:',
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
        SizedBox(height: 12),
        SelectableText.rich(
          TextSpan(
            style: TextStyle(fontSize: 16),
            children: [
              TextSpan(text: 'Alternatively, go to '),
              TextSpan(
                text: kWebappUrl,
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchURL(context, 'http://$kWebappUrl');
                  },
              ),
              TextSpan(text: ' and enter code '),
              TextSpan(
                text: widget.userCode,
                style: TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      Clipboard.setData(ClipboardData(text: widget.userCode))
                          .then(
                        (value) => Fluttertoast.showToast(msg: 'Copied code'),
                      ),
              )
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: TextButton(
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
      ),
    );
  }
}
