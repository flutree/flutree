import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../PRIVATE.dart';
import '../../constants.dart';
import 'preview_app_page.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  InterstitialAd? _exitAd;
  bool _alreadyShowDialog = false;
  int _numInterstitialLoadAttempts = 0;
  late bool isInterstitialAdReady;

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
        request: const AdRequest(
            keywords: ['social', 'asset', 'profile', 'biolink', 'marketing']));
  }

  @override
  void initState() {
    super.initState();
    isInterstitialAdReady = false;
    createExitAd();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (!_alreadyShowDialog) {
    //     showWelcomeDialog(context);
    //   }
    // });

    //FIXME: https://pub.dev/packages/google_mobile_ads/changelog

    return WillPopScope(
      onWillPop: () async {
        onExitPreview();
        return kIsWeb;
      },
      child: Scaffold(
        body: const PreviewAppPage(),
        bottomNavigationBar: TextButton(
          onPressed: () => onExitPreview(),
          child: const Text('Exit preview'),
        ),
      ),
    );
  }

  void showInterstitialAd() async {
    if (_exitAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      Navigator.pop(context);
    }
    _exitAd!.fullScreenContentCallback = FullScreenContentCallback(
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
    _exitAd!.show();
    _exitAd = null;
  }

  onExitPreview() async {
    bool? wantToExit = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit preview'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
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

  // TODO: enabled balik nanti
  // showWelcomeDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AssetGiffyDialog(
  //       onlyOkButton: true,
  //       onOkButtonPressed: () {
  //         setState(() => _alreadyShowDialog = true);
  //         Navigator.pop(context);
  //       },
  //       image: Image.asset('images/intro.gif'),
  //       title: const Text('Try this!\nSquishable, doughy UI elements'),
  //     ),
  //     barrierDismissible: false,
  //   );
  // }
}
