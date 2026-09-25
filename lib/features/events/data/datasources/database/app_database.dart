import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Provides the application's local SQLite database.
///
/// Firebase remains the source of truth when retrieving events.
/// SQLite keeps a local copy of the retrieved data.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    // Return the existing database if it has already been opened.
    if (_database != null) {
      return _database!;
    }

    // Initialize the database before opening it.
    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Windows and Linux require the SQLite FFI implementation.
    //
    // Android and iOS use their normal native SQLite implementation,
    // so we only change the database factory on desktop platforms.
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
    }

    // Get the platform-specific database directory.
    final databasesPath = await getDatabasesPath();

    // Create the full path for the ClubConnect database.
    final path = join(
      databasesPath,
      'clubconnect.db',
    );

    // Open the database and create the tables if this
    // is the first time the database is being opened.
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Creates the database tables.
  Future<void> _onCreate(
      Database db,
      int version,
      ) async {
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
}