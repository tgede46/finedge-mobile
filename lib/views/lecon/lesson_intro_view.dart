import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/course_curriculum.dart';

/// Intro d’une leçon (ex. Besoins vs Envies).
class LessonIntroView extends StatelessWidget {
  const LessonIntroView({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context).session;
    final copy = CourseCurriculum.lessonCopy[lessonId];
    final title =
        copy?.$1 ??
        CourseCurriculum.byId(
          lessonId,
          firstLessonDone: session.hasCompletedFirstLesson,
        )?.title ??
        'Leçon';
    final description =
        copy?.$2 ??
        'Prépare-toi : quelques minutes pour progresser sur ton sentier.';
    final xp = session.xp > 0 ? session.xp : 1250;

    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: SoftUiColors.muted,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.12,
                        minHeight: 10,
                        backgroundColor: SoftUiColors.progressTrack,
                        color: SoftUiColors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.monetization_on_rounded,
                    color: SoftUiColors.orangeDeep,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatXp(xp)} XP',
                    style: AppTypography.label.copyWith(
                      color: SoftUiColors.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                decoration: BoxDecoration(
                  color: SoftUiColors.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: SoftUiColors.border),
                ),
                child: lessonId == 'besoins_envies'
                    ? const _BesoinsIllustration()
                    : Icon(
                        Icons.menu_book_rounded,
                        size: 88,
                        color: SoftUiColors.orangeDeep,
                      ),
              ),
              const SizedBox(height: 28),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.display.copyWith(
                  color: SoftUiColors.orangeDeep,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: SoftUiColors.ink,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    if (lessonId == 'besoins_envies' &&
                        !session.hasCompletedFirstLesson) {
                      // Fin de leçon (UI) → puis flow 1ʳᵉ leçon / série.
                      // Quiz 10 Q + vies 5/jour : plus tard.
                      context.push(
                        '/lecon-complete?xp=125&next=/premiere-lecon',
                      );
                      return;
                    }
                    context.push('/lecon-complete?xp=80&next=/lecons');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: SoftUiColors.orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'C’est parti',
                    style: AppTypography.button.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatXp(int xp) {
    final s = xp.toString();
    if (s.length <= 3) return s;
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _BesoinsIllustration extends StatelessWidget {
  const _BesoinsIllustration();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _ThoughtChip(
              label: 'Besoins',
              icon: Icons.restaurant_rounded,
              color: Color(0xFFE57373),
            ),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: SoftUiColors.tanSoft,
                shape: BoxShape.circle,
                border: Border.all(color: SoftUiColors.border),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 48,
                color: SoftUiColors.orangeDeep,
              ),
            ),
            const _ThoughtChip(
              label: 'Envies',
              icon: Icons.smartphone_rounded,
              color: Color(0xFF64B5F6),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Marché · budget du jour',
          style: AppTypography.caption.copyWith(color: SoftUiColors.muted),
        ),
      ],
    );
  }
}

class _ThoughtChip extends StatelessWidget {
  const _ThoughtChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
      ],
    );
  }
}
