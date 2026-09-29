import 'package:flutter/material.dart';

import '../core/feedback/app_feedback.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';

class ContinueCtaButton extends StatelessWidget {
  const ContinueCtaButton({
    super.key,
    required this.enabled,
    required this.onPressed,
    this.label = 'Continuer',
    this.showArrow = true,
  });

  final bool enabled;
  final VoidCallback onPressed;
  final String label;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: enabled
            ? () {
                AppFeedback.light();
                onPressed();
              }
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: enabled ? SoftUiColors.orange : SoftUiColors.tanSoft,
          foregroundColor: enabled ? Colors.white : SoftUiColors.muted,
          disabledBackgroundColor: SoftUiColors.tanSoft,
          disabledForegroundColor: SoftUiColors.muted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTypography.button.copyWith(
                color: enabled ? Colors.white : SoftUiColors.muted,
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
