import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/event_firebase_datasource.dart';
import '../../data/datasources/event_sqlite_datasource.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/repositories/event_repository.dart';
import '../../models/event_model.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.eventId,
  });

  final String? eventId;

  @override
  State<MapScreen> createState() =>
      _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final EventRepository _eventRepository;

  late Future<List<EventModel>> _eventsFuture;

  // Map controller lets us move the map programmatically.
  final MapController _mapController =
  MapController();

  // Default center while the event data is loading.
  static const LatLng _defaultCenter = LatLng(
    6.5244,
    3.3792,
  );

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

  /// Finds a specific event from the Firebase event list.
  EventModel? _findSelectedEvent(
      List<EventModel> events,
      ) {
    if (widget.eventId == null) {
      return null;
    }

    for (final event in events) {
      if (event.id == widget.eventId) {
        return event;
      }
    }

    return null;
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
          'Event Map',
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
            return Center(
              child: Text(
                'Unable to load event locations.',
                style: AppTextStyles.bodyMedium,
              ),
            );
          }

          final events = snapshot.data ?? [];

          final selectedEvent =
          _findSelectedEvent(events);

          // If a specific event was requested, center
          // the map around that event.
          final center = selectedEvent != null
              ? LatLng(
            selectedEvent.latitude,
            selectedEvent.longitude,
          )
              : _defaultCenter;

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: center,
                  initialZoom:
                  selectedEvent != null
                      ? 15
                      : 11,
                ),

                children: [
                  // OpenStreetMap map tiles.
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                    'com.clubconnect.app',
                  ),

                  // Event markers.
                  MarkerLayer(
                    markers: events.map(
                          (event) {
                        return Marker(
                          point: LatLng(
                            event.latitude,
                            event.longitude,
                          ),
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              _showEventPreview(
                                event,
                              );
                            },
                            child: Container(
                              decoration:
                              BoxDecoration(
                                color:
                                AppColors.primary,
                                shape:
                                BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.event,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),

              // Small map information card.
              Positioned(
                left: AppConstants.spaceMd,
                right: AppConstants.spaceMd,
                bottom: AppConstants.spaceMd,
                child: Container(
                  padding:
                  const EdgeInsets.all(
                    AppConstants.spaceMd,
                  ),
                  decoration: BoxDecoration(
                    color:
                    AppColors.surfaceDark,
                    borderRadius:
                    BorderRadius.circular(
                      AppConstants.radiusLg,
                    ),
                    border: Border.all(
                      color:
                      AppColors.borderDark,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color:
                        AppColors.primaryMuted,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${events.length} event${events.length == 1 ? '' : 's'} on the map',
                          style:
                          AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Displays a small event preview when a marker is tapped.
  void _showEventPreview(
      EventModel event,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            AppConstants.radiusLg,
          ),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(
            AppConstants.spaceLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style:
                AppTextStyles.titleLarge,
              ),

              const SizedBox(height: 8),

              Text(
                event.locationName,
                style:
                AppTextStyles.bodyMedium,
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    context.pushNamed(
                      RouteNames.eventDetailsName,
                      pathParameters: {
                        'eventId': event.id,
                      },
                    );
                  },
                  child: const Text(
                    'View Event',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}