import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC2lxKspfYIjP0R_ZZQnQIIsm4nznJJwvw',
    appId: '1:400420672511:web:ede2769ff8b6aa207c4dca',
    messagingSenderId: '400420672511',
    projectId: 'fir-116ef',
    authDomain: 'fir-116ef.firebaseapp.com',
    storageBucket: 'fir-116ef.firebasestorage.app',
    measurementId: 'G-670RH7GCPD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7d47YE20Z4_JYvP8FTfrezZSFd7b-Uss',
    appId: '1:400420672511:android:eab3a2bfc4f3066f7c4dca',
    messagingSenderId: '400420672511',
    projectId: 'fir-116ef',
    storageBucket: 'fir-116ef.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfu4rgp5vEvafA2bOCitWzwAgxp61ZtOc',
    appId: '1:400420672511:ios:0e45131686e377777c4dca',
    messagingSenderId: '400420672511',
    projectId: 'fir-116ef',
    storageBucket: 'fir-116ef.firebasestorage.app',
    iosBundleId: 'com.example.lr16FirebaseAuth',
  );
}
