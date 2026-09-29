import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';

/// Rangée Mo–Di … avec le jour actuel coché (série).
class StreakWeekRow extends StatelessWidget {
  const StreakWeekRow({super.key, this.completedWeekday = DateTime.monday});

  /// DateTime.monday … sunday
  final int completedWeekday;

  static const _labels = ['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < 7; i++)
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (i + 1) == completedWeekday
                      ? SoftUiColors.orange
                      : SoftUiColors.progressTrack,
                ),
                child: (i + 1) == completedWeekday
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
              const SizedBox(height: 6),
              Text(
                _labels[i],
                style: AppTypography.caption.copyWith(
                  color: SoftUiColors.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
