class EventModel {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String description;
  final DateTime date;
  final String time;
  final String locationName;
  final String address;
  final double latitude;
  final double longitude;
  final String organizerName;
  final double price;
  final String ticketUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.date,
    required this.time,
    required this.locationName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.organizerName,
    required this.price,
    required this.ticketUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      date: DateTime.parse(map['date'].toString()),
      time: map['time']?.toString() ?? '',
      locationName: map['locationName']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      organizerName: map['organizerName']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      ticketUrl: map['ticketUrl']?.toString() ?? '',
      createdAt: DateTime.parse(
        map['createdAt']?.toString() ??
            DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt']?.toString() ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'date': date.toIso8601String(),
      'time': time,
      'locationName': locationName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'organizerName': organizerName,
      'price': price,
      'ticketUrl': ticketUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory EventModel.fromFirestore(
      String documentId,
      Map<String, dynamic> data,
      ) {
    return EventModel(
      id: documentId,
      title: data['title']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      date: DateTime.parse(data['date'].toString()),
      time: data['time']?.toString() ?? '',
      locationName: data['locationName']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      organizerName: data['organizerName']?.toString() ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      ticketUrl: data['ticketUrl']?.toString() ?? '',
      createdAt: DateTime.parse(
        data['createdAt']?.toString() ??
            DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        data['updatedAt']?.toString() ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'date': date.toIso8601String(),
      'time': time,
      'locationName': locationName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'organizerName': organizerName,
      'price': price,
      'ticketUrl': ticketUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}