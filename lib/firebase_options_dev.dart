// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
class DefaultFirebaseOptionsDevelop {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      // throw UnsupportedError(
      //   'DefaultFirebaseOptions have not been configured for android - '
      //   'you can reconfigure this by running the FlutterFire CLI again.',
      // );
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
    apiKey: 'AIzaSyB5brA3CcB3KLf7EHgK4obbRO7EUBJaZYs',
    appId: '1:884121058223:web:5287e00d4f25ca3ef24d5a',
    messagingSenderId: '884121058223',
    projectId: 'voltz-develop',
    authDomain: 'voltz-develop.firebaseapp.com',
    storageBucket: 'voltz-develop.appspot.com',
  );
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5brA3CcB3KLf7EHgK4obbRO7EUBJaZYs',
    appId: '1:884121058223:android:b36cc85bd565538bf24d5a',
    messagingSenderId: '884121058223',
    projectId: 'mx.voltz.mobile.dev',
    authDomain: 'voltz-develop.firebaseapp.com',
    storageBucket: 'voltz-develop.appspot.com',
  );
}
