import '../data/datasources/event_firebase_datasource.dart';
import '../data/datasources/event_sqlite_datasource.dart';
import '../models/event_model.dart';
import 'event_repository.dart';

/// Connects Firebase and SQLite.
///
/// READS:
/// Firebase → SQLite mirror → UI
///
/// WRITES:
/// Firebase + SQLite
class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl({
    required EventFirebaseDataSource firebaseDataSource,
    required EventSqliteDataSource sqliteDataSource,
  })  : _firebaseDataSource = firebaseDataSource,
        _sqliteDataSource = sqliteDataSource;

  final EventFirebaseDataSource _firebaseDataSource;
  final EventSqliteDataSource _sqliteDataSource;

  @override
  Future<List<EventModel>> getEvents() async {
    // Firebase is the source of truth for reads.
    final events = await _firebaseDataSource.getEvents();

    // Keep SQLite synchronized with the latest Firebase data.
    await _sqliteDataSource.insertEvents(events);

    return events;
  }

  @override
  Future<EventModel?> getEventById(String eventId) async {
    // Firebase is the source of truth.
    final event = await _firebaseDataSource.getEventById(eventId);

    if (event != null) {
      await _sqliteDataSource.insertEvent(event);
    }

    return event;
  }

  @override
  Future<void> createEvent(EventModel event) async {
    // Write to Firebase first.
    await _firebaseDataSource.createEvent(event);

    // Mirror the successful write locally.
    await _sqliteDataSource.insertEvent(event);
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    // Update Firebase first.
    await _firebaseDataSource.updateEvent(event);

    // Mirror the successful update locally.
    await _sqliteDataSource.updateEvent(event);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    // Delete from Firebase first.
    await _firebaseDataSource.deleteEvent(eventId);

    // Then remove the local copy.
    await _sqliteDataSource.deleteEvent(eventId);
  }
}