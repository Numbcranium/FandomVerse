import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Stream<List<NotificationModel>> watchNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
  Future<void> markAllAsRead(String userId);
}

class FirestoreNotificationRemoteDataSource implements NotificationRemoteDataSource {
  FirestoreNotificationRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _notificationsRef =>
      _firestore.collection(FirebaseConstants.notificationsCollection);

  // Notifications are stored as a flat collection with a `userId` field
  // (rather than a `users/{uid}/notifications` subcollection) so a future
  // admin feature can query/write across all users without restructuring.
  Query<Map<String, dynamic>> _forUser(String userId) {
    return _notificationsRef
        .where('userId', isEqualTo: userId)
        .orderBy(FirebaseConstants.fieldCreatedAt, descending: true)
        .limit(AppConstants.defaultPageSize);
  }

  @override
  Stream<List<NotificationModel>> watchNotifications(String userId) {
    return _forUser(userId).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) {
    return _notificationsRef.doc(notificationId).update({'isRead': true});
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final unread = await _notificationsRef
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}
