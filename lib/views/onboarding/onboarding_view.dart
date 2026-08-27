import 'package:flutter/material.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/diagnostic.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int _step = 0;
  ActivityProfile? _activity;
  FinancialGoal? _goal;
  DailyPace? _pace;

  int get _totalSteps => 3;

  Future<void> _selectActivity(ActivityProfile value) async {
    setState(() {
      _activity = value;
      _step = 1;
    });
  }

  Future<void> _selectGoal(FinancialGoal value) async {
    setState(() {
      _goal = value;
      _step = 2;
    });
  }

  Future<void> _selectPace(DailyPace value) async {
    setState(() => _pace = value);
    final activity = _activity;
    final goal = _goal;
    if (activity == null || goal == null) return;
    await SessionScope.of(context).completeOnboarding(
      Diagnostic(activity: activity, goal: goal, pace: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_step + 1) / _totalSteps,
                minHeight: 6,
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              ),
              const SizedBox(height: 12),
              Text(
                'Étape ${_step + 1} / $_totalSteps',
                style: AppTypography.caption,
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary,
                child: Text('🦉', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 16),
              Text(_title, style: AppTypography.title),
              const SizedBox(height: 8),
              Text(_subtitle, style: AppTypography.body),
              const SizedBox(height: 24),
              Expanded(child: _stepBody()),
              if (_step > 0)
                TextButton(
                  onPressed: () => setState(() => _step -= 1),
                  child: Text(
                    'Retour',
                    style: AppTypography.label.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String get _title => switch (_step) {
    0 => 'Salut ! Qui es-tu ?',
    1 => 'Ton objectif prioritaire',
    _ => 'Combien de temps par jour ?',
  };

  String get _subtitle => switch (_step) {
    0 =>
      'Prêt à faire fructifier ton argent ? 3 clics et ton sentier est tracé.',
    1 => 'On place le premier nœud sur ce qui compte maintenant.',
    _ => 'Une micro-leçon, pas un cours. Tu pourras changer plus tard.',
  };

  Widget _stepBody() {
    return switch (_step) {
      0 => ListView(
        children: [
          for (final activity in ActivityProfile.values)
            _ChoiceCard(
              title: activity.label,
              subtitle: activity.hint,
              selected: _activity == activity,
              onTap: () => _selectActivity(activity),
            ),
        ],
      ),
      1 => ListView(
        children: [
          for (final goal in FinancialGoal.values)
            _ChoiceCard(
              title: goal.label,
              selected: _goal == goal,
              onTap: () => _selectGoal(goal),
            ),
        ],
      ),
      _ => ListView(
        children: [
          for (final pace in DailyPace.values)
            _ChoiceCard(
              title: pace.label,
              subtitle: pace.hint,
              selected: _pace == pace,
              onTap: () => _selectPace(pace),
            ),
        ],
      ),
    };
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.selected = false,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.brown.withValues(alpha: 0.08),
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.heading),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: AppTypography.caption),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
