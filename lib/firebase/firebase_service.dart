import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

/// Thin wrapper around `Firebase.initializeApp`.
///
/// Exists so `main.dart` doesn't need to know about
/// `DefaultFirebaseOptions` directly, and so tests can stub
/// initialization without touching `main.dart`.
class FirebaseService {
  const FirebaseService._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    try {
      if (!kIsWeb) {
        await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.debug,
          appleProvider: AppleProvider.debug,
        );
      }
    } catch (e) {
      debugPrint('AppCheck init error: $e');
    }
  }
}
