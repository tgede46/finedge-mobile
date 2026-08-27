import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/get_started_hero.dart';

/// Premier écran : Commencer + Se connecter — charte FinEdge crème / orange.
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
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: SoftUiColors.card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(top: BorderSide(color: SoftUiColors.border)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
                  child: Column(
                    children: [
                      const Text(
                        'Ton sentier financier commence ici',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SoftUiColors.ink,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Essaie quelques leçons, puis on personnalise ton aventure en FCFA et Mobile Money.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SoftUiColors.muted,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const Spacer(),
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
                          child: const Text(
                            'Commencer',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: const Text.rich(
                          TextSpan(
                            style: TextStyle(
                              color: SoftUiColors.muted,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(text: "J'ai déjà un compte ? "),
                              TextSpan(
                                text: 'Se connecter',
                                style: TextStyle(
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
            ),
          ),
        ],
      ),
    );
  }
}
