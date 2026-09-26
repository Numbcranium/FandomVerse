import '../features/events/models/event_model.dart';

class EventsMock {
  static final List<EventModel> events = [
    EventModel(
      id: 'event_001',
      title: 'Marvels spiderman',
      category: 'Community',
      imageUrl:
      'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3',
      description:
      'A vibrant community festival featuring live music, cultural performances, food, games, and entertainment for everyone.',
      date: DateTime(2026, 10, 10),
      time: '12:00 PM - 10:00 PM',
      locationName: 'Pleasure Park',
      address: 'Port Harcourt, Rivers State',
      latitude: 4.8156,
      longitude: 7.0498,
      organizerName: 'Bola Events',
      price: 5000,
      ticketUrl: 'https://example.com/tickets/bola-festival',
      createdAt: DateTime(2026, 8, 1),
      updatedAt: DateTime(2026, 8, 1),
    ),

    EventModel(
      id: 'event_002',
      title: 'K-Pop Night',
      category: 'Music & K-Pop',
      imageUrl:
      'https://images.unsplash.com/photo-1501386761578-eac5c94b800a',
      description:
      'A night dedicated to K-Pop fans with music, dance performances, fan activities, games, and special performances.',
      date: DateTime(2026, 10, 17),
      time: '5:00 PM - 11:00 PM',
      locationName: 'Landmark Beach',
      address: 'Lagos, Lagos State',
      latitude: 6.4281,
      longitude: 3.4219,
      organizerName: 'K-Pop Nigeria',
      price: 7500,
      ticketUrl: 'https://example.com/tickets/kpop-night',
      createdAt: DateTime(2026, 8, 2),
      updatedAt: DateTime(2026, 8, 2),
    ),

    EventModel(
      id: 'event_003',
      title: 'Anime & Gaming Convention',
      category: 'Anime',
      imageUrl:
      'https://images.unsplash.com/photo-1542751371-adc38448a05e',
      description:
      'Meet fellow anime and gaming fans, enjoy cosplay competitions, gaming tournaments, merchandise, and interactive activities.',
      date: DateTime(2026, 10, 24),
      time: '10:00 AM - 7:00 PM',
      locationName: 'Eko Hotel Convention Centre',
      address: 'Victoria Island, Lagos',
      latitude: 6.4287,
      longitude: 3.4106,
      organizerName: 'Naija Anime Community',
      price: 3000,
      ticketUrl: 'https://example.com/tickets/anime-convention',
      createdAt: DateTime(2026, 8, 3),
      updatedAt: DateTime(2026, 8, 3),
    ),

    EventModel(
      id: 'event_004',
      title: 'Tech & Innovation Meetup',
      category: 'Community',
      imageUrl:
      'https://images.unsplash.com/photo-1515187029135-18ee286d815b',
      description:
      'Connect with developers, designers, founders, and technology enthusiasts while exploring new ideas and projects.',
      date: DateTime(2026, 10, 31),
      time: '2:00 PM - 6:00 PM',
      locationName: 'International Conference Centre',
      address: 'Ibadan, Oyo State',
      latitude: 7.3775,
      longitude: 3.9470,
      organizerName: 'Tech Ibadan',
      price: 0,
      ticketUrl: '',
      createdAt: DateTime(2026, 8, 4),
      updatedAt: DateTime(2026, 8, 4),
    ),

    EventModel(
      id: 'event_005',
      title: 'Comic & Cosplay Expo',
      category: 'Comics',
      imageUrl:
      'https://images.unsplash.com/photo-1608889825103-eb5ed706fc64',
      description:
      'A fun-filled comic and cosplay event featuring cosplay competitions, comic artists, games, photo sessions, and merchandise.',
      date: DateTime(2026, 11, 7),
      time: '11:00 AM - 8:00 PM',
      locationName: 'International Conference Centre',
      address: 'Abuja, FCT',
      latitude: 9.0579,
      longitude: 7.4951,
      organizerName: 'ComicCon Nigeria',
      price: 4500,
      ticketUrl: 'https://example.com/tickets/comic-expo',
      createdAt: DateTime(2026, 8, 5),
      updatedAt: DateTime(2026, 8, 5),
    ),

    EventModel(
      id: 'event_006',
      title: 'Movie Under The Stars',
      category: 'Movies & TV',
      imageUrl:
      'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba',
      description:
      'Enjoy a relaxing outdoor movie experience with friends, snacks, music, and a selection of popular movies.',
      date: DateTime(2026, 11, 14),
      time: '6:30 PM - 10:00 PM',
      locationName: 'Agodi Gardens',
      address: 'Ibadan, Oyo State',
      latitude: 7.4034,
      longitude: 3.9183,
      organizerName: 'Movie Nights NG',
      price: 2500,
      ticketUrl: 'https://example.com/tickets/movie-night',
      createdAt: DateTime(2026, 8, 6),
      updatedAt: DateTime(2026, 8, 6),
    ),

    EventModel(
      id: 'event_007',
      title: 'Gaming Tournament',
      category: 'Gaming',
      imageUrl:
      'https://images.unsplash.com/photo-1542751110-97427bbecf20',
      description:
      'Compete against other gamers in an exciting gaming tournament featuring popular competitive games and prizes.',
      date: DateTime(2026, 11, 21),
      time: '10:00 AM - 8:00 PM',
      locationName: 'The Zone',
      address: 'Gbagada, Lagos',
      latitude: 6.5590,
      longitude: 3.3925,
      organizerName: 'GameHub NG',
      price: 5000,
      ticketUrl: 'https://example.com/tickets/gaming',
      createdAt: DateTime(2026, 8, 7),
      updatedAt: DateTime(2026, 8, 7),
    ),

    EventModel(
      id: 'event_008',
      title: 'Live Music Weekend',
      category: 'Music & K-Pop',
      imageUrl:
      'https://images.unsplash.com/photo-1501612780327-45045538702b',
      description:
      'Spend the weekend enjoying live performances from upcoming Nigerian artists, DJs, and bands.',
      date: DateTime(2026, 11, 28),
      time: '4:00 PM - 11:00 PM',
      locationName: 'Muri Okunola Park',
      address: 'Victoria Island, Lagos',
      latitude: 6.4350,
      longitude: 3.4280,
      organizerName: 'Live Nation NG',
      price: 6000,
      ticketUrl: 'https://example.com/tickets/live-music',
      createdAt: DateTime(2026, 8, 8),
      updatedAt: DateTime(2026, 8, 8),
    ),
  ];

  static EventModel? getById(String id) {
    try {
      return events.firstWhere(
            (event) => event.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  static List<EventModel> getByCategory(String category) {
    if (category == 'All') {
      return events;
    }

    return events
        .where((event) => event.category == category)
        .toList();
  }

  static List<EventModel> getByDate(DateTime date) {
    return events.where((event) {
      return event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day;
    }).toList();
  }
}