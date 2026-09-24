import 'dart:io';

import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._remoteDataSource, this._storageService);

  final UserRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  @override
  Future<UserModel> getUser(String uid) async {
    try {
      final user = await _remoteDataSource.fetchUser(uid);
      if (user == null) {
        throw const ServerFailure('Profile not found.');
      }
      return user;
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Stream<UserModel?> watchUser(String uid) {
    return _remoteDataSource.watchUser(uid).handleError((Object error) {
      throw AppException.from(error);
    });
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _remoteDataSource.updateUser(user);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<String> uploadProfilePhoto({
    required String uid,
    required File file,
  }) async {
    try {
      final extension = file.path.split('.').last;
      return await _storageService.uploadFile(
        folder: FirebaseConstants.storageProfileImages,
        fileName: '$uid.$extension',
        file: file,
      );
    } catch (e) {
      throw AppException.from(e);
    }
  }
}
