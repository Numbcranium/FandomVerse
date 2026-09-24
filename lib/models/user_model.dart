import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Roles a [UserModel] can have.
///
/// Kept intentionally simple per the starter's scope — no permission
/// matrix yet. Once the competition SRS is known, role-specific behavior
/// (e.g. a provider dashboard, admin tools) can branch off `role` without
/// changing this enum's shape.
enum UserRole { user, provider, admin }

extension UserRoleX on UserRole {
  String get asString => name;

  static UserRole fromString(String? value) {
    return UserRole.values.firstWhere(
      (r) => r.name == value,
      orElse: () => UserRole.user,
    );
  }
}

/// The app's reusable user profile model.
///
/// This is the single shape used across auth, profile, and anywhere else a
/// user needs to be represented — do not create a second, feature-local
/// user model.
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.photoUrl,
    this.selectedFandoms = const [],
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? photoUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Fandom categories the user picked on the post-registration Interests
  /// screen (e.g. "Anime", "Gaming"). Empty means they haven't been
  /// through that screen yet — see `AppRouter`'s `needsInterestsSelection`.
  final List<String> selectedFandoms;

  /// Builds a [UserModel] from a Firestore document map + its id.
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      role: UserRoleX.fromString(map['role'] as String?),
      selectedFandoms: (map['selectedFandoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      createdAt: _dateTimeFrom(map['createdAt']),
      updatedAt: _dateTimeFrom(map['updatedAt']),
    );
  }

  static DateTime _dateTimeFrom(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  /// Converts to a Firestore-writable map. Callers writing a *new*
  /// document should overwrite `createdAt`/`updatedAt` with
  /// `FieldValue.serverTimestamp()` rather than relying on the client
  /// clock — see `AuthRemoteDataSource.createUserDocument`.
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role.asString,
      'selectedFandoms': selectedFandoms,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? photoUrl,
    UserRole? role,
    List<String>? selectedFandoms,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      selectedFandoms: selectedFandoms ?? this.selectedFandoms,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        photoUrl,
        role,
        selectedFandoms,
        createdAt,
        updatedAt,
      ];
}
