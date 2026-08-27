import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';

/// Écran question Duolingo : gros titre + contenu + CTA bas (charte FinEdge).
class DuoQuestionScaffold extends StatelessWidget {
  const DuoQuestionScaffold({
    super.key,
    required this.step,
    required this.total,
    required this.title,
    required this.child,
    required this.ctaLabel,
    required this.ctaEnabled,
    required this.onCta,
    this.onBack,
    this.footer,
    this.showClose = false,
  });

  final int step;
  final int total;
  final String title;
  final Widget child;
  final String ctaLabel;
  final bool ctaEnabled;
  final VoidCallback onCta;
  final VoidCallback? onBack;
  final Widget? footer;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    final progress = (step / total).clamp(0.05, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(
                showClose ? Icons.close : Icons.arrow_back_ios_new,
                size: 18,
              ),
              color: SoftUiColors.muted,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: SoftUiColors.progressTrack,
                  valueColor: const AlwaysStoppedAnimation(SoftUiColors.orange),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          title,
          style: AppTypography.display.copyWith(
            color: SoftUiColors.ink,
            fontSize: 28,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 22),
        Expanded(child: child),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton(
            onPressed: ctaEnabled ? onCta : null,
            style: FilledButton.styleFrom(
              backgroundColor: SoftUiColors.orange,
              disabledBackgroundColor: SoftUiColors.tanSoft,
              foregroundColor: Colors.white,
              disabledForegroundColor: SoftUiColors.muted,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              ctaLabel,
              style: AppTypography.button.copyWith(
                color: ctaEnabled ? Colors.white : SoftUiColors.muted,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
        if (footer != null) ...[const SizedBox(height: 12), footer!],
      ],
    );
  }
}
