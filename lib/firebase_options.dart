// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChu_2Ym1RR2QvS2BbIXmRSiiB8mrewWkE',
    appId: '1:195842948453:android:7878c07f9bbf128104b58c',
    messagingSenderId: '195842948453',
    projectId: 'apos-d1548',
    databaseURL: 'https://apos-d1548-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'apos-d1548.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXCzL6UuC_VRC_a05KHEuE0B0fARUM7yI',
    appId: '1:195842948453:ios:f79d95de89c0424e04b58c',
    messagingSenderId: '195842948453',
    projectId: 'apos-d1548',
    databaseURL: 'https://apos-d1548-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'apos-d1548.appspot.com',
    iosBundleId: 'com.apos.aposApp',
  );
}