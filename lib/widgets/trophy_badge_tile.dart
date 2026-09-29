import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class TrophyBadgeTile extends StatelessWidget {
  const TrophyBadgeTile({super.key, required this.title, required this.locked});

  final String title;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Icon(
                locked ? Icons.lock_outline : Icons.emoji_events_rounded,
                color: locked ? AppColors.locked : AppColors.gold,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.brown,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
