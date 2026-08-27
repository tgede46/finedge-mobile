import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

/// Hero plein écran style Get Started (maquette Bôôns → FinEdge).
class GetStartedHero extends StatelessWidget {
  const GetStartedHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF7EC8E8),
                    Color(0xFFB8E0F0),
                    Color(0xFFE8F5E9),
                    SoftUiColors.cream,
                  ],
                  stops: [0, 0.35, 0.7, 1],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFF81C784),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
              ),
            ),
            const SafeArea(
              bottom: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'FinEdge',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: SoftUiColors.orangeDeep,
                        letterSpacing: -1,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Apprendre l’argent avec clarté',
                      style: TextStyle(
                        color: SoftUiColors.ink,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20),
                    _MascotBubble(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MascotBubble extends StatelessWidget {
  const _MascotBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Text('🦉', style: TextStyle(fontSize: 72)),
    );
  }
}
