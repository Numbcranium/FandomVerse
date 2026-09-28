import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

class EventFiltersScreen extends StatefulWidget {
  const EventFiltersScreen({
    super.key,
  });

  @override
  State<EventFiltersScreen> createState() =>
      _EventFiltersScreenState();
}

class _EventFiltersScreenState
    extends State<EventFiltersScreen> {
  String selectedCategory = 'All';

  String selectedPrice = 'All';

  final categories = const [
    'All',
    'Anime',
    'Gaming',
    'Movies & TV',
    'Music & K-Pop',
    'Comics',
    'Community',
  ];

  final priceOptions = const [
    'All',
    'Free',
    'Paid',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        title: Text(
          'Event Filters',
          style: AppTextStyles.titleLarge.copyWith(
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: Text(
              'Clear',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(
          AppConstants.spaceMd,
        ),
        children: [
          Text(
            'Category',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),

          SizedBox(height: 12),

          // Category selection.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map(
              (category) {
                final selected =
                    selectedCategory == category;

                return ChoiceChip(
                  label: Text(
                    category,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : theme.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: theme.cardColor,
                  side: BorderSide(
                    color: selected
                        ? AppColors.primary
                        : theme.dividerColor,
                  ),
                );
              },
            ).toList(),
          ),

          SizedBox(
            height: AppConstants.spaceLg,
          ),

          Text(
            'Price',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),

          SizedBox(height: 12),

          // Free/paid filter.
          Wrap(
            spacing: 8,
            children: priceOptions.map(
              (price) {
                final selected = selectedPrice == price;

                return ChoiceChip(
                  label: Text(
                    price,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : theme.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedPrice = price;
                    });
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: theme.cardColor,
                  side: BorderSide(
                    color: selected
                        ? AppColors.primary
                        : theme.dividerColor,
                  ),
                );
              },
            ).toList(),
          ),

          SizedBox(
            height: AppConstants.spaceLg,
          ),

          // Apply the selected filters.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Return the selected filter values
                // to the previous screen.
                context.pop(
                  {
                    'category': selectedCategory,
                    'price': selectedPrice,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Resets all filters to their default values.
  void _clearFilters() {
    setState(() {
      selectedCategory = 'All';
      selectedPrice = 'All';
    });
  }
}