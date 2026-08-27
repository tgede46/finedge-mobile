import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class IntroMascot extends StatelessWidget {
  const IntroMascot({super.key, required this.scale, required this.opacity});

  final Animation<double> scale;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: ScaleTransition(
        scale: scale,
        child: Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: AppColors.onPrimary.withValues(alpha: 0.16),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.onPrimary, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.45),
                blurRadius: 28,
                spreadRadius: 4,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text('🦉', style: TextStyle(fontSize: 64)),
        ),
      ),
    );
  }
}
