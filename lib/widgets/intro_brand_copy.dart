import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class IntroBrandCopy extends StatelessWidget {
  const IntroBrandCopy({
    super.key,
    required this.titleOpacity,
    required this.subtitleOpacity,
  });

  final Animation<double> titleOpacity;
  final Animation<double> subtitleOpacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeTransition(
          opacity: titleOpacity,
          child: Text(
            'FinEdge',
            style: AppTypography.display.copyWith(color: AppColors.onPrimary),
          ),
        ),
        const SizedBox(height: 12),
        FadeTransition(
          opacity: subtitleOpacity,
          child: Text(
            'Salut ! Prêt à faire fructifier ton argent ?',
            style: AppTypography.body.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.95),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
