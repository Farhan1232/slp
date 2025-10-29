// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
  apiKey: "AIzaSyBdZ0x4d1UhL-N6MC-s3l8EHz7Dv1vS1QU",
  authDomain: "slp-world-5e108.firebaseapp.com",
  projectId: "slp-world-5e108",
  storageBucket: "slp-world-5e108.firebasestorage.app",
  messagingSenderId: "99425340156",
  appId: "1:99425340156:web:bbf9274aa460ca62d7a579"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBsujEwZPN4FbbC851oWyhnhPzvlsmIsxw",
    appId: "1:99425340156:android:ec948c134de74f22d7a579",
    messagingSenderId: "99425340156",
    projectId: "slp-world-5e108",
    storageBucket: "slp-world-5e108.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "YOUR_IOS_API_KEY",
    appId: "YOUR_IOS_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_BUCKET.appspot.com",
    iosBundleId: "com.example.yourapp",
  );
}
