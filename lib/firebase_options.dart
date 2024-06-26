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
    apiKey: 'AIzaSyBZYkSz1UsIqSKctZP1WPmwUX_n_R4yScw',
    appId: '1:426832972594:web:1e5025f2d21f45d2cee52b',
    messagingSenderId: '426832972594',
    projectId: 'dairy-smart',
    authDomain: 'dairy-smart.firebaseapp.com',
    storageBucket: 'dairy-smart.appspot.com',
    measurementId: 'G-L24T3G8JVL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAy-E758DbE7v0nnC8_M9n0L37FUdjWNQU',
    appId: '1:426832972594:android:383a0ee0ca768053cee52b',
    messagingSenderId: '426832972594',
    projectId: 'dairy-smart',
    storageBucket: 'dairy-smart.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjbSabTH2tXmVMJEZNLNvIZC8fJEmXBD4',
    appId: '1:426832972594:ios:38bbd308412d57d7cee52b',
    messagingSenderId: '426832972594',
    projectId: 'dairy-smart',
    storageBucket: 'dairy-smart.appspot.com',
    iosBundleId: 'com.example.dairySmart',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjbSabTH2tXmVMJEZNLNvIZC8fJEmXBD4',
    appId: '1:426832972594:ios:3830894201f6df0ecee52b',
    messagingSenderId: '426832972594',
    projectId: 'dairy-smart',
    storageBucket: 'dairy-smart.appspot.com',
    iosBundleId: 'com.example.dairySmart.RunnerTests',
  );
}
