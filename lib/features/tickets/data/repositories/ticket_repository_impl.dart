import '../../domain/repositories/ticket_repository.dart';
import '../../models/ticket_model.dart';
import '../datasources/ticket_firebase_datasource.dart';
import '../datasources/ticket_sqlite_datasource.dart';

class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl({
    required TicketFirebaseDataSource firebaseDataSource,
    required TicketSqliteDataSource sqliteDataSource,
  })  : _firebaseDataSource = firebaseDataSource,
        _sqliteDataSource = sqliteDataSource;

  final TicketFirebaseDataSource _firebaseDataSource;
  final TicketSqliteDataSource _sqliteDataSource;

  @override
  Future<void> createTicket(
      TicketModel ticket,
      ) async {
    // Firebase is the primary source of truth.
    await _firebaseDataSource.createTicket(ticket);

    // SQLite receives the same ticket for local storage.
    await _sqliteDataSource.insertTicket(ticket);
  }

  @override
  Future<TicketModel?> getTicketById(
      String ticketId,
      ) async {
    // Tickets are retrieved from Firebase first.
    final ticket = await _firebaseDataSource.getTicketById(
      ticketId,
    );

    // Mirror the latest Firebase version locally.
    if (ticket != null) {
      await _sqliteDataSource.insertTicket(ticket);
    }

    return ticket;
  }

  @override
  Future<List<TicketModel>> getCurrentUserTickets() async {
    // Firebase remains the primary read source.
    final tickets =
    await _firebaseDataSource.getCurrentUserTickets();

    // Keep SQLite synchronized.
    await _sqliteDataSource.insertTickets(tickets);

    return tickets;
  }
}