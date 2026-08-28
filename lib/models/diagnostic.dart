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
    this.currency,
  });

  final List<String> goals;
  final String level;
  final String energy;
  final String avatar;

  /// entrepreneur | student | professional | civil_servant | merchant | other
  final String? occupation;
  final String? displayName;

  /// Intervalle d’âge : under_18 | 18_25 | 26_35 | 36_45 | 46_60 | 60_plus
  final String? age;
  final String? startMode;

  /// Identifiant AppCurrency (ngn, eur, xof…).
  final String? currency;

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
    if (avatar == 'explorateur' ||
        avatar == 'chanceux' ||
        avatar == 'entrepreneur' ||
        avatar == 'commercante') {
      return ActivityProfile.merchant;
    }
    if (avatar == 'econome' || avatar == 'etudiant') {
      return ActivityProfile.student;
    }
    if (avatar == 'stratege' || avatar == 'sage') {
      return ActivityProfile.employee;
    }
    return ActivityProfile.merchant;
  }

  bool get wantsCashbox =>
      goals.contains('commerce') ||
      occupation == 'merchant' ||
      occupation == 'entrepreneur' ||
      avatar == 'chanceux' ||
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
    if (currency != null) 'currency': currency,
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
        avatar: 'explorateur',
        occupation: json['activity'] as String?,
        displayName: json['displayName'] as String?,
        age: _parseAge(json['age'] ?? json['ageRange']),
      );
    }
    if (json.containsKey('activities')) {
      final priorities = (json['priorities'] as List?)?.cast<String>() ?? [];
      return Diagnostic(
        goals: priorities.isEmpty ? ['save_project'] : priorities,
        level: 'beginner',
        energy: json['pace'] as String? ?? 'recommended',
        avatar: 'explorateur',
        displayName: json['displayName'] as String?,
        age: _parseAge(json['age'] ?? json['ageRange']),
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
      avatar: json['avatar'] as String? ?? 'explorateur',
      occupation: json['occupation'] as String?,
      displayName: json['displayName'] as String?,
      age: _parseAge(json['age'] ?? json['ageRange']),
      startMode: json['startMode'] as String?,
      currency: json['currency'] as String?,
    );
  }

  /// Accepte un id d’intervalle ou un ancien âge numérique.
  static String? _parseAge(dynamic raw) {
    if (raw == null) return null;
    if (raw is String && raw.isNotEmpty) {
      if (raw.contains('_') || raw == 'under_18' || raw == '60_plus') {
        return raw;
      }
      final n = int.tryParse(raw);
      if (n != null) return _fromInt(n);
      return raw;
    }
    if (raw is int) return _fromInt(raw);
    return null;
  }

  static String _fromInt(int n) {
    if (n < 18) return 'under_18';
    if (n <= 25) return '18_25';
    if (n <= 35) return '26_35';
    if (n <= 45) return '36_45';
    if (n <= 60) return '46_60';
    return '60_plus';
  }
}
