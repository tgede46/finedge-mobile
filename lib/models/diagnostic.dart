enum ActivityProfile { merchant, pagneSeller, employee, student }

enum DailyPace { calm, recommended, intense }

extension ActivityProfileX on ActivityProfile {
  String get label => switch (this) {
    ActivityProfile.merchant => 'Commerçant',
    ActivityProfile.pagneSeller => 'Vendeur de pagnes',
    ActivityProfile.employee => 'Salarié',
    ActivityProfile.student => 'Étudiant',
  };
}

extension DailyPaceX on DailyPace {
  String get label => switch (this) {
    DailyPace.calm => 'Tranquille',
    DailyPace.recommended => 'Régulier',
    DailyPace.intense => 'Intense',
  };
}

class Diagnostic {
  const Diagnostic({
    required this.goals,
    required this.level,
    required this.energy,
    required this.avatar,
    this.displayName,
    this.age,
  });

  final List<String> goals;
  final String level;
  final String energy;
  final String avatar;
  final String? displayName;
  final int? age;

  DailyPace get pace => switch (energy) {
    'calm' => DailyPace.calm,
    'intense' => DailyPace.intense,
    _ => DailyPace.recommended,
  };

  ActivityProfile get activity {
    if (avatar == 'entrepreneur' || avatar == 'commercante') {
      return ActivityProfile.merchant;
    }
    if (avatar == 'etudiant') return ActivityProfile.student;
    if (avatar == 'sage') return ActivityProfile.employee;
    return ActivityProfile.merchant;
  }

  bool get wantsCashbox =>
      goals.contains('commerce') || avatar == 'commercante';

  bool get wantsMobileMoney =>
      goals.contains('overdraft') || goals.contains('budget');

  bool get wantsEmergency =>
      goals.contains('save_project') ||
      goals.contains('overdraft') ||
      goals.contains('budget');

  bool get wantsInvest => goals.contains('invest');

  Map<String, dynamic> toJson() => {
    'goals': goals,
    'level': level,
    'energy': energy,
    'avatar': avatar,
    if (displayName != null) 'displayName': displayName,
    if (age != null) 'age': age,
  };

  static Diagnostic fromJson(Map<String, dynamic> json) {
    // Anciens formats
    if (json.containsKey('activity') && json.containsKey('goal')) {
      final goal = json['goal'] as String;
      return Diagnostic(
        goals: switch (goal) {
          'cashbox' => ['commerce'],
          'emergencySave' => ['save_project'],
          _ => ['invest'],
        },
        level: 'beginner',
        energy: json['pace'] as String? ?? 'recommended',
        avatar: 'entrepreneur',
        displayName: json['displayName'] as String?,
        age: json['age'] as int?,
      );
    }
    if (json.containsKey('activities')) {
      final priorities = (json['priorities'] as List?)?.cast<String>() ?? [];
      return Diagnostic(
        goals: priorities.isEmpty ? ['save_project'] : priorities,
        level: 'beginner',
        energy: json['pace'] as String? ?? 'recommended',
        avatar: 'entrepreneur',
        displayName: json['displayName'] as String?,
        age: json['age'] as int?,
      );
    }

    List<String> listOf(String key) {
      final raw = json[key];
      if (raw is List) return raw.map((e) => e.toString()).toList();
      return const [];
    }

    return Diagnostic(
      goals: listOf('goals'),
      level: json['level'] as String? ?? 'beginner',
      energy: json['energy'] as String? ?? 'recommended',
      avatar: json['avatar'] as String? ?? 'entrepreneur',
      displayName: json['displayName'] as String?,
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse('${json['age'] ?? ''}'),
    );
  }
}
