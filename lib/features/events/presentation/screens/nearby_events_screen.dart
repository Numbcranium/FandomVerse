import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/event_firebase_datasource.dart';
import '../../data/datasources/event_sqlite_datasource.dart';
import '../../models/event_model.dart';
import '../../repositories/event_repository.dart';
import '../../repositories/event_repository_impl.dart';
import '../../widgets/event_card.dart';

class NearbyEventsScreen extends StatefulWidget {
  const NearbyEventsScreen({super.key});

  @override
  State<NearbyEventsScreen> createState() =>
      _NearbyEventsScreenState();
}

class _NearbyEventsScreenState
    extends State<NearbyEventsScreen> {
  late final EventRepository _eventRepository;

  late Future<List<EventModel>> _eventsFuture;

  // Default location used while location permission is not
  // being requested yet.
  //
  // Lagos coordinates are used as the initial reference point.
  double userLatitude = 6.5244;
  double userLongitude = 3.3792;

  @override
  void initState() {
    super.initState();

    final firebaseDataSource =
    EventFirebaseDataSource();

    final sqliteDataSource =
    EventSqliteDataSource();

    _eventRepository = EventRepositoryImpl(
      firebaseDataSource: firebaseDataSource,
      sqliteDataSource: sqliteDataSource,
    );

    _eventsFuture = _loadEvents();
  }

  Future<List<EventModel>> _loadEvents() {
    return _eventRepository.getEvents();
  }

  /// Calculates the distance between the user and an event.
  double _distanceInKilometers(
      double latitude,
      double longitude,
      ) {
    const earthRadius = 6371.0;

    final lat1 = userLatitude * pi / 180;
    final lat2 = latitude * pi / 180;

    final deltaLat =
        (latitude - userLatitude) * pi / 180;
    final deltaLon =
        (longitude - userLongitude) * pi / 180;

    final a = sin(deltaLat / 2) *
        sin(deltaLat / 2) +
        cos(lat1) *
            cos(lat2) *
            sin(deltaLon / 2) *
            sin(deltaLon / 2);

    final c =
        2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Sorts events according to their distance from the
  /// current reference location.
  List<EventModel> _sortByDistance(
      List<EventModel> events,
      ) {
    final sorted = [...events];

    sorted.sort((a, b) {
      final distanceA = _distanceInKilometers(
        a.latitude,
        a.longitude,
      );

      final distanceB = _distanceInKilometers(
        b.latitude,
        b.longitude,
      );

      return distanceA.compareTo(distanceB);
    });

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        title: Text(
          'Nearby Events',
          style: AppTextStyles.titleLarge,
        ),
      ),

      body: FutureBuilder<List<EventModel>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _errorState();
          }

          final events =
          _sortByDistance(snapshot.data ?? []);

          if (events.isEmpty) {
            return _emptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(
              AppConstants.spaceMd,
            ),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              final distance =
              _distanceInKilometers(
                event.latitude,
                event.longitude,
              );

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.spaceMd,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // Distance indicator.
                    Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 6,
                      ),
                      child: Text(
                        '${distance.toStringAsFixed(1)} km away',
                        style:
                        AppTextStyles.bodySmall.copyWith(
                          color:
                          AppColors.primaryMuted,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),

                    EventCard(
                      event: event,
                      onTap: () {
                        context.pushNamed(
                          RouteNames.eventDetailsName,
                          pathParameters: {
                            'eventId': event.id,
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.spaceLg,
        ),
        child: Text(
          'No nearby events found.',
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.spaceLg,
        ),
        child: Text(
          'Unable to load nearby events.',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}