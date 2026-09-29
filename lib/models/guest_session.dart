import 'diagnostic.dart';
import 'learning_path.dart';
import 'mfa_method.dart';
import 'course_progress.dart';

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
    this.lessonProgress = const {},
    this.completedLessonIds = const {},
    this.diagnosticHistory = const [],
    this.quizLivesRemaining = CourseProgress.dailyQuizLives,
    this.quizLivesDay,
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
  /// Index d’étape en cours par leçon (reprise après quit).
  final Map<String, int> lessonProgress;
  /// Leçons validées (quiz réussi).
  final Set<String> completedLessonIds;
  /// Scores des diagnostics passés (historique).
  final List<int> diagnosticHistory;
  /// Vies quiz restantes aujourd’hui (max 5, reset chaque jour).
  final int quizLivesRemaining;
  /// Jour calendaire des vies (`YYYY-MM-DD`).
  final String? quizLivesDay;

  bool get isOnboarded => diagnostic != null;
  bool get isSignedIn => authProvider != null;
  /// Invité local (Commencer) — pas encore de compte e-mail / social.
  bool get isGuest => authProvider == 'guest';
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
    if (lessonProgress.isNotEmpty)
      'lessonProgress': lessonProgress.map((k, v) => MapEntry(k, v)),
    if (completedLessonIds.isNotEmpty)
      'completedLessonIds': completedLessonIds.toList(),
    if (diagnosticHistory.isNotEmpty) 'diagnosticHistory': diagnosticHistory,
    'quizLivesRemaining': quizLivesRemaining,
    if (quizLivesDay != null) 'quizLivesDay': quizLivesDay,
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
      lessonProgress: () {
        final raw = json['lessonProgress'];
        if (raw is Map) {
          return raw.map(
            (k, v) => MapEntry(k.toString(), (v as num).toInt()),
          );
        }
        return <String, int>{};
      }(),
      completedLessonIds: () {
        final raw = json['completedLessonIds'];
        if (raw is List) {
          return raw.map((e) => e.toString()).toSet();
        }
        // Migration : 1ʳᵉ leçon déjà faite.
        if (json['hasCompletedFirstLesson'] == true) {
          return {'besoins_envies'};
        }
        return <String>{};
      }(),
      diagnosticHistory: () {
        final raw = json['diagnosticHistory'];
        if (raw is List) {
          return raw.map((e) => (e as num).toInt()).toList();
        }
        return <int>[];
      }(),
      quizLivesRemaining:
          json['quizLivesRemaining'] as int? ?? CourseProgress.dailyQuizLives,
      quizLivesDay: json['quizLivesDay'] as String?,
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
    Map<String, int>? lessonProgress,
    Set<String>? completedLessonIds,
    List<int>? diagnosticHistory,
    int? quizLivesRemaining,
    String? quizLivesDay,
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
      lessonProgress: lessonProgress ?? this.lessonProgress,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      diagnosticHistory: diagnosticHistory ?? this.diagnosticHistory,
      quizLivesRemaining: quizLivesRemaining ?? this.quizLivesRemaining,
      quizLivesDay: quizLivesDay ?? this.quizLivesDay,
    );
  }
}
