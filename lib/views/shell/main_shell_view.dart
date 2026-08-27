import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_tabs.dart';
import '../../core/theme/app_colors.dart';

/// Coquille MVC : vue de navigation principale à 4 onglets.
class MainShellView extends StatelessWidget {
  const MainShellView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: AppTabs.sentier,
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: AppTabs.simulateur,
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: AppTabs.coach,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: AppTabs.profil,
          ),
        ],
      ),
    );
  }
}

/// En-tête compact streak + XP, partagé par les vues d'onglets.
class FintechStatusChip extends StatelessWidget {
  const FintechStatusChip({
    super.key,
    required this.icon,
    required this.label,
    this.emphasized = false,
  });

  final IconData icon;
  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: emphasized
            ? AppColors.onPrimary.withValues(alpha: 0.18)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: emphasized ? AppColors.onPrimary : AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: emphasized ? AppColors.onPrimary : AppColors.brown,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
