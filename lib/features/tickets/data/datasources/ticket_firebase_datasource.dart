import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techwiz7_starter/features/tickets/data/datasources/ticket_sqlite_datasource.dart';

import '../../models/ticket_model.dart';


class TicketFirebaseDataSource {
  TicketFirebaseDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _ticketsCollection =>
      _firestore.collection('tickets');

  String get _currentUserId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    return user.uid;
  }

  // Creates a new ticket in Firestore.
  Future<void> createTicket(TicketModel ticket) async {
    await _ticketsCollection.doc(ticket.id).set(
      ticket.toFirestore(),
    );
  }

  // Retrieves one ticket by its ID.
  Future<TicketModel?> getTicketById(String ticketId) async {
    final document = await _ticketsCollection.doc(ticketId).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return TicketModel.fromFirestore(
      document.id,
      document.data()!,
    );
  }

  // Retrieves all tickets belonging to the logged-in user.
  Future<List<TicketModel>> getCurrentUserTickets() async {
    final snapshot = await _ticketsCollection
        .where(
      'userId',
      isEqualTo: _currentUserId,
    )
        .get();

    final tickets = snapshot.docs
        .map(
          (doc) => TicketModel.fromFirestore(
        doc.id,
        doc.data(),
      ),
    )
        .toList();

    // Sort locally so we do not need a Firestore composite index.
    tickets.sort(
          (a, b) => b.purchasedAt.compareTo(a.purchasedAt),
    );

    return tickets;
  }
}