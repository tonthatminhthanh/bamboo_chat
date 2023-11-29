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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyA7W4bt848NMDbp1mx_b9kJOdr5fpeHBxs',
    appId: '1:152104041555:web:09aa5573192d2d44779aa6',
    messagingSenderId: '152104041555',
    projectId: 'bamboochat-79a3f',
    authDomain: 'bamboochat-79a3f.firebaseapp.com',
    storageBucket: 'bamboochat-79a3f.appspot.com',
    measurementId: 'G-4WBEDMDNM1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYiq3u4pCZI42yM5KF9wGbRguleHOPKyo',
    appId: '1:152104041555:android:feae60367534a7e3779aa6',
    messagingSenderId: '152104041555',
    projectId: 'bamboochat-79a3f',
    storageBucket: 'bamboochat-79a3f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMNeM8K_-df4vfpLDFJndIWqoSOS5lnbQ',
    appId: '1:152104041555:ios:bbb97f0c8e314a1f779aa6',
    messagingSenderId: '152104041555',
    projectId: 'bamboochat-79a3f',
    storageBucket: 'bamboochat-79a3f.appspot.com',
    iosBundleId: 'com.tonthatminhthanh.bambooChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMNeM8K_-df4vfpLDFJndIWqoSOS5lnbQ',
    appId: '1:152104041555:ios:aa9d5476ca172832779aa6',
    messagingSenderId: '152104041555',
    projectId: 'bamboochat-79a3f',
    storageBucket: 'bamboochat-79a3f.appspot.com',
    iosBundleId: 'com.tonthatminhthanh.bambooChat.RunnerTests',
  );
}
