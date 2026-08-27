import 'package:flutter/material.dart';

import '../../core/router/app_tabs.dart';
import '../../core/theme/soft_ui_colors.dart';

/// Navbar 5 onglets — pastille orange sur l’icône active (capture).
class FinedgeBottomNav extends StatelessWidget {
  const FinedgeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, AppTabs.accueil),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, AppTabs.lecons),
    (
      Icons.emoji_events_outlined,
      Icons.emoji_events_rounded,
      AppTabs.classement,
    ),
    (Icons.smart_toy_outlined, Icons.smart_toy, AppTabs.coach),
    (Icons.person_outline, Icons.person, AppTabs.profil),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SoftUiColors.card,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: SoftUiColors.border)),
          ),
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: currentIndex == i ? _items[i].$2 : _items[i].$1,
                    label: _items[i].$3,
                    selected: currentIndex == i,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? SoftUiColors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 22,
                color: selected ? Colors.white : SoftUiColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: SoftUiColors.ink,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
