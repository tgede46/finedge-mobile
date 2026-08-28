import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';
import 'finedge_mascot.dart';

/// Hero Get Started — logo coach + marque.
class GetStartedHero extends StatelessWidget {
  const GetStartedHero({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final mascotSize = (height * 0.2).clamp(128.0, 176.0);

    return Expanded(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE8CC), SoftUiColors.cream, SoftUiColors.cream],
            stops: [0, 0.45, 1],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: mascotSize,
                  height: mascotSize,
                  decoration: BoxDecoration(
                    color: SoftUiColors.card,
                    shape: BoxShape.circle,
                    border: Border.all(color: SoftUiColors.border, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33E07818),
                        blurRadius: 28,
                        spreadRadius: 2,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    FinedgeMascot.assetPath,
                    width: mascotSize * 0.88,
                    height: mascotSize * 0.88,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'FinEdge',
                  textAlign: TextAlign.center,
                  style: AppTypography.display.copyWith(
                    color: SoftUiColors.orangeDeep,
                    fontSize: 44,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
