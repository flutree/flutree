/*
Original from here: https://codelabs.developers.google.com/codelabs/admob-ads-in-flutter/#5
 */

import 'dart:io';

import 'package:linktree_iqfareez_flutter/PRIVATE.dart';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return ADMOB_AP_ID;
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_ADMOB_APP_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return INTERSTITIAL_UNIT_ID;
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitIdEditPage {
    if (Platform.isAndroid) {
      return BANNER_UNIT_ID;
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
