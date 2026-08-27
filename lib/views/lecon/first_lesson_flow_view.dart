import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/streak_goals.dart';
import '../../widgets/continue_cta_button.dart';
import '../../widgets/create_profile_prompt.dart';
import '../../widgets/lesson_stat_card.dart';
import '../../widgets/streak_goal_list.dart';
import '../../widgets/streak_week_row.dart';

/// Après la 1ʳᵉ leçon : XP → habitude → série → objectif → (prompt compte si guest).
class FirstLessonFlowView extends StatefulWidget {
  const FirstLessonFlowView({super.key});

  @override
  State<FirstLessonFlowView> createState() => _FirstLessonFlowViewState();
}

class _FirstLessonFlowViewState extends State<FirstLessonFlowView> {
  int _step = 0;
  int? _streakGoal;

  /// 0 XP · 1 habitude · 2 série · 3 objectif · 4 prompt profil (guest)
  static const _profilePromptStep = 4;

  String get _ctaLabel => switch (_step) {
    0 => 'Récupérer les XP',
    1 => 'Continuer',
    2 => 'Je m’engage',
    3 => 'Valider mon objectif',
    _ => 'Continuer',
  };

  bool get _canContinue =>
      _step == _profilePromptStep || _step < 3 || _streakGoal != null;

  Future<void> _continue() async {
    if (!_canContinue) return;

    if (_step < 3) {
      setState(() => _step += 1);
      return;
    }

    if (_step == 3) {
      final session = SessionScope.of(context);
      await session.completeFirstLesson(
        xpEarned: 23,
        streakGoalDays: _streakGoal!,
      );
      if (!mounted) return;

      if (session.isGuest) {
        setState(() => _step = _profilePromptStep);
        return;
      }
      context.go('/accueil');
      return;
    }
  }

  void _onCreateProfile() {
    context.go('/login');
  }

  void _onLater() {
    context.go('/accueil');
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = SessionScope.of(context).isGuest;
    final showCta = _step != _profilePromptStep;

    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            children: [
              if (_step >= 2 && _step < _profilePromptStep)
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: _step == 2 ? 0.7 : 1,
                    minHeight: 8,
                    backgroundColor: SoftUiColors.progressTrack,
                    valueColor: const AlwaysStoppedAnimation(
                      SoftUiColors.orange,
                    ),
                  ),
                ),
              if (_step >= 2 && _step < _profilePromptStep)
                const SizedBox(height: 16),
              Expanded(
                child: _body(showTimerStat: isGuest),
              ),
              if (showCta)
                ContinueCtaButton(
                  enabled: _canContinue,
                  onPressed: _continue,
                  label: _ctaLabel,
                  showArrow: false,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body({required bool showTimerStat}) {
    return switch (_step) {
      0 => _XpClaimStep(showTimerStat: showTimerStat),
      1 => const _HabitIntroStep(),
      2 => const _StreakIntroStep(),
      3 => _StreakGoalStep(
        selected: _streakGoal,
        onSelect: (d) => setState(() => _streakGoal = d),
      ),
      _ => CreateProfilePrompt(
        onCreate: _onCreateProfile,
        onLater: _onLater,
      ),
    };
  }
}

class _XpClaimStep extends StatelessWidget {
  const _XpClaimStep({required this.showTimerStat});

  final bool showTimerStat;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 24),
        const Icon(
          Icons.emoji_events_rounded,
          size: 88,
          color: SoftUiColors.orange,
        ),
        const SizedBox(height: 16),
        Text(
          'Légende de l’apprentissage !',
          textAlign: TextAlign.center,
          style: AppTypography.display.copyWith(
            color: SoftUiColors.orangeDeep,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tu viens de terminer ta première leçon.',
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: SoftUiColors.muted),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const LessonStatCard(
              label: 'TOTAL XP',
              value: '23',
              icon: Icons.bolt_rounded,
              accent: SoftUiColors.orangeDeep,
            ),
            const SizedBox(width: 10),
            const LessonStatCard(
              label: 'RÉUSSITE',
              value: '93%',
              icon: Icons.my_location_rounded,
              accent: Color(0xFF00C076),
            ),
            if (showTimerStat) ...[
              const SizedBox(width: 10),
              const LessonStatCard(
                label: 'RAPIDE',
                value: '2:49',
                icon: Icons.timer_outlined,
                accent: Color(0xFF5B8DEF),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _HabitIntroStep extends StatelessWidget {
  const _HabitIntroStep();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Spacer(flex: 2),
        MascotBubble(
          message:
              'Bravo ! Maintenant, construisons l’habitude de pratiquer chaque jour.',
        ),
        Spacer(flex: 3),
      ],
    );
  }
}

class _StreakIntroStep extends StatelessWidget {
  const _StreakIntroStep();

  @override
  Widget build(BuildContext context) {
    final weekday = DateTime.now().weekday; // 1=Mon … 7=Sun
    return ListView(
      children: [
        const SizedBox(height: 12),
        const StreakHeroBlock(
          days: 1,
          message: 'Tu peux t’entraîner chaque jour ?',
        ),
        const SizedBox(height: 28),
        StreakWeekRow(completedWeekday: weekday),
      ],
    );
  }
}

class _StreakGoalStep extends StatelessWidget {
  const _StreakGoalStep({required this.selected, required this.onSelect});

  final int? selected;
  final ValueChanged<int> onSelect;

  String get _speech {
    if (selected == null) {
      return 'Fixons un objectif de série : 1 semaine, 1 mois ou 50 jours !';
    }
    return 'Objectif ${StreakGoals.labelFor(selected!)} : '
        '+${StreakGoals.lingotsFor(selected!)} lingots à la clé.';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8),
        MascotBubble(message: _speech),
        const SizedBox(height: 20),
        const Icon(
          Icons.calendar_month_rounded,
          size: 56,
          color: SoftUiColors.orangeDeep,
        ),
        if (selected != null) ...[
          const SizedBox(height: 4),
          Text(
            StreakGoals.labelFor(selected!),
            textAlign: TextAlign.center,
            style: AppTypography.display.copyWith(
              color: SoftUiColors.orangeDeep,
              fontSize: 32,
            ),
          ),
        ],
        const SizedBox(height: 16),
        StreakGoalList(
          options: StreakGoals.options,
          selectedDays: selected,
          onSelect: onSelect,
        ),
      ],
    );
  }
}
