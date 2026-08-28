import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import 'finedge_mascot.dart';

class MascotHeader extends StatelessWidget {
  const MascotHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary,
          backgroundImage: AssetImage(FinedgeMascot.assetPath),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.heading),
              Text(subtitle, style: AppTypography.caption),
            ],
          ),
        ),
      ],
    );
  }
}
