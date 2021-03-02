import 'package:firebase_admob/firebase_admob.dart';
import '../PRIVATE.dart';

const String testDevice = '544FB3234D373268D3A6DB803850CDFB';

class AdsHelper {
  static BannerAd _bannerAd;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: kAdmobUnitId);
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
  );

  static BannerAd _createBannerAd() {
    return BannerAd(
      adUnitId: kBannerUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  static AdSize bannerAdsSize() {
    return _bannerAd.size;
  }

  static void showBannerAd(AnchorType type) {
    if (_bannerAd == null) _bannerAd = _createBannerAd();
    _bannerAd
      ..load()
      ..show(
        anchorType: type,
      );
  }

  static void hideBannerAd() async {
    print('hiding banner ad');
    if (_bannerAd != null) {
      await _bannerAd.dispose();
      _bannerAd = null;
    }
  }
}
