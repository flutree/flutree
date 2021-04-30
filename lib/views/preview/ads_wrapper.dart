import 'package:dough/dough.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../CONSTANTS.dart' as Constants;
import '../../PRIVATE.dart';
import '../../utils/ads_helper.dart';
import '../../utils/urlLauncher.dart';
import 'preview_app_page.dart';

class PreviewPage extends StatefulWidget {
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  InterstitialAd _gumroadAd;
  InterstitialAd _exitAd;
  bool _alreadyShowDialog = false;

  bool isInterstitialAdReady;

  void createGumroadAd() {
    _gumroadAd ??= InterstitialAd(
        adUnitId: kInterstitialGumroadUnitId,
        listener: AdListener(
          onAdLoaded: (ad) {
            isInterstitialAdReady = true;
            print('ads loaded');
          },
          onAdFailedToLoad: (ad, error) {
            isInterstitialAdReady = false;
            print('Error failed to load :${error.message}');
          },
          onAdClosed: (ad) {
            Fluttertoast.showToast(msg: 'Coupon code applied. Enjoy!');
            launchURL(context, Constants.kGumroadDiscountLink);
          },
        ),
        request: AdsHelper.adRequest)
      ..load();
  }

  void createExitAd() {
    _exitAd ??= InterstitialAd(
        adUnitId: kInterstitialGumroadUnitId,
        listener: AdListener(
          onAdLoaded: (ad) {
            isInterstitialAdReady = true;
            print('ads loaded');
          },
          onAdFailedToLoad: (ad, error) {
            isInterstitialAdReady = false;
            ad.load();
          },
          onAdClosed: (ad) {
            print('ads closed');
            Navigator.pop(context);
          },
          onAdOpened: (ad) => print('opened ads'),
        ),
        request: AdsHelper.adRequest)
      ..load();
  }

  @override
  void initState() {
    super.initState();
    isInterstitialAdReady = false;
    createGumroadAd();
    createExitAd();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!_alreadyShowDialog) {
        showWelcomeDialog(context);
      }
    });

    return WillPopScope(
      onWillPop: () async {
        onExitPreview();
        return false;
      },
      child: Scaffold(
        body: PreviewAppPage(),
        bottomNavigationBar: Container(
          child: TextButton(
            onPressed: () => onExitPreview(),
            child: Text('Exit preview'),
          ),
        ),
        floatingActionButton: PressableDough(
          child: FloatingActionButton(
            onPressed: openGumroadLink,
            backgroundColor: Colors.purple.shade800,
            tooltip: 'Get source code',
            mini: true,
            child: FaIcon(
              FontAwesomeIcons.code,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
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
        //TODO: Frequency capping @ admob console
        if (isInterstitialAdReady) {
          print('Ads showing');
          _exitAd.show().then((value) => {print('Succcessfully show')});
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
      }
    }
  }

  openGumroadLink() {
    if (!kIsWeb) {
      if (isInterstitialAdReady) {
        print('Ads showing');
        _gumroadAd.show();
      } else {
        Fluttertoast.showToast(msg: 'Coupon code applied');
        launchURL(context, Constants.kGumroadDiscountLink);
      }
    } else {
      launchURL(context, Constants.kLinkGumroad);
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

  @override
  void dispose() {
    if (!kIsWeb) {
      _gumroadAd?.dispose();
    }

    super.dispose();
  }
}
