import 'diagnostic.dart';
import 'learning_path.dart';
import 'mfa_method.dart';

class GuestSession {
  const GuestSession({
    required this.localId,
    this.diagnostic,
    this.hasSeenIntro = false,
    this.authProvider,
    this.mfaMethod = MfaMethod.none,
    this.email,
    this.xp = 0,
    this.streakDays = 0,
    this.streakGoalDays,
    this.hasCompletedFirstLesson = false,
    this.deepenAnswers = const {},
  });

  final String localId;
  final Diagnostic? diagnostic;
  final bool hasSeenIntro;
  final String? authProvider;
  final MfaMethod mfaMethod;
  final String? email;
  final int xp;
  final int streakDays;
  final int? streakGoalDays;
  final bool hasCompletedFirstLesson;
  final Map<String, String> deepenAnswers;

  bool get isOnboarded => diagnostic != null;
  bool get isSignedIn => authProvider != null;
  bool get isStreakGoalReached =>
      streakGoalDays != null && streakDays >= streakGoalDays!;

  LearningPath get path => diagnostic == null
      ? const LearningPath(nodes: [])
      : LearningPath.fromDiagnostic(diagnostic!);

  Map<String, dynamic> toJson() => {
    'localId': localId,
    'hasSeenIntro': hasSeenIntro,
    'mfaMethod': mfaMethod.id,
    'xp': xp,
    'streakDays': streakDays,
    'hasCompletedFirstLesson': hasCompletedFirstLesson,
    if (streakGoalDays != null) 'streakGoalDays': streakGoalDays,
    if (deepenAnswers.isNotEmpty) 'deepenAnswers': deepenAnswers,
    if (authProvider != null) 'authProvider': authProvider,
    if (email != null) 'email': email,
    if (diagnostic != null) 'diagnostic': diagnostic!.toJson(),
  };

  static GuestSession fromJson(Map<String, dynamic> json) {
    final raw = json['diagnostic'];
    return GuestSession(
      localId: json['localId'] as String,
      hasSeenIntro: json['hasSeenIntro'] == true,
      authProvider: json['authProvider'] as String?,
      email: json['email'] as String?,
      mfaMethod: MfaMethodX.fromId(json['mfaMethod'] as String?),
      xp: json['xp'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      streakGoalDays: json['streakGoalDays'] as int?,
      hasCompletedFirstLesson: json['hasCompletedFirstLesson'] == true,
      deepenAnswers: () {
        final raw = json['deepenAnswers'];
        if (raw is Map) {
          return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
        }
        return <String, String>{};
      }(),
      diagnostic: raw is Map
          ? Diagnostic.fromJson(Map<String, dynamic>.from(raw))
          : null,
    );
  }

  GuestSession copyWith({
    Diagnostic? diagnostic,
    bool? hasSeenIntro,
    String? authProvider,
    MfaMethod? mfaMethod,
    String? email,
    int? xp,
    int? streakDays,
    int? streakGoalDays,
    bool? hasCompletedFirstLesson,
    Map<String, String>? deepenAnswers,
  }) {
    return GuestSession(
      localId: localId,
      diagnostic: diagnostic ?? this.diagnostic,
      hasSeenIntro: hasSeenIntro ?? this.hasSeenIntro,
      authProvider: authProvider ?? this.authProvider,
      mfaMethod: mfaMethod ?? this.mfaMethod,
      email: email ?? this.email,
      xp: xp ?? this.xp,
      streakDays: streakDays ?? this.streakDays,
      streakGoalDays: streakGoalDays ?? this.streakGoalDays,
      hasCompletedFirstLesson:
          hasCompletedFirstLesson ?? this.hasCompletedFirstLesson,
      deepenAnswers: deepenAnswers ?? this.deepenAnswers,
    );
  }
}
