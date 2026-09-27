import 'package:sqflite/sqflite.dart';

import '../../models/event_model.dart';
import 'database/app_database.dart';

/// Handles local SQLite storage for events.
///
/// This is the local mirror of the Firestore event data.
class EventSqliteDataSource {
  EventSqliteDataSource({
    AppDatabase? database,
  }) : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  /// Saves an event locally.
  ///
  /// If the event already exists, its local copy is replaced.
  Future<void> insertEvent(EventModel event) async {
    final db = await _database.database;

    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Saves multiple events locally.
  Future<void> insertEvents(List<EventModel> events) async {
    final db = await _database.database;

    final batch = db.batch();

    for (final event in events) {
      batch.insert(
        'events',
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// Retrieves all locally stored events.
  Future<List<EventModel>> getEvents() async {
    final db = await _database.database;

    final rows = await db.query(
      'events',
      orderBy: 'date ASC',
    );

    return rows.map(EventModel.fromMap).toList();
  }

  /// Retrieves one locally stored event.
  Future<EventModel?> getEventById(String eventId) async {
    final db = await _database.database;

    final rows = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [eventId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return EventModel.fromMap(rows.first);
  }

  /// Updates a locally stored event.
  Future<void> updateEvent(EventModel event) async {
    final db = await _database.database;

    await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  /// Deletes a locally stored event.
  Future<void> deleteEvent(String eventId) async {
    final db = await _database.database;

    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }
}