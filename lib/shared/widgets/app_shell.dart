import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';

const double _kTabletBreakpoint = 600;
const double _kDesktopBreakpoint = 1200;

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= _kDesktopBreakpoint) {
      return _DesktopShell(child: child);
    } else if (width >= _kTabletBreakpoint) {
      return _TabletShell(child: child);
    } else {
      return _MobileShell(child: child);
    }
  }
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

int _selectedIndexFromLocation(BuildContext context) {
  final location = GoRouterState.of(context).uri.toString();
  if (location.startsWith('/projects/')) return 0;
  if (location == AppRoutes.catalogue) return 1;
  return 0;
}

void _onDestinationTap(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go(AppRoutes.projects);
    case 1:
      if (kDebugMode) context.go(AppRoutes.catalogue);
  }
}

List<_NavDestination> _destinations(BuildContext context) => [
      const _NavDestination(
        icon: Icons.folder_open_outlined,
        selectedIcon: Icons.folder_open,
        label: 'Projects',
      ),
      if (kDebugMode)
        const _NavDestination(
          icon: Icons.widgets_outlined,
          selectedIcon: Icons.widgets,
          label: 'Catalogue',
        ),
    ];

class _NavDestination {
  const _NavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

// ---------------------------------------------------------------------------
// Mobile — BottomNavigationBar
// ---------------------------------------------------------------------------

class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dests = _destinations(context);
    final selectedIndex = _selectedIndexFromLocation(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: dests.length <= 1
          ? null
          : BottomNavigationBar(
              currentIndex: selectedIndex.clamp(0, dests.length - 1),
              onTap: (i) => _onDestinationTap(context, i),
              backgroundColor: AppColors.surface,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.muted,
              type: BottomNavigationBarType.fixed,
              items: [
                for (final d in dests)
                  BottomNavigationBarItem(
                    icon: Icon(d.icon),
                    activeIcon: Icon(d.selectedIcon),
                    label: d.label,
                  ),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tablet — NavigationRail (collapsed)
// ---------------------------------------------------------------------------

class _TabletShell extends StatelessWidget {
  const _TabletShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dests = _destinations(context);
    final selectedIndex = _selectedIndexFromLocation(context);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex.clamp(0, dests.length - 1),
            onDestinationSelected: (i) => _onDestinationTap(context, i),
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primary.withValues(alpha: 0.18),
            selectedIconTheme: const IconThemeData(color: AppColors.primary),
            unselectedIconTheme: const IconThemeData(color: AppColors.muted),
            selectedLabelTextStyle: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
            ),
            unselectedLabelTextStyle: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
            ),
            labelType: NavigationRailLabelType.selected,
            destinations: [
              for (final d in dests)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.surfaceVariant,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop — Extended NavigationRail (drawer-style)
// ---------------------------------------------------------------------------

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dests = _destinations(context);
    final selectedIndex = _selectedIndexFromLocation(context);

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 220,
            child: NavigationRail(
              extended: true,
              selectedIndex: selectedIndex.clamp(0, dests.length - 1),
              onDestinationSelected: (i) => _onDestinationTap(context, i),
              backgroundColor: AppColors.surface,
              indicatorColor: AppColors.primary.withValues(alpha: 0.18),
              selectedIconTheme: const IconThemeData(color: AppColors.primary),
              unselectedIconTheme:
                  const IconThemeData(color: AppColors.muted),
              selectedLabelTextStyle: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: AppColors.muted,
                fontSize: 14,
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'GameStory',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              destinations: [
                for (final d in dests)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.surfaceVariant,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
