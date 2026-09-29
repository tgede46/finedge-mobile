import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

class HomeStatsRow extends StatelessWidget {
  const HomeStatsRow({
    super.key,
    required this.streak,
    required this.xp,
    required this.lessonsDone,
  });

  final int streak;
  final int xp;
  final int lessonsDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: Icons.local_fire_department,
            label: '$streak',
            caption: 'Série',
            tint: const Color(0xFFFFE0B2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: Icons.stars_rounded,
            label: '$xp',
            caption: 'XP',
            tint: const Color(0xFFFFF3C4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: Icons.check_circle_outline,
            label: '$lessonsDone',
            caption: 'Leçons',
            tint: const Color(0xFFC8E6C9),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.caption,
    required this.tint,
  });

  final IconData icon;
  final String label;
  final String caption;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: SoftUiColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SoftUiColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: SoftUiColors.ink),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: SoftUiColors.ink,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          Text(
            caption,
            style: const TextStyle(
              color: SoftUiColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
