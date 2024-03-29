// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAJygwdQgzuR2xEf53BZOCQ_NMZWNNrU0I',
    appId: '1:385807044061:web:2b097f5fc775a5496eba34',
    messagingSenderId: '385807044061',
    projectId: 'linktree-clone-flutter',
    authDomain: 'linktree-clone-flutter.firebaseapp.com',
    databaseURL: 'https://linktree-clone-flutter.firebaseio.com',
    storageBucket: 'linktree-clone-flutter.appspot.com',
    measurementId: 'G-52F563EKRW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAa2FJHbZ1bea-1RWte_1PQv0SY7fv8UDI',
    appId: '1:385807044061:android:808d9708102b404d6eba34',
    messagingSenderId: '385807044061',
    projectId: 'linktree-clone-flutter',
    databaseURL: 'https://linktree-clone-flutter.firebaseio.com',
    storageBucket: 'linktree-clone-flutter.appspot.com',
  );
}
