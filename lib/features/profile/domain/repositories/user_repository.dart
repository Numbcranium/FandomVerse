import 'dart:io';

import '../../../../models/user_model.dart';

/// Reading and updating a user's own profile.
///
/// Separate from `AuthRepository` on purpose: auth owns "who is signed
/// in", this owns "what does their profile say" — a screen that only
/// needs to show/edit profile fields shouldn't have to depend on
/// anything auth-related.
abstract class UserRepository {
  Future<UserModel> getUser(String uid);

  /// Live updates to a user's profile document (e.g. so a change made on
  /// another device shows up without a manual refresh).
  Stream<UserModel?> watchUser(String uid);

  Future<void> updateUser(UserModel user);

  /// Uploads a new profile photo and returns its download URL. Does not
  /// update the user document — call [updateUser] with the returned URL
  /// afterwards.
  Future<String> uploadProfilePhoto({
    required String uid,
    required File file,
  });
}
