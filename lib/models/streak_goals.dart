import '../widgets/streak_goal_list.dart';

/// Objectifs de série FinEdge : semaine → mois → 50 jours.
abstract final class StreakGoals {
  static const options = [
    StreakGoalOption(days: 7, rewardLabel: '1 semaine · gagne 70 lingots'),
    StreakGoalOption(days: 30, rewardLabel: '1 mois · gagne 300 lingots'),
    StreakGoalOption(days: 50, rewardLabel: '50 jours · gagne 500 lingots'),
  ];

  static String labelFor(int days) => switch (days) {
    7 => '1 semaine',
    30 => '1 mois',
    50 => '50 jours',
    _ => '$days jours',
  };

  static int lingotsFor(int days) => switch (days) {
    7 => 70,
    30 => 300,
    50 => 500,
    _ => days * 10,
  };
}
