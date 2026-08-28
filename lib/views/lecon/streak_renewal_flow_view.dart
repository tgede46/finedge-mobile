import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/onboarding_spacing.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/streak_goals.dart';
import '../../widgets/continue_cta_button.dart';
import '../../widgets/duo_choice_tile.dart';
import '../../widgets/mascot_speech_header.dart';
import '../../widgets/onboarding_progress_header.dart';
import '../../widgets/streak_goal_list.dart';

/// Après objectif atteint : 4 questions approfondies → nouvelle période.
/// « Plus tard » = on reprend la même durée par défaut (7 / 30 / 50).
class StreakRenewalFlowView extends StatefulWidget {
  const StreakRenewalFlowView({super.key});

  @override
  State<StreakRenewalFlowView> createState() => _StreakRenewalFlowViewState();
}

class _StreakRenewalFlowViewState extends State<StreakRenewalFlowView> {
  /// 0 célébration · 1–4 questions · 5 nouvelle période
  static const _totalSteps = 6;
  int _step = 0;

  final Map<String, String> _answers = {};
  int? _nextGoal;

  static const _questions = [
    (
      'feeling',
      'Comment te sens-tu avec ton argent maintenant ?',
      [
        ('more_confident', 'Plus à l’aise qu’avant'),
        ('same', 'À peu près pareil'),
        ('still_lost', 'Encore un peu perdu·e'),
        ('motivated', 'Motivé·e à aller plus loin'),
      ],
    ),
    (
      'helped',
      'Qu’est-ce qui t’a le plus aidé pendant cette série ?',
      [
        ('lessons', 'Les leçons du sentier'),
        ('coach', 'Le coach'),
        ('ranking', 'Le classement'),
        ('habit', 'Le rythme quotidien'),
      ],
    ),
    (
      'hard',
      'Qu’est-ce qui reste encore difficile ?',
      [
        ('budget', 'Suivre mon budget'),
        ('save', 'Épargner régulièrement'),
        ('commerce', 'Séparer perso et business'),
        ('temptation', 'Résister aux dépenses impulsives'),
      ],
    ),
    (
      'next_focus',
      'Pour la suite, tu veux plutôt…',
      [
        ('consolidate', 'Consolider ce que j’ai appris'),
        ('deeper', 'Approfondir un sujet précis'),
        ('new_theme', 'Explorer un nouveau thème'),
        ('challenge', 'Me challenger davantage'),
      ],
    ),
  ];

  bool get _canContinue {
    if (_step == 0) return true;
    if (_step >= 1 && _step <= 4) {
      final key = _questions[_step - 1].$1;
      return _answers[key] != null;
    }
    return _nextGoal != null;
  }

  String get _ctaLabel => switch (_step) {
    0 => 'Continuer',
    5 => 'Valider mon nouvel objectif',
    _ => 'Suivant',
  };

  Future<void> _finish({required bool keepSameGoal}) async {
    final session = SessionScope.of(context);
    final previous = session.session.streakGoalDays ?? 7;
    final next = keepSameGoal ? previous : (_nextGoal ?? previous);
    await session.renewStreakGoal(
      deepenAnswers: Map<String, String>.from(_answers),
      nextGoalDays: next,
    );
    if (!mounted) return;
    context.go('/accueil');
  }

  Future<void> _continue() async {
    if (!_canContinue) return;
    if (_step < 5) {
      setState(() => _step += 1);
      return;
    }
    await _finish(keepSameGoal: false);
  }

  void _back() {
    if (_step <= 0) {
      context.pop();
      return;
    }
    setState(() => _step -= 1);
  }

  @override
  Widget build(BuildContext context) {
    final previous = SessionScope.of(context).session.streakGoalDays ?? 7;

    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            OnboardingSpacing.screenH,
            OnboardingSpacing.screenTop,
            OnboardingSpacing.screenH,
            OnboardingSpacing.screenBottom,
          ),
          child: Column(
            children: [
              OnboardingProgressHeader(
                step: _step + 1,
                total: _totalSteps,
                onBack: _back,
              ),
              const SizedBox(height: OnboardingSpacing.afterProgress),
              Expanded(child: _body(previousGoalDays: previous)),
              const SizedBox(height: OnboardingSpacing.beforeCta),
              if (_step == 5) ...[
                ContinueCtaButton(
                  enabled: _canContinue,
                  onPressed: _continue,
                  label: _ctaLabel,
                  showArrow: false,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _finish(keepSameGoal: true),
                  child: Text(
                    'Plus tard · garder ${StreakGoals.labelFor(previous)}',
                    style: AppTypography.label.copyWith(
                      color: SoftUiColors.orangeDeep,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ] else
                ContinueCtaButton(
                  enabled: _canContinue,
                  onPressed: _continue,
                  label: _ctaLabel,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body({required int previousGoalDays}) {
    if (_step == 0) {
      return ListView(
        children: [
          MascotSpeechHeader(
            message:
                'Bravo ! Objectif ${StreakGoals.labelFor(previousGoalDays)} atteint. '
                'Quelques questions pour mieux te connaître…',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SoftUiColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: SoftUiColors.orange),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 48,
                  color: SoftUiColors.orange,
                ),
                const SizedBox(height: 12),
                Text(
                  '+${StreakGoals.lingotsFor(previousGoalDays)} lingots',
                  style: AppTypography.title.copyWith(
                    color: SoftUiColors.orangeDeep,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'On affine ton parcours avec 4 questions plus précises.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(color: SoftUiColors.muted),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_step >= 1 && _step <= 4) {
      final q = _questions[_step - 1];
      final key = q.$1;
      final selected = _answers[key];
      return ListView(
        children: [
          MascotSpeechHeader(message: q.$2),
          const SizedBox(height: OnboardingSpacing.afterSpeech),
          for (final o in q.$3)
            DuoChoiceTile(
              title: o.$2,
              selected: selected == o.$1,
              onTap: () => setState(() => _answers[key] = o.$1),
            ),
        ],
      );
    }

    return ListView(
      children: [
        MascotSpeechHeader(
          message:
              'Tu veux encore t’engager sur quelle période ? '
              '(Tu peux passer, on garde ${StreakGoals.labelFor(previousGoalDays)}.)',
        ),
        const SizedBox(height: OnboardingSpacing.afterSpeech),
        StreakGoalList(
          options: StreakGoals.options,
          selectedDays: _nextGoal,
          onSelect: (d) => setState(() => _nextGoal = d),
        ),
      ],
    );
  }
}
