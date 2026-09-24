import 'dart:io';

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
    this.photoFile,
  });

  final String fullName;
  final String phone;
  final File? photoFile;

  @override
  List<Object?> get props => [fullName, phone, photoFile];
}

class ProfileErrorCleared extends ProfileEvent {
  const ProfileErrorCleared();
}
