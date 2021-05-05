import 'package:google_mobile_ads/google_mobile_ads.dart';

const String testDevice = '544FB3234D373268D3A6DB803850CDFB';

class AdsHelper {
  // static BannerAd _bannerAd;

  static const AdRequest adRequest = AdRequest(
    testDevices: testDevice != null ? <String>[testDevice] : null,
  );

  // static BannerAd _createBannerAd() {
  //   return BannerAd(
  //     adUnitId: kBannerUnitId,
  //     size: AdSize.banner,
  //     listener: AdListener(
  //       onAppEvent: (ad, name, data) => print('listener, $name, $data'),
  //     ),
  //     request: AdRequest(),
  //   );
  // }
}
