import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techwiz7_starter/features/home/presentation/widgets/trivia_card.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/coming_soon.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/homeslider_screen.dart';
import '../widgets/popular_fandoms.dart';

/// Generic, domain-agnostic home/dashboard screen (brief section 12).
///
/// Quick actions, stat cards, and recent activity below use local
/// placeholder data — TODO(Phase 7): replace with the mock data layer
/// (`mock/mock_*.dart`) once it exists, then swap for real repository
/// data once the SRS defines what this dashboard actually tracks.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    final nameParts = user?.fullName.trim().split(' ') ?? const <String>[];
    final firstName = (nameParts.isNotEmpty && nameParts.first.isNotEmpty)
        ? nameParts.first
        : 'there';

    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) => _onTabTapped(context, index),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $firstName 👋',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Here's what's happening today.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                // the profile image placeholder
                GestureDetector(
                  onTap: () => context.go(RouteNames.profile),
                  child: AppNetworkImage.avatar(
                    imageUrl: user?.photoUrl,
                    radius: 24,
                    fallbackText: user?.fullName,
                  ),
                ),
                const SizedBox(width: AppConstants.spaceSm),
                // the collection button placeholder
                IconButton(
                  onPressed: () => context.push(RouteNames.community),
                  icon: const Icon(Icons.group),
                  tooltip: 'Community',
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spaceLg),
            // search area for a screen with a search bar
            GestureDetector(
              onTap: () {
                context.push(RouteNames.homeSearch);
              },
              child: const AbsorbPointer(
                child: AppTextField.search(
                  hint: 'Search',
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spaceLg),
          //   ============================================================================
          //   for the trivia screen
             const TriviaCard(),
            const SizedBox(
            height: AppConstants.spaceLg,
            ),

          //   ============================================================
          //   for slider
            HomesliderScreen(),
            const SizedBox(
              height: AppConstants.spaceLg,
            ),

          //   =---------------------------------------------------------
          //   popular fandoms --
            PopularFandoms()


          ],
        ),
      ),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        return;
      case 1:
        context.go(RouteNames.trivia);
        return;
      case 2:
        showComingSoon(context, 'Events');
        return;
      case 3:
        showComingSoon(context, 'Shop');
        return;
      case 4:
        context.go(RouteNames.profile);
        return;
    }
  }
}
