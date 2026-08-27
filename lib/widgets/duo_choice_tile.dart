import 'package:flutter/material.dart';

import '../core/feedback/app_feedback.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/onboarding_spacing.dart';
import '../core/theme/soft_ui_colors.dart';

/// Carte de choix style Duolingo (simple ou multi).
class DuoChoiceTile extends StatelessWidget {
  const DuoChoiceTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.leading,
    this.showCheck = false,
    this.badge,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool selected;
  final bool showCheck;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = selected ? SoftUiColors.orange : SoftUiColors.border;
    final bg = selected ? const Color(0xFFFFF1E0) : SoftUiColors.card;

    return Padding(
      padding: const EdgeInsets.only(bottom: OnboardingSpacing.betweenTiles),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            AppFeedback.selection();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: OnboardingSpacing.tilePadH,
              vertical: OnboardingSpacing.tilePadV,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border, width: selected ? 2.2 : 1.5),
            ),
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 14)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (badge != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            badge!,
                            style: AppTypography.caption.copyWith(
                              color: SoftUiColors.orangeDeep,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      Text(
                        title,
                        style: AppTypography.optionTitle.copyWith(
                          color: selected
                              ? SoftUiColors.orangeDeep
                              : SoftUiColors.ink,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: AppTypography.optionSubtitle.copyWith(
                            color: SoftUiColors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showCheck) ...[
                  const SizedBox(width: 10),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: selected
                            ? SoftUiColors.orange
                            : SoftUiColors.border,
                        width: 2,
                      ),
                      color: selected
                          ? SoftUiColors.orange
                          : Colors.transparent,
                    ),
                    child: selected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
