import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/ticket_firebase_datasource.dart';
import '../../data/datasources/ticket_sqlite_datasource.dart';
import '../../data/repositories/ticket_repository_impl.dart';
import '../../models/ticket_model.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  late final TicketRepositoryImpl _ticketRepository;

  List<TicketModel> _tickets = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Firebase is the remote source of truth.
    // SQLite receives a local copy of the tickets.
    _ticketRepository = TicketRepositoryImpl(
      firebaseDataSource: TicketFirebaseDataSource(),
      sqliteDataSource: TicketSqliteDataSource(),
    );

    _loadTickets();
  }

  // ---------------------------------------------------------------------------
  // LOAD TICKETS
  // ---------------------------------------------------------------------------

  Future<void> _loadTickets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Retrieves only the tickets belonging to the authenticated user.
      //
      // The repository also saves the retrieved tickets into SQLite.
      final tickets =
      await _ticketRepository.getCurrentUserTickets();

      if (!mounted) return;

      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
        'Unable to load your tickets. Please try again.';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),

        title: Text(
          'My Tickets',
          style: AppTextStyles.bodySmall,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_tickets.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceDark,

      // Pull-to-refresh retrieves the latest tickets from Firebase.
      onRefresh: _loadTickets,

      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(
          AppConstants.spaceLg,
          AppConstants.spaceMd,
          AppConstants.spaceLg,
          AppConstants.spaceXxl,
        ),

        itemCount: _tickets.length,

        separatorBuilder: (_, __) {
          return const SizedBox(
            height: AppConstants.spaceMd,
          );
        },

        itemBuilder: (context, index) {
          final ticket = _tickets[index];

          return _buildTicketCard(ticket);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TICKET CARD
  // ---------------------------------------------------------------------------

  Widget _buildTicketCard(TicketModel ticket) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppConstants.radiusLg,
        ),
        onTap: () {
          context.pushNamed(
            RouteNames.ticketName,
            pathParameters: {
              'ticketId': ticket.id,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(
              AppConstants.radiusLg,
            ),
            border: Border.all(
              color: AppColors.borderDark,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _buildTicketImage(ticket),

              Padding(
                padding: const EdgeInsets.all(
                  AppConstants.spaceMd,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildTicketHeader(ticket),

                    const SizedBox(
                      height: AppConstants.spaceMd,
                    ),

                    _buildTicketInfo(
                      ticket,
                    ),

                    const SizedBox(
                      height: AppConstants.spaceMd,
                    ),

                    _buildTicketFooter(ticket),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketImage(TicketModel ticket) {
    if (ticket.eventImageUrl.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        color: AppColors.surfaceDarkElevated,
        child: const Icon(
          Icons.event,
          size: 48,
          color: AppColors.textSecondaryDark,
        ),
      );
    }

    return Image.network(
      ticket.eventImageUrl,
      height: 150,
      width: double.infinity,
      fit: BoxFit.cover,

      errorBuilder: (_, __, ___) {
        return Container(
          height: 150,
          width: double.infinity,
          color: AppColors.surfaceDarkElevated,
          child: const Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: AppColors.textSecondaryDark,
          ),
        );
      },
    );
  }

  Widget _buildTicketHeader(TicketModel ticket) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            ticket.eventTitle,
            style: AppTextStyles.bodySmall,
          ),
        ),

        const SizedBox(
          width: AppConstants.spaceSm,
        ),

        _buildStatusBadge(ticket.status),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final normalizedStatus = status.toLowerCase();

    Color backgroundColor;
    Color textColor;
    String label;

    switch (normalizedStatus) {
      case 'used':
        backgroundColor = AppColors.textDisabledDark
            .withValues(alpha: 0.15);
        textColor = AppColors.textSecondaryDark;
        label = 'Used';
        break;

      case 'cancelled':
      case 'canceled':
        backgroundColor = AppColors.error
            .withValues(alpha: 0.12);
        textColor = AppColors.error;
        label = 'Cancelled';
        break;

      case 'active':
      default:
        backgroundColor = AppColors.success
            .withValues(alpha: 0.12);
        textColor = AppColors.success;
        label = 'Active';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceSm,
        vertical: AppConstants.spaceXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          AppConstants.radiusPill,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TICKET INFORMATION
  // ---------------------------------------------------------------------------

  Widget _buildTicketInfo(TicketModel ticket) {
    return Column(
      children: [
        _buildInfoRow(
          icon: Icons.calendar_today_outlined,
          text: _formatDate(ticket.eventDate),
        ),

        const SizedBox(
          height: AppConstants.spaceSm,
        ),

        _buildInfoRow(
          icon: Icons.access_time_outlined,
          text: ticket.eventTime,
        ),

        const SizedBox(
          height: AppConstants.spaceSm,
        ),

        _buildInfoRow(
          icon: Icons.location_on_outlined,
          text: ticket.locationName,
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primaryMuted,
        ),

        const SizedBox(
          width: AppConstants.spaceSm,
        ),

        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TICKET FOOTER
  // ---------------------------------------------------------------------------

  Widget _buildTicketFooter(TicketModel ticket) {
    return Row(
      children: [
        Expanded(
          child: Text(
            ticket.price == 0
                ? 'Free Ticket'
                : _formatCurrency(ticket.price),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: ticket.price == 0
                  ? AppColors.success
                  : AppColors.primaryMuted,
            ),
          ),
        ),

        const SizedBox(
          width: AppConstants.spaceSm,
        ),

        Text(
          'View Ticket',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primaryMuted,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(
          width: AppConstants.spaceXs,
        ),

        const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.primaryMuted,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState() {
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
                Icons.confirmation_num_outlined,
                size: 42,
                color: AppColors.primaryMuted,
              ),
            ),

            const SizedBox(
              height: AppConstants.spaceLg,
            ),

            Text(
              'No tickets yet',
              style: AppTextStyles.bodySmall,
            ),

            const SizedBox(
              height: AppConstants.spaceSm,
            ),

            Text(
              'Tickets you purchase will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),

            const SizedBox(
              height: AppConstants.spaceLg,
            ),

            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.explore_outlined,
              ),
              label: const Text(
                'Discover Events',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ERROR STATE
  // ---------------------------------------------------------------------------

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.spaceLg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),

            const SizedBox(
              height: AppConstants.spaceMd,
            ),

            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),

            const SizedBox(
              height: AppConstants.spaceLg,
            ),

            ElevatedButton.icon(
              onPressed: _loadTickets,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
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
}