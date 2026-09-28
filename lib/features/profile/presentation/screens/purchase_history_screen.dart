import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/status_badge.dart';

/// Past (simulated) merchandise orders. Per the SRS, checkout is
/// simulated only — no real payment/delivery — so this just needs to
/// list whatever orders the Merchandise section's mock data produces.
///
/// UI shell on local mock data for now — TODO: swap `_mockOrders` for a
/// real `OrderRepository` once the Merchandise team's mock/Firestore
/// layer for orders exists.
class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  static const _mockOrders = <({String item, String date, String total, String status})>[];

  StatusBadgeType _badgeTypeFor(String status) {
    switch (status) {
      case 'Delivered':
        return StatusBadgeType.success;
      case 'Processing':
        return StatusBadgeType.warning;
      case 'Cancelled':
        return StatusBadgeType.error;
      default:
        return StatusBadgeType.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Purchase history')),
      body: SafeArea(
        child: _mockOrders.isEmpty
            ? const AppEmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No orders yet',
                message: 'Items you check out from the shop will show up here.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppConstants.spaceMd),
                itemCount: _mockOrders.length,
                separatorBuilder: (_, __) => SizedBox(height: AppConstants.spaceSm),
                itemBuilder: (context, index) {
                  final order = _mockOrders[index];
                  return AppCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.item, style: Theme.of(context).textTheme.titleMedium),
                              SizedBox(height: 4),
                              Text(order.date, style: Theme.of(context).textTheme.bodySmall),
                              SizedBox(height: 6),
                              StatusBadge(
                                label: order.status,
                                type: _badgeTypeFor(order.status),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          order.total,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
