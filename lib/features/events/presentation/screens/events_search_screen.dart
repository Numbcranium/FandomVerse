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

class EventSearchScreen extends StatefulWidget {
  const EventSearchScreen({
    super.key,
  });

  @override
  State<EventSearchScreen> createState() =>
      _EventSearchScreenState();
}

class _EventSearchScreenState
    extends State<EventSearchScreen> {
  // Repository handles Firebase and SQLite.
  late final EventRepository _eventRepository;

  // Controller for the search input.
  final TextEditingController _searchController =
  TextEditingController();

  // Focus node allows us to automatically focus the
  // search field when the page opens.
  final FocusNode _searchFocusNode =
  FocusNode();

  // Future containing the events retrieved from Firebase.
  late Future<List<EventModel>> _eventsFuture;

  // Current search text.
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Create the Firebase data source.
    final firebaseDataSource =
    EventFirebaseDataSource();

    // Create the SQLite data source.
    final sqliteDataSource =
    EventSqliteDataSource();

    // Connect both data sources through the repository.
    _eventRepository = EventRepositoryImpl(
      firebaseDataSource: firebaseDataSource,
      sqliteDataSource: sqliteDataSource,
    );

    // Load events from Firebase.
    _eventsFuture = _loadEvents();

    // Focus the search box after the screen opens.
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (mounted) {
          _searchFocusNode.requestFocus();
        }
      },
    );
  }

  /// Gets all events from Firebase.
  Future<List<EventModel>> _loadEvents() {
    return _eventRepository.getEvents();
  }

  /// Reloads the event list.
  void _retry() {
    setState(() {
      _eventsFuture = _loadEvents();
    });
  }

  @override
  void dispose() {
    // Clean up controllers when the screen is removed.
    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Back to Events.
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),

        title: Text(
          'Search Events',
          style: AppTextStyles.titleLarge,
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search input section.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spaceMd,
                AppConstants.spaceSm,
                AppConstants.spaceMd,
                AppConstants.spaceMd,
              ),
              child: _buildSearchField(),
            ),

            // Search results.
            Expanded(
              child: FutureBuilder<List<EventModel>>(
                future: _eventsFuture,
                builder: (context, snapshot) {
                  // Firebase request is still running.
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Firebase request failed.
                  if (snapshot.hasError) {
                    return _errorState();
                  }

                  final events =
                      snapshot.data ?? [];

                  // Apply the search query to the
                  // Firebase events.
                  final filteredEvents =
                  _filterEvents(events);

                  // No matching events.
                  if (filteredEvents.isEmpty) {
                    return _emptyState();
                  }

                  // Display matching events.
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppConstants.spaceMd,
                      0,
                      AppConstants.spaceMd,
                      AppConstants.spaceLg,
                    ),
                    itemCount:
                    filteredEvents.length,
                    itemBuilder:
                        (context, index) {
                      final event =
                      filteredEvents[index];

                      return Padding(
                        padding:
                        const EdgeInsets.only(
                          bottom:
                          AppConstants.spaceMd,
                        ),
                        child: EventCard(
                          event: event,

                          // Open event details.
                          onTap: () {
                            context.pushNamed(
                              RouteNames
                                  .eventDetailsName,
                              pathParameters: {
                                'eventId': event.id,
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the search input.
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,

      // Update the search results as the user types.
      onChanged: (value) {
        setState(() {
          searchQuery = value.trim();
        });
      },

      textInputAction: TextInputAction.search,

      decoration: InputDecoration(
        hintText:
        'Search events, categories or locations...',
        prefixIcon: const Icon(
          Icons.search_rounded,
        ),

        // Clear the search query.
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
          tooltip: 'Clear search',
          onPressed: () {
            _searchController.clear();

            setState(() {
              searchQuery = '';
            });

            _searchFocusNode.requestFocus();
          },
          icon: const Icon(
            Icons.close_rounded,
          ),
        )
            : null,
      ),
    );
  }

  /// Filters the Firebase event list locally.
  ///
  /// The actual event data still comes from Firebase.
  /// Searching simply avoids making a new Firebase request
  /// for every character typed.
  List<EventModel> _filterEvents(
      List<EventModel> events,
      ) {
    // If the search field is empty, show every event.
    if (searchQuery.isEmpty) {
      return events;
    }

    final query = searchQuery.toLowerCase();

    return events.where((event) {
      // Search by event title.
      final title =
      event.title.toLowerCase();

      // Search by category.
      final category =
      event.category.toLowerCase();

      // Search by location name.
      final location =
      event.locationName.toLowerCase();

      // Search by address.
      final address =
      event.address.toLowerCase();

      // Search by organizer.
      final organizer =
      event.organizerName.toLowerCase();

      return title.contains(query) ||
          category.contains(query) ||
          location.contains(query) ||
          address.contains(query) ||
          organizer.contains(query);
    }).toList();
  }

  /// Displayed when there are no matching events.
  Widget _emptyState() {
    final hasSearch =
        searchQuery.isNotEmpty;

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
              Icons.search_off_rounded,
              size: 52,
              color: AppColors.textSecondaryDark,
            ),

            const SizedBox(height: 16),

            Text(
              hasSearch
                  ? 'No events found'
                  : 'No events available',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              hasSearch
                  ? 'Try searching for another event, category or location.'
                  : 'There are currently no events to display.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Displayed when Firebase fails to retrieve events.
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
              'Unable to load events',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Something went wrong while retrieving events.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Try the Firebase request again.
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
}