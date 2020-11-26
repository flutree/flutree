import 'package:dough/dough.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:linktree_iqfareez_flutter/utils/ad_manager.dart';
import 'package:linktree_iqfareez_flutter/utils/urlLauncher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'appPage.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;

const firstRunKey = 'firstRun';

class BasicPage extends StatefulWidget {
  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  InterstitialAd interstitialAd;
  InterstitialAd myInterstitial() {
    return InterstitialAd(
      listener: onInterstitialAdEvent,
      adUnitId: AdManager.interstitialAdUnitId,
      targetingInfo: MobileAdTargetingInfo(
          testDevices: ['9CF5B0E63E5D5EAF720A3F499C6A75D3']),
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
        // openGumroadLink();
        launchURL(Constants.kLinkGumroad);
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
      GetStorage().read(firstRunKey) ?? showDialogIfFirstLoaded(context);
      interstitialAd = myInterstitial()..load();
    });

    return Scaffold(
      body: AppPage(),
      floatingActionButton: PressableDough(
        child: FloatingActionButton(
          onPressed: openGumroadLink,
          backgroundColor: Colors.purple.shade800,
          tooltip: 'Get source code',
          mini: true,
          child: Icon(
            FontAwesomeIcons.github,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  openGumroadLink() {
    Fluttertoast.showToast(msg: 'Opening Gumroad!');
    if (isInterstitialAdReady) {
      print('Ads showing');
      interstitialAd.show();
    } else {
      print('else part');
      launchURL(Constants.kLinkGumroad);
    }
  }

  showDialogIfFirstLoaded(BuildContext context) {
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
    interstitialAd?.dispose();
    super.dispose();
  }
}
