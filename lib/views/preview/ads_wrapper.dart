import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../CONSTANTS.dart';
import '../../PRIVATE.dart';
import 'preview_app_page.dart';

class PreviewPage extends StatefulWidget {
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  InterstitialAd _exitAd;
  bool _alreadyShowDialog = false;
  int _numInterstitialLoadAttempts = 0;
  bool isInterstitialAdReady;

  void createExitAd() {
    InterstitialAd.load(
        adUnitId: kInterstitialPreviewUnitId,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _exitAd = ad;
            isInterstitialAdReady = true;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _exitAd = null;
            if (_numInterstitialLoadAttempts <= kMaxFailedLoadAttempts) {
              createExitAd();
            }
          },
        ),
        request: AdRequest(keywords: ['social, asset, profile']));
  }

  @override
  void initState() {
    super.initState();
    isInterstitialAdReady = false;
    createExitAd();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!_alreadyShowDialog) {
        showWelcomeDialog(context);
      }
    });

    //FIXME: https://pub.dev/packages/google_mobile_ads/changelog

    return WillPopScope(
      onWillPop: () async {
        onExitPreview();
        return kIsWeb;
      },
      child: Scaffold(
        body: PreviewAppPage(),
        bottomNavigationBar: Container(
          child: TextButton(
            onPressed: () => onExitPreview(),
            child: Text('Exit preview'),
          ),
        ),
      ),
    );
  }

  void showInterstitialAd() async {
    if (_exitAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      Navigator.pop(context);
    }
    _exitAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();

        createExitAd();
        Navigator.of(context).pop();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createExitAd();
        Navigator.of(context).pop();
      },
    );
    _exitAd.show();
    _exitAd = null;
  }

  onExitPreview() async {
    bool wantToExit = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit preview'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
    if (wantToExit ?? false) {
      if (!kIsWeb) {
        if (isInterstitialAdReady) {
          showInterstitialAd();
          print('Ads showing');
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
      }
    }
  }

  showWelcomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        onlyOkButton: true,
        onOkButtonPressed: () {
          setState(() => _alreadyShowDialog = true);
          Navigator.pop(context);
        },
        image: Image.asset('images/intro.gif'),
        title: Text('Try this!\nSquishable, doughy UI elements'),
      ),
      barrierDismissible: false,
    );
  }
}
