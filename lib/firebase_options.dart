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
    apiKey: 'AIzaSyAbXWnfEXGGB-UiT8hCu_RtMBicmVXcHXg',
    appId: '1:735619299759:web:6c1a670bad5e7ac67d175a',
    messagingSenderId: '735619299759',
    projectId: 'radar-2024',
    authDomain: 'radar-2024.firebaseapp.com',
    databaseURL: 'https://radar-2024-default-rtdb.firebaseio.com',
    storageBucket: 'radar-2024.appspot.com',
    measurementId: 'G-CR47ZRJ77Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChdPvHwlNJvrzBl09RxsoXhkm_OXfTZsU',
    appId: '1:735619299759:android:a733d7306fc171db7d175a',
    messagingSenderId: '735619299759',
    projectId: 'radar-2024',
    databaseURL: 'https://radar-2024-default-rtdb.firebaseio.com',
    storageBucket: 'radar-2024.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZMciEqgYPfSDmCZa1_2vERVUHNRdiVu8',
    appId: '1:735619299759:ios:1769cf858e08ac987d175a',
    messagingSenderId: '735619299759',
    projectId: 'radar-2024',
    databaseURL: 'https://radar-2024-default-rtdb.firebaseio.com',
    storageBucket: 'radar-2024.appspot.com',
    iosBundleId: 'com.example.radar',
  );
}
