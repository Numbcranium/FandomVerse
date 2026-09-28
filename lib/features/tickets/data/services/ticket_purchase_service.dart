import 'dart:math';

import '../../../../core/services/merchandise/wallet_firebase_service.dart';
import '../../../../features/tickets/data/repositories/ticket_repository_impl.dart';
import '../../../events/models/event_model.dart';
import '../../models/ticket_model.dart';


class TicketPurchaseService {
  TicketPurchaseService({
    required TicketRepositoryImpl ticketRepository,
  }) : _ticketRepository = ticketRepository;

  final TicketRepositoryImpl _ticketRepository;

  /// Purchases a ticket using the user's existing wallet.
  ///
  /// The wallet is deducted first, then the ticket is saved to
  /// Firebase and SQLite.
  Future<TicketModel> purchaseTicket({
    required EventModel event,
    required String userId,
  }) async {
    final ticketId =
    DateTime.now().microsecondsSinceEpoch.toString();

    final ticketCode = _generateTicketCode();

    // Free events do not require wallet payment.
    if (event.price > 0) {
      await WalletFirebaseService.pay(event.price);
    }

    final ticket = TicketModel(
      id: ticketId,
      eventId: event.id,
      userId: userId,
      eventTitle: event.title,
      eventImageUrl: event.imageUrl,
      eventDate: event.date,
      eventTime: event.time,
      locationName: event.locationName,
      address: event.address,
      price: event.price,
      ticketCode: ticketCode,
      status: 'active',
      purchasedAt: DateTime.now(),
    );

    // Save the purchased ticket to Firebase and SQLite.
    await _ticketRepository.createTicket(ticket);

    return ticket;
  }

  /// Generates a short unique code that can also be encoded into the QR.
  String _generateTicketCode() {
    const characters =
        'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final random = Random.secure();

    final randomPart = List.generate(
      8,
          (_) => characters[
      random.nextInt(characters.length)],
    ).join();

    return 'CC-$randomPart';
  }
}