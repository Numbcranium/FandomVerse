import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/event_model.dart';

/// Handles direct communication with the Firestore `events` collection.

class EventFirebaseDataSource {
  EventFirebaseDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore =
      firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>>
  get _eventsCollection =>
      _firestore.collection('events');

  /// Retrieves all events from Firestore.
  Future<List<EventModel>> getEvents() async {
    // Get all event documents.
    final snapshot = await _eventsCollection.get();

    // Convert Firestore documents into EventModels.
    return snapshot.docs
        .map(
          (doc) => EventModel.fromFirestore(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }

  /// Retrieves one event by its document ID.
  Future<EventModel?> getEventById(
      String eventId,
      ) async {
    final doc = await _eventsCollection
        .doc(eventId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return EventModel.fromFirestore(
      doc.id,
      doc.data()!,
    );
  }

  /// Creates an event in Firestore.
  Future<void> createEvent(
      EventModel event,
      ) async {
    await _eventsCollection
        .doc(event.id)
        .set(event.toFirestore());
  }

  /// Updates an existing event.
  Future<void> updateEvent(
      EventModel event,
      ) async {
    await _eventsCollection
        .doc(event.id)
        .update(event.toFirestore());
  }

  /// Deletes an event.
  Future<void> deleteEvent(
      String eventId,
      ) async {
    await _eventsCollection
        .doc(eventId)
        .delete();
  }
}