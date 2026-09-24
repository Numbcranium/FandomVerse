import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';

/// Saved articles/stories/media (SRS 1.6 "Offline Bookmarking").
///
/// The *content* being bookmarked (news, galleries, lore, videos) belongs
/// to the Fandom Exploration section, which isn't built yet — this screen
/// is a UI shell on local mock data for now. TODO: once that team's
/// bookmark repository exists, replace `_mockBookmarks` with a real
/// `BookmarkRepository` (Firestore-backed, per the team's SQLite-cache
/// convention).
class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  static const _mockBookmarks = <({String title, String category, IconData icon})>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: SafeArea(
        child: _mockBookmarks.isEmpty
            ? const AppEmptyState(
                icon: Icons.bookmark_border,
                title: 'No bookmarks yet',
                message: 'Save articles, stories, and media to find them here.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppConstants.spaceMd),
                itemCount: _mockBookmarks.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spaceSm),
                itemBuilder: (context, index) {
                  final bookmark = _mockBookmarks[index];
                  return AppCard(
                    child: Row(
                      children: [
                        Icon(bookmark.icon, color: AppColors.primary),
                        const SizedBox(width: AppConstants.spaceSm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bookmark.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                bookmark.category,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
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
