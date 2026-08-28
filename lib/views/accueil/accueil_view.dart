import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/avatar_catalog.dart';
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
        ? 'Salut $name'
        : 'Salut';
    final inProgressId = SessionScope.of(context).activeLessonId;

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
                        style: AppTypography.display.copyWith(
                          color: SoftUiColors.ink,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prêt pour ta quête financière ?',
                        style: AppTypography.body.copyWith(
                          color: SoftUiColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                FinedgeAvatar(
                  avatarId: session.diagnostic?.avatar,
                  radius: 24,
                  onTap: () => context.go('/profil'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            HomeStatsRow(
              streak: session.streakDays,
              xp: session.xp,
              lessonsDone: session.hasCompletedFirstLesson ? 1 : 0,
            ),
            const SizedBox(height: 18),
            HomeContinueCard(
              title: inProgressId != null
                  ? 'Reprendre ta leçon'
                  : session.hasCompletedFirstLesson
                  ? 'Continuer ta leçon'
                  : 'Commencer ta 1ʳᵉ leçon',
              subtitle: inProgressId != null
                  ? 'Ta leçon est en cours.'
                  : session.hasCompletedFirstLesson
                  ? 'Poursuis ton sentier financier.'
                  : '3 minutes · découvre le budget.',
              onPressed: () {
                if (inProgressId != null) {
                  context.push('/lecon/$inProgressId');
                } else if (session.hasCompletedFirstLesson) {
                  context.go('/lecons');
                } else {
                  context.push('/lecon/besoins_envies');
                }
              },
            ),
            if (session.isStreakGoalReached) ...[
              const SizedBox(height: 12),
              HomeContinueCard(
                title: 'Objectif de série atteint !',
                subtitle: '4 questions pour affiner ton prochain défi.',
                onPressed: () => context.push('/renouvellement-serie'),
              ),
            ] else if (session.hasCompletedFirstLesson &&
                session.streakGoalDays != null) ...[
              const SizedBox(height: 12),
              Text(
                'Série : ${session.streakDays} / ${session.streakGoalDays} jours',
                style: AppTypography.label.copyWith(color: SoftUiColors.muted),
              ),
            ],
            const SizedBox(height: 22),
            Text(
              'Raccourcis',
              style: AppTypography.heading.copyWith(color: SoftUiColors.ink),
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
                    icon: Icons.emoji_events_rounded,
                    label: 'Classement',
                    color: const Color(0xFF81C784),
                    onTap: () => context.go('/classement'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeQuickAction(
                    icon: Icons.smart_toy_rounded,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conseil du jour',
                    style: AppTypography.label.copyWith(
                      color: SoftUiColors.orangeDeep,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sépare ton argent perso et ton argent business — même une petite caisse compte.',
                    style: AppTypography.body.copyWith(
                      color: SoftUiColors.ink,
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
