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
    apiKey: 'AIzaSyCiiBWdpU1qvSlcccSy1BJ_afUFdXuIBmg',
    appId: '1:817673580509:web:2992cbce4f584ad8a71034',
    messagingSenderId: '817673580509',
    projectId: 'resocoder-26125',
    authDomain: 'resocoder-26125.firebaseapp.com',
    storageBucket: 'resocoder-26125.appspot.com',
    measurementId: 'G-ZR6KBX43XN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6TmAZYNGpUcBDBsVSAL1OWleA97eBJos',
    appId: '1:817673580509:android:dd9a5b76197b4686a71034',
    messagingSenderId: '817673580509',
    projectId: 'resocoder-26125',
    storageBucket: 'resocoder-26125.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZmvj5beiTCjiOVGhvK1emF576mlDChcA',
    appId: '1:817673580509:ios:3ee0d151197e7299a71034',
    messagingSenderId: '817673580509',
    projectId: 'resocoder-26125',
    storageBucket: 'resocoder-26125.appspot.com',
    iosClientId: '817673580509-mf48tvnifgebjvpp2vq7cfjr8mlt7l9v.apps.googleusercontent.com',
    iosBundleId: 'com.example.dddSample',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZmvj5beiTCjiOVGhvK1emF576mlDChcA',
    appId: '1:817673580509:ios:3ee0d151197e7299a71034',
    messagingSenderId: '817673580509',
    projectId: 'resocoder-26125',
    storageBucket: 'resocoder-26125.appspot.com',
    iosClientId: '817673580509-mf48tvnifgebjvpp2vq7cfjr8mlt7l9v.apps.googleusercontent.com',
    iosBundleId: 'com.example.dddSample',
  );
}