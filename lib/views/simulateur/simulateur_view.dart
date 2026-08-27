import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/choice_button.dart';
import '../../widgets/cockpit_metric_chip.dart';
import '../../widgets/comic_scene_card.dart';
import '../../widgets/fintech_header_card.dart';

class SimulateurView extends StatelessWidget {
  const SimulateurView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            FintechHeaderCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cockpit caisse',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('50 000 FCFA', style: AppTypography.amount),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      CockpitMetricChip(label: 'Stock', value: '10 pagnes'),
                      SizedBox(width: 8),
                      CockpitMetricChip(label: 'Créances', value: '0 FCFA'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const ComicSceneCard(
              title: 'Tante Henriette arrive au stand',
              dialogue: '« Mon neveu, donne-moi 2 pagnes à crédit pour la fête de dimanche ! »',
            ),
            const SizedBox(height: 16),
            Text('Tes choix', style: AppTypography.heading),
            const SizedBox(height: 10),
            const ChoiceButton(
              label: 'Comptant 10 000 F',
              color: AppColors.success,
            ),
            const SizedBox(height: 8),
            const ChoiceButton(label: 'Acompte 50 %', color: AppColors.primary),
            const SizedBox(height: 8),
            const ChoiceButton(label: 'Refus poli', color: AppColors.warning),
          ],
        ),
      ),
    );
  }
}
