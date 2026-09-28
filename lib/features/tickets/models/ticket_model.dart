class TicketModel {
  final String id;
  final String eventId;
  final String userId;

  final String eventTitle;
  final String eventImageUrl;

  final DateTime eventDate;
  final String eventTime;

  final String locationName;
  final String address;

  final double price;

  final String ticketCode;
  final String status;

  final DateTime purchasedAt;

  const TicketModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.eventTitle,
    required this.eventImageUrl,
    required this.eventDate,
    required this.eventTime,
    required this.locationName,
    required this.address,
    required this.price,
    required this.ticketCode,
    required this.status,
    required this.purchasedAt,
  });

  // Converts a SQLite/local map into a TicketModel.
  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id']?.toString() ?? '',
      eventId: map['eventId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      eventTitle: map['eventTitle']?.toString() ?? '',
      eventImageUrl: map['eventImageUrl']?.toString() ?? '',
      eventDate: DateTime.parse(
        map['eventDate'].toString(),
      ),
      eventTime: map['eventTime']?.toString() ?? '',
      locationName: map['locationName']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      ticketCode: map['ticketCode']?.toString() ?? '',
      status: map['status']?.toString() ?? 'active',
      purchasedAt: DateTime.parse(
        map['purchasedAt'].toString(),
      ),
    );
  }

  // Converts the model into a map for SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'eventTitle': eventTitle,
      'eventImageUrl': eventImageUrl,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime,
      'locationName': locationName,
      'address': address,
      'price': price,
      'ticketCode': ticketCode,
      'status': status,
      'purchasedAt': purchasedAt.toIso8601String(),
    };
  }

  // Creates a TicketModel from a Firestore document.
  factory TicketModel.fromFirestore(
      String documentId,
      Map<String, dynamic> data,
      ) {
    return TicketModel(
      id: documentId,
      eventId: data['eventId']?.toString() ?? '',
      userId: data['userId']?.toString() ?? '',
      eventTitle: data['eventTitle']?.toString() ?? '',
      eventImageUrl: data['eventImageUrl']?.toString() ?? '',
      eventDate: DateTime.parse(
        data['eventDate'].toString(),
      ),
      eventTime: data['eventTime']?.toString() ?? '',
      locationName: data['locationName']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      ticketCode: data['ticketCode']?.toString() ?? '',
      status: data['status']?.toString() ?? 'active',
      purchasedAt: DateTime.parse(
        data['purchasedAt'].toString(),
      ),
    );
  }

  // Converts the ticket into the Firestore document format.
  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'userId': userId,
      'eventTitle': eventTitle,
      'eventImageUrl': eventImageUrl,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime,
      'locationName': locationName,
      'address': address,
      'price': price,
      'ticketCode': ticketCode,
      'status': status,
      'purchasedAt': purchasedAt.toIso8601String(),
    };
  }
}