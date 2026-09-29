import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

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
          child: const Text(
            'FinEdge',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SoftUiColors.orangeDeep,
              fontWeight: FontWeight.w900,
              fontSize: 42,
              letterSpacing: -1,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 14),
        FadeTransition(
          opacity: subtitleOpacity,
          child: const Text(
            'Salut ! Prêt à faire fructifier ton argent ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SoftUiColors.ink,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
