import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';
import 'continue_cta_button.dart';
import 'finedge_mascot.dart';

/// Prompt « crée ton profil » (style Duolingo, charte FinEdge).
class CreateProfilePrompt extends StatelessWidget {
  const CreateProfilePrompt({
    super.key,
    required this.onCreate,
    required this.onLater,
  });

  final VoidCallback onCreate;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        const FinedgeMascot(size: 112, emojiSize: 56),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: SoftUiColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SoftUiColors.border, width: 1.8),
          ),
          child: Text(
            'Ne perds pas ta progression ! Créons ton profil FinEdge.',
            textAlign: TextAlign.center,
            style: AppTypography.speech.copyWith(color: SoftUiColors.ink),
          ),
        ),
        const Spacer(flex: 3),
        ContinueCtaButton(
          enabled: true,
          onPressed: onCreate,
          label: 'Créer mon profil',
          showArrow: false,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: onLater,
          child: Text(
            'Plus tard',
            style: AppTypography.label.copyWith(
              color: SoftUiColors.orangeDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
