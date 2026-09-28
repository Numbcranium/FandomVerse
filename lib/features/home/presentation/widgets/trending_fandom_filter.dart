import 'package:flutter/material.dart';

class TrendingFandomFilter extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const TrendingFandomFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  // from firebase getting the categories

  static const List<String> categories = [
    'All',
    'Anime',
    'Gaming',
    'Marvel',
    'Pop Culture',
    'TV Universes',
    'Comic Books',
    'Music',
    'Idol Culture',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        itemCount: categories.length,

        separatorBuilder: (context, index) {
          return SizedBox(width: 8);
        },

        itemBuilder: (context, index) {
          final category = categories[index];

          final isSelected =
              selectedCategory == category;

          return Material(
            color: Colors.transparent,

            child: InkWell(
              // wen tapped it goes to any category
              onTap: () {
                onCategorySelected(category);
              },

              borderRadius:
              BorderRadius.circular(20),

              child: AnimatedContainer(
                duration:
                const Duration(
                  milliseconds: 180,
                ),

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                constraints:
                const BoxConstraints(
                  minWidth: 60,
                ),

                alignment:
                Alignment.center,

                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF8B2CFF)
                      : Theme.of(context).cardColor,

                  borderRadius:
                  BorderRadius.circular(20),

                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF8B2CFF)
                        : Theme.of(context).dividerColor,
                  ),
                ),

                child: Text(
                  category,

                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,

                    fontSize: 14,

                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}