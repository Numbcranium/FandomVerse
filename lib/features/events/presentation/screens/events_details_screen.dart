import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/event_firebase_datasource.dart';
import '../../data/datasources/event_sqlite_datasource.dart';
import '../../models/event_model.dart';
import '../../repositories/event_repository.dart';
import '../../repositories/event_repository_impl.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  State<EventDetailsScreen> createState() =>
      _EventDetailsScreenState();
}

class _EventDetailsScreenState
    extends State<EventDetailsScreen> {
  // Repository handles Firebase and SQLite communication.
  late final EventRepository _eventRepository;

  // Future used to load the selected event.
  late Future<EventModel?> _eventFuture;

  @override
  void initState() {
    super.initState();

    // Create the Firebase data source.
    final firebaseDataSource =
    EventFirebaseDataSource();

    // Create the SQLite data source.
    final sqliteDataSource =
    EventSqliteDataSource();

    // Connect Firebase and SQLite through the repository.
    _eventRepository = EventRepositoryImpl(
      firebaseDataSource: firebaseDataSource,
      sqliteDataSource: sqliteDataSource,
    );

    // Load the selected event from Firebase.
    _eventFuture = _loadEvent();
  }

  /// Retrieves the event using its Firestore document ID.
  Future<EventModel?> _loadEvent() {
    return _eventRepository.getEventById(
      widget.eventId,
    );
  }

  /// Reloads the event when the user taps retry.
  void _retry() {
    setState(() {
      _eventFuture = _loadEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent app bar sits over the event image.
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        // Back to the Events screen.
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),

        // More actions for the event.
        actions: [
          IconButton(
            tooltip: 'Share',
            onPressed: () {
              _showShareMessage(context);
            },
            icon: const Icon(
              Icons.share_outlined,
            ),
          ),
        ],
      ),

      body: FutureBuilder<EventModel?>(
        future: _eventFuture,
        builder: (context, snapshot) {
          // Event is still being retrieved.
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Something went wrong while retrieving the event.
          if (snapshot.hasError) {
            return _errorState();
          }

          // Firebase returned no event with this ID.
          final event = snapshot.data;

          if (event == null) {
            return _notFoundState();
          }

          // Event successfully loaded.
          return _buildEventDetails(event);
        },
      ),
    );
  }

  /// Builds the complete event details page.
  Widget _buildEventDetails(
      EventModel event,
      ) {
    return CustomScrollView(
      slivers: [
        // Large event image at the top of the page.
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          backgroundColor: AppColors.backgroundDark,
          automaticallyImplyLeading: false,

          flexibleSpace: FlexibleSpaceBar(
            background: _buildEventImage(event),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spaceMd,
              AppConstants.spaceLg,
              AppConstants.spaceMd,
              120,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // Event category.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusMd,
                    ),
                  ),
                  child: Text(
                    event.category,
                    style:
                    AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Event title.
                Text(
                  event.title,
                  style: AppTextStyles.headlineMedium,
                ),

                const SizedBox(height: 20),

                // Date and time.
                _infoTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'Date & Time',
                  value:
                  '${_formatDate(event.date)} • ${event.time}',
                ),

                const SizedBox(height: 12),

                // Venue.
                _infoTile(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  value:
                  '${event.locationName}\n${event.address}',
                ),

                const SizedBox(height: 12),

                // Organizer.
                _infoTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Organizer',
                  value: event.organizerName,
                ),

                const SizedBox(height: 28),

                // Description heading.
                Text(
                  'About this event',
                  style: AppTextStyles.titleLarge,
                ),

                const SizedBox(height: 10),

                // Event description retrieved from Firebase.
                Text(
                  event.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 28),

                // Map button.
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.pushNamed(
                        RouteNames.eventMapName,
                        queryParameters: {
                          'eventId': event.id,
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.map_outlined,
                    ),
                    label: const Text(
                      'View on Map',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Displays the event's network image.
  Widget _buildEventImage(
      EventModel event,
      ) {
    return CachedNetworkImage(
      imageUrl: event.imageUrl,
      fit: BoxFit.cover,

      // Display a loading indicator while the image loads.
      placeholder: (context, url) {
        return Container(
          color: AppColors.surfaceDark,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },

      // Display a fallback if the image URL fails.
      errorWidget: (context, url, error) {
        return Container(
          color: AppColors.surfaceDark,
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: AppColors.textSecondaryDark,
            ),
          ),
        );
      },
    );
  }

  /// Reusable information row used for date, location and organizer.
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        AppConstants.spaceMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(
          AppConstants.radiusMd,
        ),
        border: Border.all(
          color: AppColors.borderDark,
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primaryMuted,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                  AppTextStyles.bodySmall.copyWith(
                    color:
                    AppColors.textSecondaryDark,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Formats the DateTime into a readable date.
  String _formatDate(DateTime date) {
    return DateFormat(
      'EEEE, MMMM d, yyyy',
    ).format(date);
  }

  /// Error state when Firebase cannot load the event.
  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.spaceLg,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: AppColors.error,
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to load event',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Something went wrong while retrieving this event.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _retry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  /// State shown when the event ID does not exist in Firebase.
  Widget _notFoundState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.spaceLg,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: AppColors.textSecondaryDark,
            ),

            const SizedBox(height: 16),

            Text(
              'Event not found',
              style: AppTextStyles.titleLarge,
            ),

            const SizedBox(height: 8),

            Text(
              'This event may have been removed or is no longer available.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }


  void _showShareMessage(
      BuildContext context,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Event sharing.',
        ),
      ),
    );
  }
}