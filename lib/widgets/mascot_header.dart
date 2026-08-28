import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';
import 'finedge_mascot.dart';

class MascotHeader extends StatelessWidget {
  const MascotHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const FinedgeMascot(size: 56),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.heading.copyWith(color: SoftUiColors.ink),
              ),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(color: SoftUiColors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
