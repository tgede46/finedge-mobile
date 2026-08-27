import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';

/// Onglet 2 — Simulateur BD (cockpit + scène, Story 3.x ensuite).
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppGradients.fintech,
                borderRadius: BorderRadius.circular(24),
              ),
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
                  Row(
                    children: [
                      _MetricChip(label: 'Stock', value: '10 pagnes'),
                      const SizedBox(width: 8),
                      _MetricChip(label: 'Créances', value: '0 FCFA'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.storefront,
                        color: AppColors.onPrimary,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tante Henriette arrive au stand',
                      style: AppTypography.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '« Mon neveu, donne-moi 2 pagnes à crédit pour la fête de dimanche ! »',
                      style: AppTypography.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Tes choix', style: AppTypography.heading),
            const SizedBox(height: 10),
            const _ChoiceButton(
              label: 'Comptant 10 000 F',
              color: AppColors.success,
            ),
            const SizedBox(height: 8),
            const _ChoiceButton(
              label: 'Acompte 50 %',
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            const _ChoiceButton(label: 'Refus poli', color: AppColors.warning),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.onPrimary.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.caption.copyWith(color: AppColors.onPrimary),
            ),
            Text(
              value,
              style: AppTypography.label.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(backgroundColor: color),
        child: Text(label),
      ),
    );
  }
}
