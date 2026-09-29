import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateSubmitted extends ProfileEvent {
  const ProfileUpdateSubmitted({
    required this.fullName,
    required this.phone,
    this.photoBytes,
    this.photoExtension,
  });

  final String fullName;
  final String phone;
  final Uint8List? photoBytes;
  final String? photoExtension;

  @override
  List<Object?> get props => [fullName, phone, photoBytes, photoExtension];
}

class ProfileErrorCleared extends ProfileEvent {
  const ProfileErrorCleared();
}
