enum ActivityProfile { merchant, pagneSeller, employee, student }

enum FinancialGoal { cashbox, emergencySave, mobileMoney }

enum DailyPace { calm, recommended, intense }

extension ActivityProfileX on ActivityProfile {
  String get label => switch (this) {
    ActivityProfile.merchant => 'Commerçant',
    ActivityProfile.pagneSeller => 'Vendeur de pagnes',
    ActivityProfile.employee => 'Salarié',
    ActivityProfile.student => 'Étudiant',
  };

  String get hint => switch (this) {
    ActivityProfile.merchant => 'Boutique, kiosque, marché',
    ActivityProfile.pagneSeller => 'Stand de pagnes et tissus',
    ActivityProfile.employee => 'Salaire et budget perso',
    ActivityProfile.student => 'Argent de poche et projets',
  };
}

extension FinancialGoalX on FinancialGoal {
  String get label => switch (this) {
    FinancialGoal.cashbox => 'Mieux gérer ma caisse',
    FinancialGoal.emergencySave => 'Épargner pour les imprévus',
    FinancialGoal.mobileMoney => 'Maîtriser le Mobile Money',
  };
}

extension DailyPaceX on DailyPace {
  String get label => switch (this) {
    DailyPace.calm => '3 min / jour',
    DailyPace.recommended => '5 min / jour',
    DailyPace.intense => '10 min / jour',
  };

  String get hint => switch (this) {
    DailyPace.calm => 'Tranquille',
    DailyPace.recommended => 'Recommandé',
    DailyPace.intense => 'Intense',
  };
}

class Diagnostic {
  const Diagnostic({
    required this.activity,
    required this.goal,
    required this.pace,
  });

  final ActivityProfile activity;
  final FinancialGoal goal;
  final DailyPace pace;

  Map<String, String> toJson() => {
    'activity': activity.name,
    'goal': goal.name,
    'pace': pace.name,
  };

  static Diagnostic fromJson(Map<String, dynamic> json) {
    return Diagnostic(
      activity: ActivityProfile.values.byName(json['activity'] as String),
      goal: FinancialGoal.values.byName(json['goal'] as String),
      pace: DailyPace.values.byName(json['pace'] as String),
    );
  }
}
