import 'package:dough/dough.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linktree_iqfareez_flutter/utils/urlLauncher.dart';
import '../utils/ad_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;

import 'appPage.dart';

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
          testDevices: ['F06A8878E42F61AC050B40215172FBB9']),
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
        openGithubLink();
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

  final bool showCopyrightText = Constants.kShowCopyrightText;

  @override
  void initState() {
    super.initState();
    isInterstitialAdReady = false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => interstitialAd = myInterstitial()..load());
    print('builded');
    return Scaffold(
      body: AppPage(),
      floatingActionButton: PressableDough(
        child: FloatingActionButton(
          onPressed: () {
            print('fareez here $isInterstitialAdReady');

            if (isInterstitialAdReady) {
              interstitialAd.show();
            } else {
              openGithubLink();
            }
          },
          backgroundColor: Colors.purple.shade800,
          tooltip: 'Open GitHub',
          mini: true,
          child: Icon(
            FontAwesomeIcons.github,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Text(
        showCopyrightText
            ? 'Made with Flutter\n${Constants.kCopyright}\n'
            : 'Made with Flutter\n\n',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11),
      ),
    );
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  void openGithubLink() {
    Fluttertoast.showToast(msg: 'Opening GitHub');
    launchURL('https://github.com/fareezMaple/linktree-clone-flutter');
  }
}
