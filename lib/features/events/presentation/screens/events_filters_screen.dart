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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        title: Text(
          'Event Filters',
          style: AppTextStyles.titleLarge,
        ),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Clear'),
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
            style: AppTextStyles.titleMedium,
          ),

          const SizedBox(height: 12),

          // Category selection.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map(
                  (category) {
                final selected =
                    selectedCategory ==
                        category;

                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory =
                          category;
                    });
                  },
                  selectedColor:
                  AppColors.primary,
                  backgroundColor:
                  AppColors.surfaceDark,
                  side: BorderSide(
                    color: selected
                        ? AppColors.primary
                        : AppColors.borderDark,
                  ),
                );
              },
            ).toList(),
          ),

          const SizedBox(
            height: AppConstants.spaceLg,
          ),

          Text(
            'Price',
            style: AppTextStyles.titleMedium,
          ),

          const SizedBox(height: 12),

          // Free/paid filter.
          Wrap(
            spacing: 8,
            children: priceOptions.map(
                  (price) {
                final selected =
                    selectedPrice == price;

                return ChoiceChip(
                  label: Text(price),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedPrice = price;
                    });
                  },
                  selectedColor:
                  AppColors.primary,
                  backgroundColor:
                  AppColors.surfaceDark,
                  side: BorderSide(
                    color: selected
                        ? AppColors.primary
                        : AppColors.borderDark,
                  ),
                );
              },
            ).toList(),
          ),

          const SizedBox(
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
                    'category':
                    selectedCategory,
                    'price':
                    selectedPrice,
                  },
                );
              },
              child: const Text(
                'Apply Filters',
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