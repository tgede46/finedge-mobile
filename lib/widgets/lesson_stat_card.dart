import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';

class LessonStatCard extends StatelessWidget {
  const LessonStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: SoftUiColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: accent, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTypography.heading.copyWith(
                color: accent,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(
                color: SoftUiColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
