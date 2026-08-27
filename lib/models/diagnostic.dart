enum ActivityProfile {
  merchant,
  entrepreneur,
  employee,
  civilServant,
  student,
  other,
}

enum DailyPace { calm, recommended, intense }

extension ActivityProfileX on ActivityProfile {
  String get label => switch (this) {
    ActivityProfile.merchant => 'Commerçant',
    ActivityProfile.entrepreneur => 'Entrepreneur',
    ActivityProfile.employee => 'Professionnel',
    ActivityProfile.civilServant => 'Fonctionnaire',
    ActivityProfile.student => 'Étudiant',
    ActivityProfile.other => 'Autre',
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
    this.occupation,
    this.displayName,
    this.age,
    this.startMode,
  });

  final List<String> goals;
  final String level;
  final String energy;
  final String avatar;

  /// entrepreneur | student | professional | civil_servant | merchant | other
  final String? occupation;
  final String? displayName;
  final int? age;
  final String? startMode;

  DailyPace get pace => switch (energy) {
    'calm' => DailyPace.calm,
    'intense' => DailyPace.intense,
    _ => DailyPace.recommended,
  };

  ActivityProfile get activity {
    switch (occupation) {
      case 'entrepreneur':
        return ActivityProfile.entrepreneur;
      case 'merchant':
        return ActivityProfile.merchant;
      case 'student':
        return ActivityProfile.student;
      case 'civil_servant':
        return ActivityProfile.civilServant;
      case 'professional':
        return ActivityProfile.employee;
      case 'other':
        return ActivityProfile.other;
    }
    if (avatar == 'entrepreneur' || avatar == 'commercante') {
      return ActivityProfile.merchant;
    }
    if (avatar == 'etudiant') return ActivityProfile.student;
    if (avatar == 'sage') return ActivityProfile.employee;
    return ActivityProfile.merchant;
  }

  bool get wantsCashbox =>
      goals.contains('commerce') ||
      occupation == 'merchant' ||
      occupation == 'entrepreneur' ||
      avatar == 'commercante';

  bool get wantsMobileMoney =>
      goals.contains('overdraft') || goals.contains('budget');

  bool get wantsEmergency =>
      goals.contains('save_project') ||
      goals.contains('overdraft') ||
      goals.contains('budget') ||
      goals.contains('family');

  bool get wantsInvest => goals.contains('invest');

  Map<String, dynamic> toJson() => {
    'goals': goals,
    'level': level,
    'energy': energy,
    'avatar': avatar,
    if (occupation != null) 'occupation': occupation,
    if (displayName != null) 'displayName': displayName,
    if (age != null) 'age': age,
    if (startMode != null) 'startMode': startMode,
  };

  static Diagnostic fromJson(Map<String, dynamic> json) {
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
        occupation: json['activity'] as String?,
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
      occupation: json['occupation'] as String?,
      displayName: json['displayName'] as String?,
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse('${json['age'] ?? ''}'),
      startMode: json['startMode'] as String?,
    );
  }
}
