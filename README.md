# Flutree

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat-square&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFA000?style=flat-square&logo=Firebase&logoColor=white)](https://firebase.google.com/)
[![Works with Android](https://img.shields.io/badge/Works_with-Android-green?style=flat-square)](https://play.google.com/store/apps/details?id=com.iqmal.linktreeflutter&utm_source=Github&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1)
[![Web](https://img.shields.io/badge/Available_on-Web-blue?style=flat-square)](https://flutreecreate.web.app/#/)
![Maintenance](https://img.shields.io/maintenance/yes/2022?style=flat-square)
![Installs](https://img.shields.io/badge/installs-54k+-orange)
[![Twitter Follow](https://img.shields.io/twitter/follow/iqfareez?label=Follow&style=social)](https://twitter.com/iqfareez)

Your personalized social cards. Put your social media link in one place. Easy peasy!

This repo hosts Flutree for Android and flutreecreate on Web. If you're looking for the web implementation. Check it out [now](https://github.com/iqfareez/flutree/tree/web).

![Flutree banner](https://imgur.com/qvr10Xn.png)

[[Demo profile](https://flutree.web.app/NWfLo)]

## Get the app

### Download on Google Play Store

<a href='https://play.google.com/store/apps/details?id=com.iqmal.linktreeflutter&utm_source=Github&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height=120/></a>

### For non-Android users, Flutree also runs on the web

- [flutreecreate.web.app](https://flutreecreate.web.app)

## Getting started

1. Setup Flutter (if you haven't already)
1. Clone this project and open with your code editor.
1. Create `PRIVATE.dart` in the lib folder. Copy and paste the content just like the example below. For the admob part, you can create a new app in admob or use the test ad unit (https://developers.google.com/admob/android/test-ads#demo_ad_units). Also, register Bitly and get their API token.
   ```dart
   const kAdmobAppId = 'ca-app-pub-xxxxxxxxxxxxxxxxxxxxxxx';
   const kShareBannerUnitId = 'ca-app-pub-189637xxxxxxxx/3206521140';
   const kEditPageBannerUnitId = 'ca-app-pub-189637xxxxxxxx/7250471616';
   const kInterstitialShareUnitId = 'ca-app-pub-189637xxxxxxxx/1721617881';
   const kInterstitialPreviewUnitId = 'ca-app-pub-189637xxxxxxxx/2819569063';
   const kBitlyApiToken = '85e8df908612276xxxxxxxxxxxxx36ee3d40e31';
   ```
1. Create a project on **Firebase console**, enable Authentication & Firestorte.
1. Run `flutterfire configure`. Details [here](https://firebase.google.com/docs/flutter/setup?platform=android).
1. Run `flutter run --web-renderer html`\*

\* Images won't load on **canvaskit**.

## Devlog

- [Part 1](https://www.instagram.com/s/aGlnaGxpZ2h0OjE4MTUzMDA3Njg0MTgyODA3)
- [Part 2](https://www.instagram.com/s/aGlnaGxpZ2h0OjE3ODg1MzE2ODMzMjE5MDg5)

:star::star::star::star::star:
