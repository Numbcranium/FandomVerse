import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Thin wrapper around Firebase Storage.
///
/// Feature repositories (e.g. `UserRepository` for profile photos) depend
/// on this instead of importing `firebase_storage` directly, keeping
/// Storage usage in one place.
class StorageService {
  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  /// Uploads [fileBytes] to `$folder/$fileName` and returns its download URL.
  Future<String> uploadFile({
    required String folder,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    final ref = _storage.ref().child(folder).child(fileName);
    final task = await ref.putData(fileBytes);
    return task.ref.getDownloadURL();
  }

  /// Deletes the file at [path] (e.g. `profile_images/uid.jpg`). Swallows
  /// "already deleted / not found" errors since the end state — the file
  /// being gone — is what the caller wants either way.
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }
  }
}
