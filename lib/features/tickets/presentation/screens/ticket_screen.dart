import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/ticket_firebase_datasource.dart';
import '../../data/datasources/ticket_sqlite_datasource.dart';
import '../../data/repositories/ticket_repository_impl.dart';
import '../../models/ticket_model.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({
    super.key,
    required this.ticketId,
  });

  final String ticketId;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late final TicketRepositoryImpl _repository;

  late Future<TicketModel?> _ticketFuture;

  @override
  void initState() {
    super.initState();

    _repository = TicketRepositoryImpl(
      firebaseDataSource: TicketFirebaseDataSource(),
      sqliteDataSource: TicketSqliteDataSource(),
    );

    _ticketFuture = _loadTicket();
  }

  Future<TicketModel?> _loadTicket() {
    return _repository.getTicketById(
      widget.ticketId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,

      appBar: AppBar(
        title: Text(
          'My Ticket',
          style: AppTextStyles.bodySmall,
        ),
      ),

      body: FutureBuilder<TicketModel?>(
        future: _ticketFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState();
          }

          final ticket = snapshot.data;

          if (ticket == null) {
            return _buildNotFoundState();
          }

          return _buildTicket(ticket);
        },
      ),
    );
  }

  Widget _buildTicket(TicketModel ticket) {
    final formattedDate = DateFormat(
      'EEE, dd MMM yyyy',
    ).format(ticket.eventDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        AppConstants.spaceLg,
      ),
      child: Column(
        children: [
          // Ticket card.
          Container(
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
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                // Event image.
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(
                      AppConstants.radiusLg,
                    ),
                  ),
                  child: Image.network(
                    ticket.eventImageUrl,
                    height: 190,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        height: 190,
                        color: AppColors.surfaceDarkElevated,
                        child: const Icon(
                          Icons.event,
                          size: 48,
                          color: AppColors.textSecondaryDark,
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(
                    AppConstants.spaceLg,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.eventTitle,
                        style: AppTextStyles.bodySmall,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        ticket.locationName,
                        style: AppTextStyles.bodyMedium,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        ticket.address,
                        style: AppTextStyles.bodySmall,
                      ),

                      const SizedBox(height: 16),

                      _TicketInfoRow(
                        icon: Icons.calendar_today_outlined,
                        text: formattedDate,
                      ),

                      const SizedBox(height: 10),

                      _TicketInfoRow(
                        icon: Icons.access_time,
                        text: ticket.eventTime,
                      ),

                      const SizedBox(height: 10),

                      _TicketInfoRow(
                        icon: Icons.location_on_outlined,
                        text: ticket.locationName,
                      ),
                    ],
                  ),
                ),

                const Divider(
                  color: AppColors.borderDark,
                  height: 1,
                ),

                // QR code section.
                Padding(
                  padding: const EdgeInsets.all(
                    AppConstants.spaceLg,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Show this QR code at the event',
                        style: AppTextStyles.bodyMedium,
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: QrImageView(
                          data: ticket.ticketCode,
                          size: 190,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        ticket.ticketCode,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Price/status information.
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  title: 'Amount',
                  value: ticket.price == 0
                      ? 'FREE'
                      : '₦${ticket.price.toStringAsFixed(2)}',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _InfoCard(
                  title: 'Status',
                  value: ticket.status.toUpperCase(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Return to event details.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(
                  RouteNames.eventDetailsName,
                  pathParameters: {
                    'eventId': ticket.eventId,
                  },
                );
              },
              icon: const Icon(
                Icons.event_outlined,
              ),
              label: const Text(
                'View Event',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),

            const SizedBox(height: 12),

            Text(
              'Unable to load ticket.',
              style: AppTextStyles.bodyMedium,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _ticketFuture = _loadTicket();
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Text(
        'Ticket not found.',
        style: AppTextStyles.bodyMedium,
      ),
    );
  }
}

class _TicketInfoRow extends StatelessWidget {
  const _TicketInfoRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryMuted,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}