import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/get_started_hero.dart';

/// Premier écran : Commencer + Se connecter (design type Get Started).
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  Future<void> _start(BuildContext context) {
    return SessionScope.of(context).signIn(provider: 'guest');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const GetStartedHero(),
            Expanded(
              flex: 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 36,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const Text(
                              'Ton sentier financier commence ici',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: SoftUiColors.ink,
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Quelques questions, puis des leçons concrètes en FCFA et Mobile Money.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: SoftUiColors.muted,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      SoftUiColors.orange,
                                      SoftUiColors.orangeDeep,
                                    ],
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x40E07818),
                                      blurRadius: 16,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(28),
                                    onTap: () => _start(context),
                                    child: const Center(
                                      child: Text(
                                        'Commencer',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
