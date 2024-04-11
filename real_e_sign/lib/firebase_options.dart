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
        return windows;
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
    apiKey: 'AIzaSyC_GssGaIIFQ0bhxppFSzvQ6B9dKTdVG8o',
    appId: '1:420403623070:web:df001c61331df2dcf9f78f',
    messagingSenderId: '420403623070',
    projectId: 'real-esi',
    authDomain: 'real-esi.firebaseapp.com',
    storageBucket: 'real-esi.appspot.com',
    measurementId: 'G-FQ2TDL88LC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2wNpL57crYQWvSw0eVemY22M0Y6SySDM',
    appId: '1:420403623070:android:04460cc07f2dce15f9f78f',
    messagingSenderId: '420403623070',
    projectId: 'real-esi',
    storageBucket: 'real-esi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZbrFONrxr2bePOoiRQxynp-yWgwe7F8w',
    appId: '1:420403623070:ios:4822b53d44665f12f9f78f',
    messagingSenderId: '420403623070',
    projectId: 'real-esi',
    storageBucket: 'real-esi.appspot.com',
    iosBundleId: 'com.example.realESign',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZbrFONrxr2bePOoiRQxynp-yWgwe7F8w',
    appId: '1:420403623070:ios:4822b53d44665f12f9f78f',
    messagingSenderId: '420403623070',
    projectId: 'real-esi',
    storageBucket: 'real-esi.appspot.com',
    iosBundleId: 'com.example.realESign',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC_GssGaIIFQ0bhxppFSzvQ6B9dKTdVG8o',
    appId: '1:420403623070:web:e2692f1ae6fcdc01f9f78f',
    messagingSenderId: '420403623070',
    projectId: 'real-esi',
    authDomain: 'real-esi.firebaseapp.com',
    storageBucket: 'real-esi.appspot.com',
    measurementId: 'G-XE7HLRQV34',
  );
<<<<<<< HEAD

=======
>>>>>>> aa12c39 (firebase initial login)
}
