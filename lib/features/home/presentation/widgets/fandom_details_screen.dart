import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techwiz7_starter/models/fandom_models.dart';

import '../../../../app/router/route_names.dart';
import '../../../../models/fandom-service.dart';
import '../widgets/fandom_follow_button.dart';
import 'fandom_follower_count.dart';


class FandomDetailsScreen extends StatelessWidget {
  final String fandomId;

  const FandomDetailsScreen({
    super.key,
    required this.fandomId,
  });

  @override
  Widget build(BuildContext context) {
    final fandomService = FandomService();

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      body: FutureBuilder<FandomModels?>(
        future: fandomService.getFandom(fandomId),

        builder: (context, snapshot) {
          // ==========================================
          // LOADING
          // ==========================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // ==========================================
          // ERROR
          // ==========================================

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load fandom',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            );
          }

          // ==========================================
          // FANDOM NOT FOUND
          // ==========================================

          final fandom = snapshot.data;

          if (fandom == null) {
            return Center(
              child: Text(
                'Fandom not found',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            );
          }

          // ==========================================
          // FANDOM DETAILS
          // ==========================================

          return CustomScrollView(
            slivers: [
              // ========================================
              // HEADER IMAGE
              // ========================================

              SliverAppBar(
                expandedHeight: 260,
                pinned: true,

                backgroundColor:
                Theme.of(context).cardColor,

                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),

                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        fandom.image,
                        fit: BoxFit.cover,

                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(context).cardColor,
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white38,
                              size: 50,
                            ),
                          );
                        },
                      ),

                      // Dark overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Theme.of(context).cardColor,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ========================================
              // CONTENT
              // ========================================

              SliverToBoxAdapter(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      SizedBox(height: 10),

                      // ==================================
                      // NAME
                      // ==================================

                      Text(
                        fandom.name,

                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 6),

                      // ==================================
                      // CATEGORY
                      // ==================================

                      Text(
                        fandom.category,

                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 10),

                      // FOLLOWER COUNT

                      FandomFollowerCount(
                        fandomId: fandom.id,
                      ),

                      SizedBox(height: 18),

                      // FOLLOW BUTTON

                      FandomFollowButton(
                        fandomId: fandom.id,
                      ),

                      SizedBox(height: 24),

                      // DESCRIPTION

                      Text(
                        'About',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        fandom.description,

                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      SizedBox(height: 30),

                      // CONTENT SECTIONS

                      Text(
                        'Explore',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 15),

                      _ExploreButton(
                        icon: Icons.newspaper_outlined,
                        title: 'News',
                        onTap: () {
                          context.push(
                            RouteNames.fandomNews.replaceFirst(
                              ':fandomId',
                              fandom.id,
                            ),
                          );
                        },
                      ),

                      _ExploreButton(
                        icon: Icons.photo_library_outlined,
                        title: 'Gallery',
                        onTap: () {
                          context.push(
                            RouteNames.fandomGallery.replaceFirst(
                              ':fandomId',
                              fandom.id,
                            ),
                          );
                        },
                      ),
                      _ExploreButton(
                        icon: Icons.quiz_outlined,
                        title: 'Trivia',
                        onTap: () {
                          context.push(
                            RouteNames.fandomTrivia.replaceFirst(
                              ':fandomId',
                              fandom.id,
                            ),
                          );
                        },
                      ),

                      _ExploreButton(
                        icon: Icons.play_circle_outline,
                        title: 'Videos',
                        onTap: () {
                          context.push(
                            RouteNames.fandomVideo.replaceFirst(
                              ':fandomId',
                              fandom.id,
                            ),
                          );
                        },
                      ),

                      // _ExploreButton(
                      //   icon: Icons.event_outlined,
                      //   title: 'Events',
                      //   onTap: () {
                      //     // We will connect this next
                      //   },
                      // ),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ======================================================
// EXPLORE BUTTON
// ======================================================

class _ExploreButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ExploreButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Material(
        color: Theme.of(context).cardColor,

        borderRadius:
        BorderRadius.circular(12),

        child: InkWell(
          onTap: onTap,

          borderRadius:
          BorderRadius.circular(12),

          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),

            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF8FA8F5),
                  size: 24,
                ),

                SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,

                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}