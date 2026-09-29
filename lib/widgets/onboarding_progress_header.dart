import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

/// Header Duolingo : retour + barre de progression.
class OnboardingProgressHeader extends StatelessWidget {
  const OnboardingProgressHeader({
    super.key,
    required this.step,
    required this.total,
    this.onBack,
  });

  final int step;
  final int total;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final progress = (step / total).clamp(0.05, 1.0);
    return Row(
      children: [
        if (onBack != null)
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            color: SoftUiColors.muted,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          )
        else
          const SizedBox(width: 40),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: SoftUiColors.progressTrack,
              valueColor: const AlwaysStoppedAnimation(SoftUiColors.orange),
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
