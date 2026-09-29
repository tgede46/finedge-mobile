import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

/// Carte objectif : icône colorée + titre + description (style Duolingo).
class GoalOptionCard extends StatelessWidget {
  const GoalOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.iconBackground,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color? iconBackground;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: SoftUiColors.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? SoftUiColors.orange : SoftUiColors.border,
                width: selected ? 1.8 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBackground ?? SoftUiColors.iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: SoftUiColors.ink, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: SoftUiColors.ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          color: SoftUiColors.muted,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
