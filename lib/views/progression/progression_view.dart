import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/course_progress.dart';
import '../../widgets/home_continue_card.dart';
import '../../widgets/home_stats_row.dart';
import '../../widgets/streak_week_row.dart';

/// Progression — met en avant série, XP et sentier en cours.
class ProgressionView extends StatelessWidget {
  const ProgressionView({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = SessionScope.of(context);
    final session = sessionController.session;
    final inProgressId = sessionController.activeLessonId;
    final nextLessonId = CourseProgress.nextLessonId(session.completedLessonIds);

    final continueTitle = inProgressId != null
        ? 'Reprendre ta leçon'
        : session.hasCompletedFirstLesson
            ? 'Continuer ta leçon'
            : 'Commencer ta 1ʳᵉ leçon';
    final continueSubtitle = inProgressId != null
        ? 'Ta leçon est en cours.'
        : session.hasCompletedFirstLesson
            ? 'Poursuis ton sentier financier.'
            : '3 minutes · découvre le budget.';

    return ColoredBox(
      color: SoftUiColors.cream,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            // Titre
            Text(
              'Progression',
              style: AppTypography.display.copyWith(
                color: SoftUiColors.ink,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 18),
            // Stats principales
            HomeStatsRow(
              streak: session.streakDays,
              xp: session.xp,
              lessonsDone: session.completedLessonIds.length,
            ),
            const SizedBox(height: 18),
            // Série hebdo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: BoxDecoration(
                color: SoftUiColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: SoftUiColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Semaine en cours',
                    style: AppTypography.label.copyWith(
                      color: SoftUiColors.muted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  StreakWeekRow(completedWeekday: DateTime.now().weekday),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Continuer le sentier
            HomeContinueCard(
              title: continueTitle,
              subtitle: continueSubtitle,
              onPressed: () {
                if (inProgressId != null) {
                  context.push('/lecon/$inProgressId');
                } else if (session.hasCompletedFirstLesson) {
                  // Aller au sentier pour choisir la prochaine étape
                  context.go('/lecons');
                } else {
                  // Démarrage sur la première leçon
                  context.push('/lecon/${nextLessonId ?? 'besoins_envies'}');
                }
              },
            ),
            const SizedBox(height: 8),
            // Lien secondaire vers le sentier complet
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => context.go('/lecons'),
                icon: const Icon(Icons.alt_route_rounded, size: 18),
                label: Text(
                  'Voir le sentier',
                  style: AppTypography.caption.copyWith(
                    color: SoftUiColors.orangeDeep,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

