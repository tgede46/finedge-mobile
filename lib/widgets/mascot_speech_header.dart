import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';
import 'finedge_mascot.dart';

/// Mascotte coach (renard) + bulle de dialogue.
class MascotSpeechHeader extends StatelessWidget {
  const MascotSpeechHeader({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: SoftUiColors.tanSoft,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: SoftUiColors.border),
          ),
          alignment: Alignment.center,
          child: const Text(
            FinedgeMascot.emoji,
            style: TextStyle(fontSize: 34),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: SoftUiColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: SoftUiColors.border, width: 1.8),
            ),
            child: Text(
              message,
              style: AppTypography.speech.copyWith(color: SoftUiColors.ink),
            ),
          ),
        ),
      ],
    );
  }
}
