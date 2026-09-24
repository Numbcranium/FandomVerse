import 'package:firebase_core/firebase_core.dart';

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
  }
}
