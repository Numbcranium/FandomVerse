import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

import '../../data/datasources/event_firebase_datasource.dart';
import '../../data/datasources/event_sqlite_datasource.dart';

import '../../models/event_model.dart';
import '../../repositories/event_repository_impl.dart';
import '../../widgets/event_card.dart';
import '../bloc/events_cubit.dart';

/// Main Events screen.
///
/// Events are retrieved from Firebase through the repository.
/// Every event retrieved from Firebase is also cached in SQLite by the
/// repository implementation.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late final EventsCubit _eventsCubit;

  final TextEditingController _searchController =
  TextEditingController();

  String _selectedCategory = 'All';
  String _selectedPriceFilter = 'All';

  /// Categories displayed at the top of the Events screen.
  final List<String> _categories = const [
    'All',
    'Clubs',
    'Concerts',
    'Festivals',
    'Sports',
    'Comedy',
    'Cultural',
  ];

  @override
  void initState() {
    super.initState();

    // Create the repository with Firebase as the remote source
    // and SQLite as the local cache.
    final repository = EventRepositoryImpl(
      firebaseDataSource: EventFirebaseDataSource(),
      sqliteDataSource: EventSqliteDataSource(),
    );

    // Keep one Cubit instance for the lifetime of this screen.
    // This prevents it from being recreated whenever setState() runs.
    _eventsCubit = EventsCubit(repository);

    // Load events immediately when the screen opens.
    _eventsCubit.loadEvents();

    // Rebuild the search field whenever its text changes.
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _eventsCubit.close();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventsCubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildCategorySelector(),

              Expanded(
                child: BlocBuilder<EventsCubit, EventsState>(
                  builder: (context, state) {
                    if (state is EventsInitial ||
                        state is EventsLoading) {
                      return _buildLoadingState();
                    }

                    if (state is EventsError) {
                      return _buildErrorState(state.message);
                    }

                    if (state is EventsLoaded) {
                      return _buildEventsContent(state.events);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spaceLg,
        AppConstants.spaceMd,
        AppConstants.spaceLg,
        AppConstants.spaceMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Discover Events',
                  style: AppTextStyles.titleLarge,
                ),
              ),

              // Opens the event calendar.
              _buildHeaderIconButton(
                icon: Icons.calendar_month_outlined,
                tooltip: 'Calendar',
                onPressed: () {
                  context.pushNamed(
                    RouteNames.eventCalendarName,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spaceMd),

          _buildSearchField(),

          const SizedBox(height: AppConstants.spaceSm),

          Row(
            children: [
              // Nearby events button.
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.pushNamed(
                      RouteNames.nearbyEventsName,
                    );
                  },
                  icon: const Icon(
                    Icons.location_on_outlined,
                    size: 19,
                  ),
                  label: const Text('Nearby'),
                ),
              ),

              const SizedBox(width: AppConstants.spaceSm),

              // Filters button.
              OutlinedButton(
                onPressed: _openFilters,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(
                    AppConstants.spaceXl,
                    AppConstants.spaceXl,
                  ),
                  padding: const EdgeInsets.all(
                    AppConstants.spaceSm,
                  ),
                ),
                child: const Icon(
                  Icons.tune,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: AppTextStyles.bodyMedium,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search events...',
        hintStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        prefixIcon: const Icon(Icons.search),

        // Only show the clear button when the user has typed something.
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          onPressed: _searchController.clear,
          icon: const Icon(Icons.clear),
          tooltip: 'Clear search',
        )
            : null,
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: AppColors.textPrimaryDark,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY SELECTOR
  // ---------------------------------------------------------------------------

  Widget _buildCategorySelector() {
    return SizedBox(
      height: AppConstants.spaceXl + AppConstants.spaceSm,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceLg,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) {
          return const SizedBox(
            width: AppConstants.spaceSm,
          );
        },
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,

            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },

            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surfaceDark,

            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.borderDark,
            ),

            labelStyle: AppTextStyles.bodySmall.copyWith(
              color: isSelected
                  ? Colors.white
                  : AppColors.textSecondaryDark,
              fontWeight: FontWeight.w600,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.radiusPill,
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EVENTS CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildEventsContent(List<EventModel> events) {
    final filteredEvents = _filterEvents(events);

    if (filteredEvents.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceDark,

      // Pulling down reloads the latest events from Firebase.
      onRefresh: () async {
        await _eventsCubit.loadEvents();
      },

      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(
          AppConstants.spaceLg,
          AppConstants.spaceLg,
          AppConstants.spaceLg,
          AppConstants.spaceXxl,
        ),

        itemCount: filteredEvents.length,

        separatorBuilder: (_, __) {
          return const SizedBox(
            height: AppConstants.spaceMd,
          );
        },

        itemBuilder: (context, index) {
          final event = filteredEvents[index];

          return EventCard(
            event: event,

            // Open the event details screen.
            onTap: () {
              context.pushNamed(
                RouteNames.eventDetailsName,
                pathParameters: {
                  'eventId': event.id,
                },
              );
            },
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FILTERING
  // ---------------------------------------------------------------------------

  /// Applies category, search and price filters to Firebase events.
  List<EventModel> _filterEvents(List<EventModel> events) {
    final searchQuery =
    _searchController.text.trim().toLowerCase();

    return events.where((event) {
      // Category filter.
      final matchesCategory =
          _selectedCategory == 'All' ||
              event.category.toLowerCase() ==
                  _selectedCategory.toLowerCase();

      // Search filter.
      //
      // The search checks multiple useful event fields rather than
      // only checking the event title.
      final matchesSearch =
          searchQuery.isEmpty ||
              event.title.toLowerCase().contains(searchQuery) ||
              event.category.toLowerCase().contains(searchQuery) ||
              event.locationName.toLowerCase().contains(searchQuery) ||
              event.address.toLowerCase().contains(searchQuery) ||
              event.organizerName.toLowerCase().contains(searchQuery);

      // Price filter.
      final matchesPrice = _matchesPriceFilter(event);

      return matchesCategory &&
          matchesSearch &&
          matchesPrice;
    }).toList();
  }

  bool _matchesPriceFilter(EventModel event) {
    switch (_selectedPriceFilter) {
      case 'Free':
        return event.price == 0;

      case 'Under ₦5,000':
        return event.price > 0 && event.price < 5000;

      case '₦5,000 - ₦20,000':
        return event.price >= 5000 &&
            event.price <= 20000;

      case 'Above ₦20,000':
        return event.price > 20000;

      case 'All':
      default:
        return true;
    }
  }

  // ---------------------------------------------------------------------------
  // FILTER SCREEN
  // ---------------------------------------------------------------------------

  Future<void> _openFilters() async {
    final result = await context.pushNamed<Object?>(
      RouteNames.eventFiltersName,
    );

    if (!mounted || result == null) {
      return;
    }

    if (result is Map) {
      setState(() {
        final category = result['category']?.toString();
        final price = result['price']?.toString();

        if (category != null && category.isNotEmpty) {
          _selectedCategory = category;
        }

        if (price != null && price.isNotEmpty) {
          _selectedPriceFilter = price;
        }
      });
    }
  }

  // ---------------------------------------------------------------------------
  // LOADING STATE
  // ---------------------------------------------------------------------------

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ERROR STATE
  // ---------------------------------------------------------------------------

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.spaceLg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(
                AppConstants.spaceMd,
              ),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(
                  alpha: 0.12,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 32,
              ),
            ),

            const SizedBox(
              height: AppConstants.spaceMd,
            ),

            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),

            const SizedBox(
              height: AppConstants.spaceSm,
            ),

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),

            const SizedBox(
              height: AppConstants.spaceLg,
            ),

            ElevatedButton.icon(
              onPressed: () {
                _eventsCubit.loadEvents();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState() {
    final hasSearch =
        _searchController.text.trim().isNotEmpty;

    final hasFilters =
        _selectedCategory != 'All' ||
            _selectedPriceFilter != 'All';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.spaceLg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(
                AppConstants.spaceLg,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.12,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy_outlined,
                color: AppColors.primaryMuted,
                size: 36,
              ),
            ),

            const SizedBox(
              height: AppConstants.spaceLg,
            ),

            Text(
              hasSearch || hasFilters
                  ? 'No matching events'
                  : 'No events available',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),

            const SizedBox(
              height: AppConstants.spaceSm,
            ),

            Text(
              hasSearch || hasFilters
                  ? 'Try changing your search or filters.'
                  : 'There are no events to show right now.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),

            // Allow the user to quickly clear the filters/search.
            if (hasSearch || hasFilters) ...[
              const SizedBox(
                height: AppConstants.spaceLg,
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedCategory = 'All';
                    _selectedPriceFilter = 'All';
                  });
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}