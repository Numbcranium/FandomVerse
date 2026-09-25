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
      backgroundColor: const Color(0xFF0B0A24),

      body: FutureBuilder<FandomModels?>(
        future: fandomService.getFandom(fandomId),

        builder: (context, snapshot) {
          // ==========================================
          // LOADING
          // ==========================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ==========================================
          // ERROR
          // ==========================================

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load fandom',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          // ==========================================
          // FANDOM NOT FOUND
          // ==========================================

          final fandom = snapshot.data;

          if (fandom == null) {
            return const Center(
              child: Text(
                'Fandom not found',
                style: TextStyle(
                  color: Colors.white,
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
                const Color(0xFF0B0A24),

                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
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
                            color: const Color(0xFF17163D),
                            child: const Icon(
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
                              const Color(0xFF0B0A24),
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
                      const SizedBox(height: 10),

                      // ==================================
                      // NAME
                      // ==================================

                      Text(
                        fandom.name,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ==================================
                      // CATEGORY
                      // ==================================

                      Text(
                        fandom.category,

                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // FOLLOWER COUNT

                      FandomFollowerCount(
                        fandomId: fandom.id,
                      ),

                      const SizedBox(height: 18),

                      // FOLLOW BUTTON

                      FandomFollowButton(
                        fandomId: fandom.id,
                      ),

                      const SizedBox(height: 24),

                      // DESCRIPTION

                      const Text(
                        'About',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        fandom.description,

                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // CONTENT SECTIONS

                      const Text(
                        'Explore',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

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
                          // We will connect this next
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

                      const SizedBox(height: 40),
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
        color: const Color(0xFF17163D),

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

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}