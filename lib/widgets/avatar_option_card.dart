import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';
import '../models/avatar_catalog.dart';

class AvatarOptionCard extends StatelessWidget {
  const AvatarOptionCard({
    super.key,
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final AvatarSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SoftUiColors.card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? SoftUiColors.orange : SoftUiColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: spec.tint,
                child: Icon(spec.icon, size: 32, color: SoftUiColors.ink),
              ),
              const SizedBox(height: 10),
              Text(
                spec.title,
                textAlign: TextAlign.center,
                style: AppTypography.optionTitle.copyWith(
                  color: SoftUiColors.ink,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                spec.subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.optionSubtitle.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
