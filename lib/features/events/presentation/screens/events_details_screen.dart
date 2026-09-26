import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/merchandise/wallet_firebase_service.dart';
import '../../../tickets/data/datasources/ticket_firebase_datasource.dart';
import '../../../tickets/data/datasources/ticket_sqlite_datasource.dart';
import '../../../tickets/data/repositories/ticket_repository_impl.dart';
import '../../../tickets/data/services/ticket_purchase_service.dart';
import '../../../tickets/models/ticket_model.dart';
import '../../data/datasources/event_firebase_datasource.dart';
import '../../data/datasources/event_sqlite_datasource.dart';
import '../../models/event_model.dart';
import '../../repositories/event_repository_impl.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late final EventRepositoryImpl _eventRepository;
  late final TicketRepositoryImpl _ticketRepository;
  late final TicketPurchaseService _ticketPurchaseService;

  EventModel? _event;

  bool _isLoading = true;
  bool _isPurchasingTicket = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Event repository:
    // Firebase is the source of truth and SQLite stores a local copy.
    _eventRepository = EventRepositoryImpl(
      firebaseDataSource: EventFirebaseDataSource(),
      sqliteDataSource: EventSqliteDataSource(),
    );

    // Ticket repository:
    // Tickets are written to Firebase and SQLite.
    _ticketRepository = TicketRepositoryImpl(
      firebaseDataSource: TicketFirebaseDataSource(),
      sqliteDataSource: TicketSqliteDataSource(),
    );

    // Handles wallet payment and ticket creation.
    _ticketPurchaseService = TicketPurchaseService(
      ticketRepository: _ticketRepository,
    );

    _loadEvent();
  }

  // ---------------------------------------------------------------------------
  // LOAD EVENT
  // ---------------------------------------------------------------------------

  Future<void> _loadEvent() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Event details are retrieved from Firebase through the repository.
      final event = await _eventRepository.getEventById(
        widget.eventId,
      );

      if (!mounted) return;

      if (event == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'This event could not be found.';
        });
        return;
      }

      setState(() {
        _event = event;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
        'Unable to load this event. Please try again.';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_errorMessage != null || _event == null) {
      return _buildErrorScreen();
    }

    final event = _event!;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(event),
          SliverToBoxAdapter(
            child: _buildEventContent(event),
          ),
        ],
      ),

      // Get Ticket stays visible at the bottom while the user
      // scrolls through the event information.
      bottomNavigationBar: _buildTicketButton(event),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR / HERO IMAGE
  // ---------------------------------------------------------------------------

  Widget _buildAppBar(EventModel event) {
    return SliverAppBar(
      backgroundColor: AppColors.backgroundDark,
      surfaceTintColor: Colors.transparent,
      expandedHeight: 300,
      pinned: true,

      leading: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceSm),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withValues(
              alpha: 0.75,
            ),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimaryDark,
            ),
          ),
        ),
      ),

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildEventImage(event),

            // Dark gradient makes the image easier to read
            // while scrolling.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.backgroundDark.withValues(
                      alpha: 0.85,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: AppConstants.spaceLg,
              right: AppConstants.spaceLg,
              bottom: AppConstants.spaceLg,
              child: _buildCategoryBadge(event.category),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage(EventModel event) {
    if (event.imageUrl.isEmpty) {
      return Container(
        color: AppColors.surfaceDark,
        child: const Center(
          child: Icon(
            Icons.event,
            size: 64,
            color: AppColors.textSecondaryDark,
          ),
        ),
      );
    }

    return Image.network(
      event.imageUrl,
      fit: BoxFit.cover,

      errorBuilder: (_, __, ___) {
        return Container(
          color: AppColors.surfaceDark,
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: AppColors.textSecondaryDark,
            ),
          ),
        );
      },

      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return Container(
          color: AppColors.surfaceDark,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMd,
          vertical: AppConstants.spaceSm,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(
            AppConstants.radiusPill,
          ),
        ),
        child: Text(
          category,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EVENT CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildEventContent(EventModel event) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spaceLg,
        AppConstants.spaceLg,
        AppConstants.spaceLg,
        AppConstants.spaceXxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event title.
          Text(
            event.title,
            style: AppTextStyles.titleLarge,
          ),

          const SizedBox(
            height: AppConstants.spaceSm,
          ),

          // Organizer.
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 18,
                color: AppColors.primaryMuted,
              ),
              const SizedBox(
                width: AppConstants.spaceSm,
              ),
              Expanded(
                child: Text(
                  'Organized by ${event.organizerName}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: AppConstants.spaceLg,
          ),

          _buildEventInformation(event),

          const SizedBox(
            height: AppConstants.spaceLg,
          ),

          _buildDescription(event),

          const SizedBox(
            height: AppConstants.spaceLg,
          ),

          _buildLocation(event),

          const SizedBox(
            height: AppConstants.spaceLg,
          ),

          _buildPrice(event),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EVENT INFORMATION
  // ---------------------------------------------------------------------------

  Widget _buildEventInformation(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(
        AppConstants.spaceMd,
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
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            title: 'Date',
            value: _formatDate(event.date),
          ),

          const SizedBox(
            height: AppConstants.spaceMd,
          ),

          _buildInfoRow(
            icon: Icons.access_time_outlined,
            title: 'Time',
            value: event.time,
          ),

          const SizedBox(
            height: AppConstants.spaceMd,
          ),

          _buildInfoRow(
            icon: Icons.location_on_outlined,
            title: 'Location',
            value: event.locationName,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(
            AppConstants.spaceSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(
              AppConstants.radiusMd,
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryMuted,
            size: 20,
          ),
        ),

        const SizedBox(
          width: AppConstants.spaceMd,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(
                height: AppConstants.spaceXs,
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DESCRIPTION
  // ---------------------------------------------------------------------------

  Widget _buildDescription(EventModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this event',
          style: AppTextStyles.bodySmall,
        ),

        const SizedBox(
          height: AppConstants.spaceSm,
        ),

        Text(
          event.description,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LOCATION
  // ---------------------------------------------------------------------------

  Widget _buildLocation(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(
        AppConstants.spaceMd,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(
            height: AppConstants.spaceMd,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 22,
              ),

              const SizedBox(
                width: AppConstants.spaceSm,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.locationName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: AppConstants.spaceXs,
                    ),

                    Text(
                      event.address,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: AppConstants.spaceMd,
          ),

          // Open the map with this specific event selected.
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
              label: const Text('View on Map'),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRICE
  // ---------------------------------------------------------------------------

  Widget _buildPrice(EventModel event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Ticket Price',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),

        Text(
          event.price == 0
              ? 'Free'
              : _formatCurrency(event.price),
          style: AppTextStyles.bodySmall.copyWith(
            color: event.price == 0
                ? AppColors.success
                : AppColors.primaryMuted,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // GET TICKET BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildTicketButton(EventModel event) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.spaceLg,
          AppConstants.spaceMd,
          AppConstants.spaceLg,
          AppConstants.spaceMd,
        ),
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
        ),
        child: SizedBox(
          width: double.infinity,
          height: AppConstants.spaceXxl,
          child: ElevatedButton(
            onPressed: _isPurchasingTicket
                ? null
                : () => _handleGetTicket(event),

            child: _isPurchasingTicket
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text(
              event.price == 0
                  ? 'Get Free Ticket'
                  : 'Get Ticket • ${_formatCurrency(event.price)}',
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GET TICKET FLOW
  // ---------------------------------------------------------------------------

  Future<void> _handleGetTicket(EventModel event) async {
    final user = FirebaseAuth.instance.currentUser;

    // A ticket must belong to an authenticated user.
    if (user == null) {
      await _showErrorDialog(
        'You need to be logged in before getting a ticket.',
      );
      return;
    }

    // Free events do not require a wallet check or deduction.
    if (event.price <= 0) {
      await _purchaseTicket(
        event: event,
        userId: user.uid,
      );
      return;
    }

    try {
      // Read the user's existing wallet balance.
      final balance = await WalletFirebaseService.getBalance();

      if (!mounted) return;

      // Stop the purchase if there is not enough money.
      if (balance < event.price) {
        await _showInsufficientBalanceDialog(
          eventPrice: event.price,
          balance: balance,
        );
        return;
      }

      // Show confirmation before deducting money.
      final confirmed = await _showConfirmationDialog(
        event: event,
        balance: balance,
      );

      if (!mounted || confirmed != true) {
        return;
      }

      await _purchaseTicket(
        event: event,
        userId: user.uid,
      );
    } catch (e) {
      if (!mounted) return;

      await _showErrorDialog(
        _friendlyErrorMessage(e),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // PURCHASE TICKET
  // ---------------------------------------------------------------------------

  Future<void> _purchaseTicket({
    required EventModel event,
    required String userId,
  }) async {
    if (_isPurchasingTicket) return;

    setState(() {
      _isPurchasingTicket = true;
    });

    try {
      // TicketPurchaseService:
      // 1. Deducts the wallet for paid events.
      // 2. Creates the ticket.
      // 3. Sends the ticket to Firebase and SQLite.
      final ticket = await _ticketPurchaseService.purchaseTicket(
        event: event,
        userId: userId,
      );

      if (!mounted) return;

      setState(() {
        _isPurchasingTicket = false;
      });

      // Show the payment/ticket success confirmation.
      await _showSuccessDialog(ticket);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isPurchasingTicket = false;
      });

      await _showErrorDialog(
        _friendlyErrorMessage(e),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // CONFIRMATION DIALOG
  // ---------------------------------------------------------------------------

  Future<bool?> _showConfirmationDialog({
    required EventModel event,
    required double balance,
  }) {
    final remainingBalance = balance - event.price;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.radiusLg,
            ),
          ),
          title: Text(
            'Confirm Ticket',
            style: AppTextStyles.bodySmall,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: AppConstants.spaceLg,
              ),

              _PurchaseRow(
                label: 'Ticket',
                value: _formatCurrency(event.price),
              ),

              const SizedBox(
                height: AppConstants.spaceSm,
              ),

              _PurchaseRow(
                label: 'Wallet balance',
                value: _formatCurrency(balance),
              ),

              const Divider(
                height: AppConstants.spaceLg,
                color: AppColors.borderDark,
              ),

              _PurchaseRow(
                label: 'Balance after payment',
                value: _formatCurrency(remainingBalance),
                valueColor: AppColors.success,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // INSUFFICIENT BALANCE DIALOG
  // ---------------------------------------------------------------------------

  Future<void> _showInsufficientBalanceDialog({
    required double eventPrice,
    required double balance,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.radiusLg,
            ),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.warning,
              ),
              const SizedBox(
                width: AppConstants.spaceSm,
              ),
              Expanded(
                child: Text(
                  'Insufficient Balance',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PurchaseRow(
                label: 'Ticket price',
                value: _formatCurrency(eventPrice),
              ),

              const SizedBox(
                height: AppConstants.spaceSm,
              ),

              _PurchaseRow(
                label: 'Your balance',
                value: _formatCurrency(balance),
                valueColor: AppColors.error,
              ),

              const SizedBox(
                height: AppConstants.spaceMd,
              ),

              Text(
                'Please add money to your wallet before purchasing this ticket.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // SUCCESS DIALOG
  // ---------------------------------------------------------------------------

  Future<void> _showSuccessDialog(TicketModel ticket) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.radiusLg,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(
                  AppConstants.spaceMd,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(
                height: AppConstants.spaceLg,
              ),

              Text(
                'Ticket Purchased!',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: AppConstants.spaceSm,
              ),

              Text(
                ticket.price == 0
                    ? 'Your free ticket has been created successfully.'
                    : 'Your payment was successful and your ticket is ready.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),

              const SizedBox(
                height: AppConstants.spaceMd,
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spaceMd,
                  vertical: AppConstants.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMd,
                  ),
                ),
                child: Text(
                  ticket.ticketCode,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryMuted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('View Ticket'),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    // Open the newly created ticket after the success modal closes.
    context.pushNamed(
      RouteNames.ticketName,
      pathParameters: {
        'ticketId': ticket.id,
      },
    );
  }

  // ---------------------------------------------------------------------------
  // ERROR DIALOG
  // ---------------------------------------------------------------------------

  Future<void> _showErrorDialog(String message) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.radiusLg,
            ),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
              ),
              const SizedBox(
                width: AppConstants.spaceSm,
              ),
              Text(
                'Purchase Failed',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // LOADING / ERROR SCREENS
  // ---------------------------------------------------------------------------

  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            AppConstants.spaceLg,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event_busy_outlined,
                size: 52,
                color: AppColors.textSecondaryDark,
              ),

              const SizedBox(
                height: AppConstants.spaceLg,
              ),

              Text(
                _errorMessage ?? 'Event not found.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),

              const SizedBox(
                height: AppConstants.spaceLg,
              ),

              ElevatedButton(
                onPressed: _loadEvent,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatCurrency(double amount) {
    if (amount == amount.roundToDouble()) {
      return '₦${amount.toInt()}';
    }

    return '₦${amount.toStringAsFixed(2)}';
  }

  String _friendlyErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('Insufficient wallet balance')) {
      return 'You do not have enough money in your wallet for this ticket.';
    }

    if (message.contains('not logged in')) {
      return 'Please log in before purchasing a ticket.';
    }

    return 'We could not complete the ticket purchase. Please try again.';
  }
}

// -----------------------------------------------------------------------------
// PURCHASE SUMMARY ROW
// -----------------------------------------------------------------------------

class _PurchaseRow extends StatelessWidget {
  const _PurchaseRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
        ),
        const SizedBox(
          width: AppConstants.spaceMd,
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: valueColor ?? AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}