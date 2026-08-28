import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/finedge_mascot.dart';

/// Page À propos — mission éducation financière FinEdge.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      appBar: AppBar(
        backgroundColor: SoftUiColors.cream,
        elevation: 0,
        foregroundColor: SoftUiColors.ink,
        title: Text(
          'À propos',
          style: AppTypography.heading.copyWith(color: SoftUiColors.ink),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        children: [
          const Center(child: FinedgeMascot(size: 120, emojiSize: 64)),
          const SizedBox(height: 20),
          Text(
            'FinEdge',
            textAlign: TextAlign.center,
            style: AppTypography.display.copyWith(
              color: SoftUiColors.orangeDeep,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ton coach d’éducation financière',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: SoftUiColors.muted),
          ),
          const SizedBox(height: 28),
          _block(
            title: 'Notre mission',
            body:
                'FinEdge aide chacun à comprendre et maîtriser son argent — '
                'budget, épargne, commerce, investissement — avec des leçons '
                'courtes, concrètes et adaptées à la vie réelle en Afrique.',
          ),
          const SizedBox(height: 16),
          _block(
            title: 'Comment ça marche',
            body:
                'Diagnostic personnalisé, sentier de leçons, quiz interactifs '
                'et série quotidienne : tu progresses à ton rythme, en quelques '
                'minutes par jour, comme sur une app de langue.',
          ),
          const SizedBox(height: 16),
          _block(
            title: 'Pour qui',
            body:
                'Étudiants, commerçants, entrepreneurs, salariés — '
                'débutant ou déjà à l’aise, FinEdge t’accompagne pour '
                'prendre de meilleures décisions avec ton argent.',
          ),
          const SizedBox(height: 28),
          Text(
            'Version MVP · multiplateforme',
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: SoftUiColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _block({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SoftUiColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SoftUiColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.label.copyWith(
              color: SoftUiColors.orangeDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppTypography.body.copyWith(
              color: SoftUiColors.ink,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
