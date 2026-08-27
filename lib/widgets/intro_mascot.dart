import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

class IntroMascot extends StatelessWidget {
  const IntroMascot({
    super.key,
    required this.scale,
    required this.opacity,
    required this.glow,
    required this.size,
  });

  final Animation<double> scale;
  final Animation<double> opacity;
  final Animation<double> glow;
  final double size;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: ScaleTransition(
        scale: scale,
        child: AnimatedBuilder(
          animation: glow,
          builder: (context, child) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: SoftUiColors.card,
                shape: BoxShape.circle,
                border: Border.all(color: SoftUiColors.border, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: SoftUiColors.orange.withValues(
                      alpha: 0.22 + (glow.value * 0.28),
                    ),
                    blurRadius: 18 + (glow.value * 22),
                    spreadRadius: 2 + (glow.value * 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: Icon(
            Icons.support_agent_rounded,
            size: size * 0.44,
            color: SoftUiColors.orangeDeep,
          ),
        ),
      ),
    );
  }
}
