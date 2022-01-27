// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCWXtuOENMbQV3_XUCzt_OOjWam_ez2acs',
    appId: '1:424824585501:web:f72479d382c0099ded35f4',
    messagingSenderId: '424824585501',
    projectId: 'lvtn-warehouse',
    authDomain: 'lvtn-warehouse.firebaseapp.com',
    storageBucket: 'lvtn-warehouse.appspot.com',
    measurementId: 'G-58NEZNP08F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAOmI8f5p6lrUE5oLEPe8B-jzLRidd6R0',
    appId: '1:424824585501:android:8771a3734fa24b98ed35f4',
    messagingSenderId: '424824585501',
    projectId: 'lvtn-warehouse',
    storageBucket: 'lvtn-warehouse.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBU_D72l2fUagK5IdMxgk1O01b1rGOGz5U',
    appId: '1:424824585501:ios:515b1e0f30f376d3ed35f4',
    messagingSenderId: '424824585501',
    projectId: 'lvtn-warehouse',
    storageBucket: 'lvtn-warehouse.appspot.com',
    iosClientId: '424824585501-il2hvvj7g07lnv16nc6od9h9tbks6e7d.apps.googleusercontent.com',
    iosBundleId: 'com.example.warehouse',
  );
}
