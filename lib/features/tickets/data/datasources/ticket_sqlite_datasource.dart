import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../../events/data/datasources/database/app_database.dart';
import '../../models/ticket_model.dart';

class TicketSqliteDataSource {
  TicketSqliteDataSource({
    AppDatabase? database,
  }) : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  // Saves a ticket locally.
  Future<void> insertTicket(TicketModel ticket) async {
    if (kIsWeb) return;
    final db = await _database.database;

    await db.insert(
      'tickets',
      ticket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Saves multiple tickets locally.
  Future<void> insertTickets(
      List<TicketModel> tickets,
      ) async {
    if (kIsWeb) return;
    final db = await _database.database;

    final batch = db.batch();

    for (final ticket in tickets) {
      batch.insert(
        'tickets',
        ticket.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(
      noResult: true,
    );
  }

  // Retrieves a locally stored ticket.
  Future<TicketModel?> getTicketById(
      String ticketId,
      ) async {
    if (kIsWeb) return null;
    final db = await _database.database;

    final rows = await db.query(
      'tickets',
      where: 'id = ?',
      whereArgs: [ticketId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return TicketModel.fromMap(rows.first);
  }

  // Retrieves all locally stored tickets for a user.
  Future<List<TicketModel>> getTicketsForUser(
      String userId,
      ) async {
    if (kIsWeb) return [];
    final db = await _database.database;

    final rows = await db.query(
      'tickets',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'purchasedAt DESC',
    );

    return rows
        .map(
      TicketModel.fromMap,
    )
        .toList();
  }
}