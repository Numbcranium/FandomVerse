import 'package:flutter/material.dart';

/// One tab in [AppBottomNavBar].
class AppNavTab {
  const AppNavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Reusable bottom navigation bar, deliberately decoupled from routing —
/// it just renders [tabs] and reports taps via [onTap]. Screens decide
/// what a tap does (typically `context.go(RouteNames.x)`), so swapping or
/// reordering tabs never means touching this widget.
///
/// Default tabs match the team's design system exactly: Home, Explore,
/// Events, Shop, Profile. Only Home and Profile route anywhere today —
/// Explore/Events/Shop belong to other sections and aren't built yet, so
/// screens using this widget should show a "coming soon" affordance for
/// those taps rather than navigating to a route that doesn't exist.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    this.tabs = defaultTabs,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppNavTab> tabs;

  static const List<AppNavTab> defaultTabs = [
    AppNavTab(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    AppNavTab(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Explore'),
    AppNavTab(icon: Icons.event_outlined, activeIcon: Icons.event, label: 'Events'),
    AppNavTab(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront,
      label: 'Shop',
    ),
    AppNavTab(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        for (final tab in tabs)
          BottomNavigationBarItem(
            icon: Icon(tab.icon),
            activeIcon: Icon(tab.activeIcon),
            label: tab.label,
          ),
      ],
    );
  }
}
