import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techwiz7_starter/features/home/presentation/widgets/trivia_card.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/cart_badge.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../screens/merchandise/cart_screen.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $firstName 👋',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your daily fandom breakdown.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(RouteNames.profile),
                    child: AppNetworkImage.avatar(
                      imageUrl: user?.photoUrl,
                      radius: 20, // Slightly smaller to save space
                      fallbackText: user?.fullName,
                    ),
                  ),
                  SizedBox(width: AppConstants.spaceSm),
                  IconButton(
                    onPressed: () => context.push(RouteNames.community),
                    icon: Icon(Icons.group),
                    tooltip: 'Community',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: AppConstants.spaceMd),
                  CartBadge(
                    top: 0,
                    right: 4,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.shopping_cart_outlined),
                      tooltip: 'Cart',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.spaceLg),
              Expanded(
                child: ListView(
                  children: [
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
            SizedBox(height: AppConstants.spaceLg),
          //   ============================================================================
          //   for the trivia screen
             const TriviaCard(),
            SizedBox(
            height: AppConstants.spaceLg,
            ),

          //   ============================================================
          //   for slider
            const HomesliderScreen(),
            SizedBox(
              height: AppConstants.spaceLg,
            ),

          //   =---------------------------------------------------------
          //   popular fandoms --
            const PopularFandoms()


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        return; // Already on home
      case 1:
        context.go(RouteNames.trivia);
        return;
      case 2:
        context.go(RouteNames.events);
        return;
      case 3:
        context.push('/merchandise');
        return;
      case 4:
        context.go(RouteNames.profile);
        return;
    }
  }
}
