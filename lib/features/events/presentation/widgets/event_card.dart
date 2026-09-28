import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppConstants.radiusLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      AppConstants.radiusLg,
                    ),
                    topRight: Radius.circular(
                      AppConstants.radiusLg,
                    ),
                  ),
                  child: Image.network(
                    event.imageUrl,
                    height: 185,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 185,
                        color: Theme.of(context).dialogBackgroundColor,
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: AppConstants.spaceSm,
                  left: AppConstants.spaceSm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spaceSm,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSm,
                      ),
                    ),
                    child: Text(
                      event.category,
                      style: AppTextStyles.caption.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: AppConstants.spaceSm,
                  right: AppConstants.spaceSm,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withValues(
                        alpha: 0.75,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_border_rounded,
                        size: 20,
                      ),
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(
                AppConstants.spaceMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                        color: AppColors.primaryMuted,
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          _formatDate(event.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 7),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.primaryMuted,
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          event.locationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 7),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: AppColors.primaryMuted,
                      ),
                      SizedBox(width: 7),
                      Text(
                        event.time,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}