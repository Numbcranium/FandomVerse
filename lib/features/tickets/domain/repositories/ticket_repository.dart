import '../../models/ticket_model.dart';

abstract class TicketRepository {
  Future<void> createTicket(TicketModel ticket);

  Future<TicketModel?> getTicketById(
      String ticketId,
      );

  Future<List<TicketModel>> getCurrentUserTickets();
}