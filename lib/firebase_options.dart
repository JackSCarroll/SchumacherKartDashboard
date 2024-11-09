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
    apiKey: 'AIzaSyC05iFV7KWmYKnGVaJsrF7d_gt_QPBFYsQ',
    appId: '1:388940975286:web:62132c5c77c3efb02e2a17',
    messagingSenderId: '388940975286',
    projectId: 'kartingdashboard-90b49',
    authDomain: 'kartingdashboard-90b49.firebaseapp.com',
    storageBucket: 'kartingdashboard-90b49.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBHwRk9PNXwuR-b-NX8T5IijD5oRoFt3iY',
    appId: '1:388940975286:android:fb40fd03a31f69592e2a17',
    messagingSenderId: '388940975286',
    projectId: 'kartingdashboard-90b49',
    storageBucket: 'kartingdashboard-90b49.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjHuh8GHMDCLp1BF9bOEwgiyzLqkbyEqI',
    appId: '1:388940975286:ios:7731d7ca496f52482e2a17',
    messagingSenderId: '388940975286',
    projectId: 'kartingdashboard-90b49',
    storageBucket: 'kartingdashboard-90b49.firebasestorage.app',
    iosBundleId: 'com.example.schumacher',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjHuh8GHMDCLp1BF9bOEwgiyzLqkbyEqI',
    appId: '1:388940975286:ios:7731d7ca496f52482e2a17',
    messagingSenderId: '388940975286',
    projectId: 'kartingdashboard-90b49',
    storageBucket: 'kartingdashboard-90b49.firebasestorage.app',
    iosBundleId: 'com.example.schumacher',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC05iFV7KWmYKnGVaJsrF7d_gt_QPBFYsQ',
    appId: '1:388940975286:web:342f421bc93c78182e2a17',
    messagingSenderId: '388940975286',
    projectId: 'kartingdashboard-90b49',
    authDomain: 'kartingdashboard-90b49.firebaseapp.com',
    storageBucket: 'kartingdashboard-90b49.firebasestorage.app',
  );
}
