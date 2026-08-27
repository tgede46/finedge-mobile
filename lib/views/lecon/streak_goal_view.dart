import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/streak_goals.dart';
import '../../widgets/continue_cta_button.dart';
import '../../widgets/streak_goal_list.dart';

/// Choisir (ou renouveler) un objectif de série.
class StreakGoalView extends StatefulWidget {
  const StreakGoalView({super.key, this.renew = false});

  final bool renew;

  @override
  State<StreakGoalView> createState() => _StreakGoalViewState();
}

class _StreakGoalViewState extends State<StreakGoalView> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context).session;
    final reached = session.isStreakGoalReached;

    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  color: SoftUiColors.muted,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    MascotBubble(
                      message: reached || widget.renew
                          ? 'Objectif atteint ! Tu veux en fixer un nouveau ?'
                          : 'Fixons un objectif de série !',
                    ),
                    if (reached) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: SoftUiColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: SoftUiColors.orange),
                        ),
                        child: Text(
                          'Bravo : ${StreakGoals.labelFor(session.streakGoalDays ?? 0)} '
                          'terminés · +${StreakGoals.lingotsFor(session.streakGoalDays ?? 0)} lingots',
                          textAlign: TextAlign.center,
                          style: AppTypography.optionTitle.copyWith(
                            color: SoftUiColors.orangeDeep,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 56,
                      color: SoftUiColors.orange,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selected == null
                          ? 'Choisis ta prochaine série'
                          : StreakGoals.labelFor(_selected!),
                      textAlign: TextAlign.center,
                      style: AppTypography.title.copyWith(
                        color: SoftUiColors.ink,
                      ),
                    ),
                    const SizedBox(height: 16),
                    StreakGoalList(
                      options: StreakGoals.options,
                      selectedDays: _selected,
                      onSelect: (d) => setState(() => _selected = d),
                    ),
                  ],
                ),
              ),
              ContinueCtaButton(
                enabled: _selected != null,
                onPressed: () async {
                  await SessionScope.of(context).setStreakGoal(_selected!);
                  if (!context.mounted) return;
                  context.go('/accueil');
                },
                label: reached || widget.renew
                    ? 'Nouvel objectif'
                    : 'Valider mon objectif',
                showArrow: false,
              ),
              if (reached || widget.renew) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go('/accueil'),
                  child: Text(
                    'Plus tard',
                    style: AppTypography.label.copyWith(
                      color: SoftUiColors.orangeDeep,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
