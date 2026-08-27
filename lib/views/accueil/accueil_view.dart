import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/home_continue_card.dart';
import '../../widgets/home_quick_action.dart';
import '../../widgets/home_stats_row.dart';

class AccueilView extends StatelessWidget {
  const AccueilView({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context).session;
    final name = session.diagnostic?.displayName?.trim();
    final greeting = (name != null && name.isNotEmpty)
        ? 'Salut $name 👋'
        : 'Salut 👋';

    return ColoredBox(
      color: SoftUiColors.cream,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: const TextStyle(
                          color: SoftUiColors.ink,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Prêt pour ta quête financière ?',
                        style: TextStyle(
                          color: SoftUiColors.muted,
                          fontSize: 14,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: SoftUiColors.tanSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    color: SoftUiColors.orangeDeep,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const HomeStatsRow(streak: 0, xp: 0, lessonsDone: 0),
            const SizedBox(height: 18),
            HomeContinueCard(
              title: 'Continuer ta leçon',
              subtitle: session.diagnostic == null
                  ? 'Découvre le budget en FCFA en 3 minutes.'
                  : 'Reprends là où tu t’es arrêté.',
              onPressed: () => context.go('/lecons'),
            ),
            const SizedBox(height: 22),
            const Text(
              'Raccourcis',
              style: TextStyle(
                color: SoftUiColors.ink,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: HomeQuickAction(
                    icon: Icons.menu_book_rounded,
                    label: 'Leçons',
                    color: const Color(0xFFFFB74D),
                    onTap: () => context.go('/lecons'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeQuickAction(
                    icon: Icons.show_chart,
                    label: 'Simulateur',
                    color: const Color(0xFF81C784),
                    onTap: () => context.go('/simulateur'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeQuickAction(
                    icon: Icons.smart_toy_outlined,
                    label: 'Coach',
                    color: const Color(0xFF90CAF9),
                    onTap: () => context.go('/coach'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: SoftUiColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: SoftUiColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conseil du jour',
                    style: TextStyle(
                      color: SoftUiColors.orangeDeep,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sépare ton argent perso et ton argent business — même une petite caisse compte.',
                    style: TextStyle(
                      color: SoftUiColors.ink,
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
