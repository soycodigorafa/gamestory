import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Adaptive navigation shell for go_router [StatefulShellRoute].
///
/// Switches between phone (bottom bar), tablet (compact rail), and desktop
/// (extended rail) layouts based on [MediaQuery] width.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavLayout(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      child: navigationShell,
    );
  }
}

/// Responsive layout widget that wraps [child] with the appropriate
/// navigation chrome for the current screen width.
///
/// Exposed as a public class so it can be pumped directly in widget tests
/// without needing a live [StatefulNavigationShell].
class AdaptiveNavLayout extends StatelessWidget {
  const AdaptiveNavLayout({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  static const double phoneBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  static const _railDestinations = <NavigationRailDestination>[
    NavigationRailDestination(
      icon: Icon(Icons.folder_outlined),
      selectedIcon: Icon(Icons.folder_rounded),
      label: Text('Projects'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.info_outline_rounded),
      selectedIcon: Icon(Icons.info_rounded),
      label: Text('About'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= tabletBreakpoint) {
      return _desktopLayout();
    } else if (width >= phoneBreakpoint) {
      return _tabletLayout();
    } else {
      return _phoneLayout();
    }
  }

  Widget _phoneLayout() {
    return Column(
      children: [
        Expanded(child: child),
        NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder_rounded),
              label: 'Projects',
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline_rounded),
              selectedIcon: Icon(Icons.info_rounded),
              label: 'About',
            ),
          ],
        ),
      ],
    );
  }

  Widget _tabletLayout() {
    return Row(
      children: [
        NavigationRail(
          extended: false,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: _railDestinations,
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: child),
      ],
    );
  }

  Widget _desktopLayout() {
    return Row(
      children: [
        NavigationRail(
          extended: true,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: _railDestinations,
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: child),
      ],
    );
  }
}
