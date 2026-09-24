import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// A single in-app notification, mirrored from Firestore.
///
/// `type` is a free-form string rather than an enum since what
/// notification types exist is entirely domain-specific (booking
/// confirmed, message received, appointment reminder, ...) and won't be
/// known until the SRS arrives.
class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    final createdAtRaw = map['createdAt'];
    return NotificationModel(
      id: id,
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      type: map['type'] as String? ?? 'general',
      isRead: map['isRead'] as bool? ?? false,
      createdAt: createdAtRaw is Timestamp ? createdAtRaw.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, message, type, isRead, createdAt];
}
