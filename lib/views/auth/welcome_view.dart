import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/get_started_hero.dart';

/// Get Started épuré : Commencer + Se connecter.
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  Future<void> _start(BuildContext context) {
    return SessionScope.of(context).signIn(provider: 'guest');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: Column(
        children: [
          const GetStartedHero(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () => _start(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: SoftUiColors.orange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        'Commencer',
                        style: AppTypography.button.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text.rich(
                      TextSpan(
                        style: AppTypography.body.copyWith(
                          color: SoftUiColors.muted,
                        ),
                        children: [
                          const TextSpan(text: "J'ai déjà un compte ? "),
                          TextSpan(
                            text: 'Se connecter',
                            style: AppTypography.label.copyWith(
                              color: SoftUiColors.orangeDeep,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
