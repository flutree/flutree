import 'package:dough/dough.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:linktree_iqfareez_flutter/utils/ad_manager.dart';
import 'package:linktree_iqfareez_flutter/utils/urlLauncher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'preview_app_page.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;

const firstRunKey = 'firstRun';

class PreviewPage extends StatefulWidget {
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  InterstitialAd interstitialAd;
  InterstitialAd myInterstitial() {
    return InterstitialAd(
      listener: onInterstitialAdEvent,
      adUnitId: AdManager.interstitialAdUnitId,
      targetingInfo: MobileAdTargetingInfo(testDevices: [
        '9CF5B0E63E5D5EAF720A3F499C6A75D3',
        '544FB3234D373268D3A6DB803850CDFB'
      ]),
    );
  }

  bool isInterstitialAdReady;

  void loadInterstitialAd() {
    interstitialAd = myInterstitial()..load();
  }

  void onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        isInterstitialAdReady = true;
        print('ads loaded');
        break;
      case MobileAdEvent.failedToLoad:
        isInterstitialAdReady = false;
        interstitialAd..load();
        print('ads failed to load');
        break;
      case MobileAdEvent.closed:
        print('ads closed');
        interstitialAd = myInterstitial()..load();
        launchURL(Constants.kGumroadDiscountLink);
        Fluttertoast.showToast(msg: 'Coupon code applied. Enjoy!');
        break;
      case MobileAdEvent.opened:
        print('opened ads');
        break;
      case MobileAdEvent.leftApplication:
        print('ads left application');
        break;
      default:
        print('ads default case');
    }
  }

  @override
  void initState() {
    super.initState();
    isInterstitialAdReady = false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showWelcomeDialog(context);

      if (!kIsWeb) {
        interstitialAd = myInterstitial()..load();
      }
    });

    return Scaffold(
      body: PreviewAppPage(),
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
    );
  }

  openGumroadLink() {
    if (!kIsWeb) {
      if (isInterstitialAdReady) {
        print('Ads showing');
        interstitialAd.show();
      } else {
        Fluttertoast.showToast(msg: 'Coupon code applied');
        launchURL(Constants.kGumroadDiscountLink);
      }
    } else {
      launchURL(Constants.kLinkGumroad);
    }
  }

  showWelcomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        onlyOkButton: true,
        onOkButtonPressed: () {
          GetStorage().write(firstRunKey, false);
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
      interstitialAd?.dispose();
    }

    super.dispose();
  }
}
