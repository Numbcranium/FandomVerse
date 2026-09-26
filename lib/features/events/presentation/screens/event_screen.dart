import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/datasources/event_firebase_datasource.dart';
import '../../data/datasources/event_sqlite_datasource.dart';
import '../../models/event_model.dart';
import '../../repositories/event_repository.dart';
import '../../repositories/event_repository_impl.dart';
import '../../widgets/event_card.dart';
import '../bloc/events_cubit.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // Repository handles communication between Firebase and SQLite.
  late final EventRepository _eventRepository;

  // Keep the Cubit alive for the lifetime of this screen.
  // This prevents the events from being reloaded every time
  // the user changes the selected category.
  late final EventsCubit _eventsCubit;

  // Currently selected event category.
  String selectedCategory = 'All';

  // Categories displayed in the horizontal filter list.
  final categories = const [
    'All',
    'Anime',
    'Gaming',
    'Movies & TV',
    'Music & K-Pop',
    'Comics',
    'Community',
  ];

  @override
  void initState() {
    super.initState();

    // Create the Firebase data source.
    final firebaseDataSource = EventFirebaseDataSource();

    // Create the SQLite data source.
    final sqliteDataSource = EventSqliteDataSource();

    // Connect both data sources through the repository.
    _eventRepository = EventRepositoryImpl(
      firebaseDataSource: firebaseDataSource,
      sqliteDataSource: sqliteDataSource,
    );

    // Create the Cubit and load events immediately.
    _eventsCubit = EventsCubit(_eventRepository)
      ..loadEvents();
  }

  @override
  void dispose() {
    // Close the Cubit when the screen is removed.
    _eventsCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventsCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Events',
            style: AppTextStyles.titleLarge,
          ),

          // Event-related actions on the app bar.
          actions: [
            // Open event search.
            IconButton(
              tooltip: 'Search',
              onPressed: () {
                context.pushNamed(
                  RouteNames.eventSearchName,
                );
              },
              icon: const Icon(
                Icons.search_rounded,
              ),
            ),

            // Open event calendar.
            IconButton(
              tooltip: 'Calendar',
              onPressed: () {
                context.pushNamed(
                  RouteNames.eventCalendarName,
                );
              },
              icon: const Icon(
                Icons.calendar_month_outlined,
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: BlocBuilder<EventsCubit, EventsState>(
            builder: (context, state) {
              // Show loading indicator while Firebase data is being fetched.
              if (state is EventsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Show an error message if Firebase loading fails.
              if (state is EventsError) {
                return _errorState(
                  context,
                  state.message,
                );
              }

              // Display the events after they have been loaded.
              if (state is EventsLoaded) {
                return _buildEventsContent(
                  context,
                  state.events,
                );
              }

              // Initial state before the first load begins.
              return const SizedBox.shrink();
            },
          ),
        ),

        // Use the existing application bottom navigation.
        // Events is index 2 in the current navigation.
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 2,
          onTap: (index) {
            _onBottomNavTapped(
              context,
              index,
            );
          },
        ),
      ),
    );
  }

  /// Builds the main Events page after events have been loaded.
  Widget _buildEventsContent(
      BuildContext context,
      List<EventModel> events,
      ) {
    // Filter the Firebase events according to the selected category.
    final filteredEvents = selectedCategory == 'All'
        ? events
        : events
        .where(
          (event) => event.category == selectedCategory,
    )
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spaceMd,
        AppConstants.spaceSm,
        AppConstants.spaceMd,
        AppConstants.spaceLg,
      ),
      children: [
        // Page heading.
        Text(
          'Discover Events',
          style: AppTextStyles.headlineMedium,
        ),

        const SizedBox(height: 6),

        // Short description below the heading.
        Text(
          'Find fandom events happening around you.',
          style: AppTextStyles.bodyMedium,
        ),

        const SizedBox(
          height: AppConstants.spaceLg,
        ),

        // Horizontal event category filters.
        _buildCategoryFilters(),

        const SizedBox(
          height: AppConstants.spaceLg,
        ),

        // Upcoming events heading and Nearby button.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Events',
              style: AppTextStyles.titleLarge,
            ),

            // Open nearby events.
            TextButton(
              onPressed: () {
                context.pushNamed(
                  RouteNames.nearbyEventsName,
                );
              },
              child: const Text('Nearby'),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Display the filtered events.
        if (filteredEvents.isEmpty)
          _emptyState()
        else
          ...filteredEvents.map(
                (event) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppConstants.spaceMd,
              ),

              // Reusable event card.
              child: EventCard(
                event: event,

                // Open the selected event's details page.
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
  }

  /// Builds the horizontally scrollable category chips.
  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,

        // Space between category chips.
        separatorBuilder: (_, __) =>
        const SizedBox(width: 8),

        itemBuilder: (context, index) {
          final category = categories[index];

          // Check whether this category is currently selected.
          final selected = selectedCategory == category;

          return ChoiceChip(
            label: Text(category),
            selected: selected,

            // Update the selected category.
            onSelected: (_) {
              setState(() {
                selectedCategory = category;
              });
            },

            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surfaceDark,

            side: BorderSide(
              color: selected
                  ? AppColors.primary
                  : AppColors.borderDark,
            ),

            labelStyle: AppTextStyles.bodySmall.copyWith(
              color: selected
                  ? Colors.white
                  : AppColors.textSecondaryDark,
              fontWeight: selected
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          );
        },
      ),
    );
  }

  /// Displays an empty state when no events match the category.
  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(
        AppConstants.spaceLg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(
          AppConstants.radiusLg,
        ),
        border: Border.all(
          color: AppColors.borderDark,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_busy_outlined,
            size: 42,
            color: AppColors.textSecondaryDark,
          ),

          const SizedBox(height: 12),

          Text(
            'No events found',
            style: AppTextStyles.titleMedium,
          ),

          const SizedBox(height: 5),

          Text(
            'Try selecting another category.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Displays an error state when events cannot be loaded.
  Widget _errorState(
      BuildContext context,
      String message,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.spaceLg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: AppColors.error,
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to load events',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Retry Firebase request.
            ElevatedButton.icon(
              onPressed: () {
                context.read<EventsCubit>().loadEvents();
              },
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

  /// Handles navigation from the existing bottom navigation bar.
  void _onBottomNavTapped(
      BuildContext context,
      int index,
      ) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;

      case 1:
      // Keep your existing Explore route here.
      // Replace this with the canonical Explore route name
      // if it already exists in your route_names.dart.
        break;

      case 2:
      // Already on Events.
        break;

      case 3:
      // Keep your existing Shop route here.
        break;

      case 4:
        context.go(RouteNames.profile);
        break;
    }
  }
}