import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

/// Hero Get Started — charte crème / orange FinEdge (plein écran).
class GetStartedHero extends StatelessWidget {
  const GetStartedHero({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final mascotSize = (height * 0.18).clamp(120.0, 168.0);

    return Expanded(
      flex: 5,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE8CC), SoftUiColors.cream, SoftUiColors.cream],
            stops: [0, 0.55, 1],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const Text(
                  'FinEdge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: SoftUiColors.orangeDeep,
                    letterSpacing: -1.2,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Apprendre l’argent avec clarté',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SoftUiColors.ink,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Container(
                  width: mascotSize,
                  height: mascotSize,
                  decoration: BoxDecoration(
                    color: SoftUiColors.card,
                    shape: BoxShape.circle,
                    border: Border.all(color: SoftUiColors.border, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x28E07818),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.support_agent_rounded,
                    size: mascotSize * 0.42,
                    color: SoftUiColors.orangeDeep,
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
