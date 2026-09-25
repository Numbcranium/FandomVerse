import '../models/event_model.dart';

abstract class EventRepository {
  Future<List<EventModel>> getEvents();

  Future<EventModel?> getEventById(String eventId);

  Future<void> createEvent(EventModel event);

  Future<void> updateEvent(EventModel event);

  Future<void> deleteEvent(String eventId);
}