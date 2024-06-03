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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPZpV7vCkHWznOUinuClLXoWGULdIOj_E',
    appId: '1:523326446678:android:6318301ece89c9b753aff7',
    messagingSenderId: '523326446678',
    projectId: 'project-firebase-14bf4',
    storageBucket: 'project-firebase-14bf4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsMqmf3yhMIoOgsOgY7oP7eV7ZOUhsUXE',
    appId: '1:523326446678:ios:d5cea3449fd3ab8b53aff7',
    messagingSenderId: '523326446678',
    projectId: 'project-firebase-14bf4',
    storageBucket: 'project-firebase-14bf4.appspot.com',
    iosBundleId: 'com.example.myGraduationProject',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC934sRP6ymy8eBIXq30QvyLstPeBBoVPw',
    appId: '1:523326446678:web:9c2de566363c02dc53aff7',
    messagingSenderId: '523326446678',
    projectId: 'project-firebase-14bf4',
    authDomain: 'project-firebase-14bf4.firebaseapp.com',
    storageBucket: 'project-firebase-14bf4.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsMqmf3yhMIoOgsOgY7oP7eV7ZOUhsUXE',
    appId: '1:523326446678:ios:d5cea3449fd3ab8b53aff7',
    messagingSenderId: '523326446678',
    projectId: 'project-firebase-14bf4',
    storageBucket: 'project-firebase-14bf4.appspot.com',
    iosBundleId: 'com.example.myGraduationProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC934sRP6ymy8eBIXq30QvyLstPeBBoVPw',
    appId: '1:523326446678:web:38375118b7280a7e53aff7',
    messagingSenderId: '523326446678',
    projectId: 'project-firebase-14bf4',
    authDomain: 'project-firebase-14bf4.firebaseapp.com',
    storageBucket: 'project-firebase-14bf4.appspot.com',
  );

}