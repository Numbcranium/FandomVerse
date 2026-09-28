import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/event_firebase_datasource.dart';
import '../../data/datasources/event_sqlite_datasource.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/repositories/event_repository.dart';
import '../../models/event_model.dart';
import '../widgets/event_card.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() =>
      _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Repository handles Firebase and SQLite.
  late final EventRepository _eventRepository;

  // Future containing events retrieved from Firebase.
  late Future<List<EventModel>> _eventsFuture;

  // The date currently selected by the user.
  DateTime selectedDate = DateTime.now();

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

    // Retrieve events from Firebase.
    _eventsFuture = _loadEvents();
  }

  /// Loads all events from Firebase.
  Future<List<EventModel>> _loadEvents() {
    return _eventRepository.getEvents();
  }

  /// Reloads events after an error.
  void _retry() {
    setState(() {
      _eventsFuture = _loadEvents();
    });
  }

  /// Returns events occurring on the selected date.
  List<EventModel> _eventsForSelectedDate(
      List<EventModel> events,
      ) {
    return events.where((event) {
      return event.date.year == selectedDate.year &&
          event.date.month == selectedDate.month &&
          event.date.day == selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        title: Text(
          'Event Calendar',
          style: AppTextStyles.titleLarge.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),

      body: FutureBuilder<List<EventModel>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          // Firebase is still loading.
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Firebase request failed.
          if (snapshot.hasError) {
            return _errorState();
          }

          final events = snapshot.data ?? [];

          // Filter Firebase events by selected date.
          final selectedEvents =
          _eventsForSelectedDate(events);

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spaceMd,
              AppConstants.spaceSm,
              AppConstants.spaceMd,
              AppConstants.spaceLg,
            ),
            children: [
              // Month selector.
              _buildDateSelector(),

              SizedBox(
                height: AppConstants.spaceLg,
              ),

              Text(
                DateFormat(
                  'EEEE, MMMM d',
                ).format(selectedDate),
                style: AppTextStyles.titleLarge.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),

              SizedBox(height: 12),

              // Events for the selected day.
              if (selectedEvents.isEmpty)
                _emptyState()
              else
                ...selectedEvents.map(
                      (event) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.spaceMd,
                    ),
                    child: EventCard(
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
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Displays a horizontal date selector.
  Widget _buildDateSelector() {
    final today = DateTime.now();

    return SizedBox(
      height: 92,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30,
        itemBuilder: (context, index) {
          final date = DateTime(
            today.year,
            today.month,
            today.day + index,
          );

          final isSelected =
              date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              width: 64,
              margin: const EdgeInsets.only(
                right: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(
                  AppConstants.radiusMd,
                ),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '${date.day}',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Empty state for a date without events.
  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(
        AppConstants.spaceLg,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(
          AppConstants.radiusLg,
        ),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 44,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          SizedBox(height: 12),
          Text(
            'No events on this date',
            style: AppTextStyles.titleMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          SizedBox(height: 6),
          Text(
            'Try selecting another date.',
            style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Error state with retry.
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
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: AppColors.error,
            ),
            SizedBox(height: 16),
            Text(
              'Unable to load events',
              style: AppTextStyles.titleLarge.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            SizedBox(height: 8),
            Text(
              'Something went wrong while retrieving events.',
              style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _retry,
              icon: Icon(
                Icons.refresh_rounded,
              ),
              label: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}