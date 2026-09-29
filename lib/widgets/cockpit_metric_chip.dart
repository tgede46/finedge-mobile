import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class CockpitMetricChip extends StatelessWidget {
  const CockpitMetricChip({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.onPrimary.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.caption.copyWith(color: AppColors.onPrimary),
            ),
            Text(
              value,
              style: AppTypography.label.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
