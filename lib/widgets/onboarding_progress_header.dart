import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

/// Barre d’étapes style capture : « ÉTAPE X SUR 3 » + progress.
class OnboardingProgressHeader extends StatelessWidget {
  const OnboardingProgressHeader({
    super.key,
    required this.step,
    required this.total,
    this.rightLabel,
    this.onBack,
  });

  final int step;
  final int total;
  final String? rightLabel;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final progress = (step / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onBack != null)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              color: SoftUiColors.ink,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: SoftUiColors.progressTrack,
            valueColor: const AlwaysStoppedAnimation(SoftUiColors.orange),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              'ÉTAPE $step SUR $total',
              style: const TextStyle(
                color: SoftUiColors.muted,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.6,
              ),
            ),
            const Spacer(),
            if (rightLabel != null)
              Text(
                rightLabel!,
                style: const TextStyle(
                  color: SoftUiColors.muted,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
