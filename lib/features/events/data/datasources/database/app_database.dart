import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(
      databasesPath,
      'clubconnect.db',
    );

    return openDatabase(
      path,

      // Version 2 because we are adding the tickets table.
      version: 2,

      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(
      Database db,
      int version,
      ) async {
    await _createEventsTable(db);
    await _createTicketsTable(db);
  }

  // Handles existing installations that already have version 1.
  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    if (oldVersion < 2) {
      await _createTicketsTable(db);
    }
  }

  // Existing events table.
  Future<void> _createEventsTable(Database db) async {
    await db.execute('''
      CREATE TABLE events (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        locationName TEXT NOT NULL,
        address TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        organizerName TEXT NOT NULL,
        price REAL NOT NULL,
        ticketUrl TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // New tickets table.
  Future<void> _createTicketsTable(Database db) async {
    await db.execute('''
      CREATE TABLE tickets (
        id TEXT PRIMARY KEY,
        eventId TEXT NOT NULL,
        userId TEXT NOT NULL,
        eventTitle TEXT NOT NULL,
        eventImageUrl TEXT NOT NULL,
        eventDate TEXT NOT NULL,
        eventTime TEXT NOT NULL,
        locationName TEXT NOT NULL,
        address TEXT NOT NULL,
        price REAL NOT NULL,
        ticketCode TEXT NOT NULL,
        status TEXT NOT NULL,
        purchasedAt TEXT NOT NULL
      )
    ''');
  }
}