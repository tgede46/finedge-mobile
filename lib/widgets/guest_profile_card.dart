import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/avatar_catalog.dart';
import 'fintech_header_card.dart';

class GuestProfileCard extends StatelessWidget {
  const GuestProfileCard({
    super.key,
    required this.subtitle,
    this.displayName = 'Invité',
    this.avatarId,
    this.onAvatarTap,
  });

  final String subtitle;
  final String displayName;
  final String? avatarId;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return FintechHeaderCard(
      child: Row(
        children: [
          FinedgeAvatar(avatarId: avatarId, radius: 32, onTap: onAvatarTap),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
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
