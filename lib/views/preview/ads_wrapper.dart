import 'package:dough/dough.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:linktree_iqfareez_flutter/PRIVATE.dart';
import 'package:linktree_iqfareez_flutter/utils/ads_helper.dart';
import 'package:linktree_iqfareez_flutter/utils/urlLauncher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'preview_app_page.dart';
import 'package:linktree_iqfareez_flutter/CONSTANTS.dart' as Constants;

class PreviewPage extends StatefulWidget {
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  InterstitialAd gumroadAd;
  InterstitialAd exitAd;
  bool alreadyShowAd = false;
  bool alreadyShowDialog = false;
  InterstitialAd createAdReference(
      void Function(MobileAdEvent) registerListener) {
    return InterstitialAd(
      listener: registerListener,
      adUnitId: kInterstitialUnitId,
      targetingInfo: AdsHelper.targetingInfo,
    );
  }

  bool isInterstitialAdReady;

  void gumroadAdListener(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        isInterstitialAdReady = true;
        print('ads loaded');
        break;
      case MobileAdEvent.failedToLoad:
        isInterstitialAdReady = false;
        gumroadAd..load();
        print('ads failed to load');
        break;
      case MobileAdEvent.closed:
        print('ads closed');
        setState(() => alreadyShowAd = true);
        Fluttertoast.showToast(msg: 'Coupon code applied. Enjoy!');
        launchURL(context, Constants.kGumroadDiscountLink);
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

  void exitAdListener(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        isInterstitialAdReady = true;
        print('ads loaded');
        break;
      case MobileAdEvent.failedToLoad:
        isInterstitialAdReady = false;
        gumroadAd..load();
        print('ads failed to load');
        break;
      case MobileAdEvent.closed:
        print('ads closed');
        setState(() => alreadyShowAd = true);
        Fluttertoast.showToast(msg: 'Exitting...');
        Navigator.pop(context);
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
    print('alreadyShowAd is $alreadyShowAd');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!alreadyShowDialog) {
        showWelcomeDialog(context);
      }

      if (!kIsWeb) {
        gumroadAd = createAdReference(gumroadAdListener)..load();
        exitAd = createAdReference(exitAdListener)..load();
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
        if (isInterstitialAdReady && !alreadyShowAd) {
          print('Ads showing');
          exitAd.show();
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
        gumroadAd.show();
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
          setState(() => alreadyShowDialog = true);
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
      gumroadAd?.dispose();
    }

    super.dispose();
  }
}
