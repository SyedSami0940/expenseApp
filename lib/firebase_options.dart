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
    apiKey: 'AIzaSyC6lOfZKNca7cOefyCReUCEl1r_gxK72FI',
    appId: '1:368166228936:web:c8c0989310526c0fef26fd',
    messagingSenderId: '368166228936',
    projectId: 'expenseapp-21ca8',
    authDomain: 'expenseapp-21ca8.firebaseapp.com',
    storageBucket: 'expenseapp-21ca8.firebasestorage.app',
    measurementId: 'G-9LSWKHJS47',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoWHjaRvwAFlAl5Rvabaao-ijUlJtMB7U',
    appId: '1:368166228936:android:cab736e1d6c752feef26fd',
    messagingSenderId: '368166228936',
    projectId: 'expenseapp-21ca8',
    storageBucket: 'expenseapp-21ca8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPa9uyMypAYtlEYm70p0cnN1Qo9sP40UA',
    appId: '1:368166228936:ios:0436a4e56e47bc75ef26fd',
    messagingSenderId: '368166228936',
    projectId: 'expenseapp-21ca8',
    storageBucket: 'expenseapp-21ca8.firebasestorage.app',
    iosBundleId: 'com.example.expenseapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPa9uyMypAYtlEYm70p0cnN1Qo9sP40UA',
    appId: '1:368166228936:ios:0436a4e56e47bc75ef26fd',
    messagingSenderId: '368166228936',
    projectId: 'expenseapp-21ca8',
    storageBucket: 'expenseapp-21ca8.firebasestorage.app',
    iosBundleId: 'com.example.expenseapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC6lOfZKNca7cOefyCReUCEl1r_gxK72FI',
    appId: '1:368166228936:web:96982df626f4d8e6ef26fd',
    messagingSenderId: '368166228936',
    projectId: 'expenseapp-21ca8',
    authDomain: 'expenseapp-21ca8.firebaseapp.com',
    storageBucket: 'expenseapp-21ca8.firebasestorage.app',
    measurementId: 'G-GLBYQR0MHC',
  );
}
