import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import 'fintech_header_card.dart';

class GuestProfileCard extends StatelessWidget {
  const GuestProfileCard({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return FintechHeaderCard(
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.onPrimary,
            child: Icon(Icons.person, color: AppColors.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invité',
                  style: AppTypography.title.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
