import 'package:flutter/foundation.dart';

import '../models/app_currency.dart';
import '../models/course_progress.dart';
import '../models/diagnostic.dart';
import '../models/guest_session.dart';
import '../models/learning_path.dart';
import '../models/mfa_method.dart';
import 'session_store.dart';

class SessionController extends ChangeNotifier {
  SessionController({SessionStore? store, GuestSession? initial})
    : _store = store ?? MemorySessionStore(),
      _session =
          initial ??
          GuestSession(
            localId: 'guest_${DateTime.now().microsecondsSinceEpoch}',
          );

  final SessionStore _store;
  GuestSession _session;

  GuestSession get session => _session;
  bool get isOnboarded => _session.isOnboarded;
  bool get hasSeenIntro => _session.hasSeenIntro;
  bool get isSignedIn => _session.isSignedIn;
  bool get isGuest => _session.isGuest;
  LearningPath get path => _session.path;
  AppCurrency get currency =>
      AppCurrency.byId(_session.diagnostic?.currency);
  MfaMethod get mfaMethod => _session.mfaMethod;
  int get quizLives => _session.quizLivesRemaining;

  static String _todayKey([DateTime? date]) {
    final d = date ?? DateTime.now();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  Future<void> ensureQuizLivesReset() async {
    final today = _todayKey();
    if (_session.quizLivesDay == today) return;
    _session = _session.copyWith(
      quizLivesDay: today,
      quizLivesRemaining: CourseProgress.dailyQuizLives,
    );
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> loseQuizLife() async {
    await ensureQuizLivesReset();
    if (_session.quizLivesRemaining <= 0) return;
    _session = _session.copyWith(
      quizLivesRemaining: _session.quizLivesRemaining - 1,
    );
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> restore() async {
    final loaded = await _store.load();
    if (loaded != null) {
      _session = loaded;
      await ensureQuizLivesReset();
      notifyListeners();
    }
  }

  Future<void> completeIntro() async {
    _session = _session.copyWith(hasSeenIntro: true);
    await _store.save(_session);
    notifyListeners();
  }

  /// Upgrade / connexion — conserve XP, diagnostic, 1ʳᵉ leçon, etc.
  Future<void> signIn({required String provider, String? email}) async {
    _session = _session.copyWith(
      hasSeenIntro: true,
      authProvider: provider,
      email: email,
    );
    await _store.save(_session);
    notifyListeners();
  }

  /// Déconnexion — repasse en guest, conserve XP / leçons / diagnostic.
  Future<void> signOut() async {
    _session = _session.copyWith(
      authProvider: 'guest',
      email: null,
      mfaMethod: MfaMethod.none,
    );
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> completeOnboarding(
    Diagnostic diagnostic, {
    String? email,
    String? authProvider,
  }) async {
    _session = _session.copyWith(
      diagnostic: diagnostic,
      hasSeenIntro: true,
      email: email,
      authProvider: authProvider ?? _session.authProvider ?? 'guest',
    );
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> setMfaMethod(MfaMethod method) async {
    _session = _session.copyWith(mfaMethod: method);
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> completeFirstLesson({
    required int xpEarned,
    required int streakGoalDays,
  }) async {
    _session = _session.copyWith(
      hasCompletedFirstLesson: true,
      xp: _session.xp + xpEarned,
      streakDays: _session.streakDays <= 0 ? 1 : _session.streakDays,
      streakGoalDays: streakGoalDays,
    );
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> setStreakGoal(int streakGoalDays) async {
    _session = _session.copyWith(streakGoalDays: streakGoalDays);
    await _store.save(_session);
    notifyListeners();
  }

  /// Nouvelle série après objectif atteint (+ réponses approfondies).
  Future<void> renewStreakGoal({
    required Map<String, String> deepenAnswers,
    required int nextGoalDays,
  }) async {
    final reward = switch (_session.streakGoalDays) {
      7 => 70,
      30 => 300,
      50 => 500,
      _ => 50,
    };
    _session = _session.copyWith(
      deepenAnswers: {..._session.deepenAnswers, ...deepenAnswers},
      streakGoalDays: nextGoalDays,
      streakDays: 0,
      xp: _session.xp + reward,
    );
    await _store.save(_session);
    notifyListeners();
  }

  /// Simule / enregistre une progression de série (leçons quotidiennes).
  Future<void> registerPracticeDay() async {
    final next = _session.streakDays + 1;
    _session = _session.copyWith(streakDays: next);
    await _store.save(_session);
    notifyListeners();
  }

  int lessonStepIndex(String lessonId) =>
      _session.lessonProgress[lessonId] ?? 0;

  bool hasLessonInProgress(String lessonId) =>
      (_session.lessonProgress[lessonId] ?? 0) > 0;

  String? get activeLessonId {
    if (_session.lessonProgress.isEmpty) return null;
    for (final entry in _session.lessonProgress.entries) {
      if (entry.value > 0) return entry.key;
    }
    return null;
  }

  Future<void> saveLessonStep(String lessonId, int stepIndex) async {
    final next = Map<String, int>.from(_session.lessonProgress);
    if (stepIndex <= 0) {
      next.remove(lessonId);
    } else {
      next[lessonId] = stepIndex;
    }
    _session = _session.copyWith(lessonProgress: next);
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> clearLessonProgress(String lessonId) async {
    if (!_session.lessonProgress.containsKey(lessonId)) return;
    final next = Map<String, int>.from(_session.lessonProgress)..remove(lessonId);
    _session = _session.copyWith(lessonProgress: next);
    await _store.save(_session);
    notifyListeners();
  }

  Set<String> get completedLessonIds => _session.completedLessonIds;

  bool get canRetakeDiagnostic =>
      CourseProgress.canRetakeDiagnostic(_session.completedLessonIds);

  Future<void> completeLesson(String lessonId, {required int xpEarned}) async {
    final completed = {..._session.completedLessonIds, lessonId};
    _session = _session.copyWith(
      completedLessonIds: completed,
      xp: _session.xp + xpEarned,
      lessonProgress: Map<String, int>.from(_session.lessonProgress)
        ..remove(lessonId),
    );
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> retakeDiagnostic(Diagnostic diagnostic) async {
    final score = _diagnosticScore(diagnostic);
    _session = _session.copyWith(
      diagnostic: diagnostic,
      diagnosticHistory: [..._session.diagnosticHistory, score],
    );
    await _store.save(_session);
    notifyListeners();
  }

  static int _diagnosticScore(Diagnostic d) {
    var score = 55;
    score += (d.goals.length * 6).clamp(0, 24);
    score += switch (d.level) {
      'economist' => 18,
      'solid' => 14,
      'daily' => 10,
      'basics' => 6,
      _ => 2,
    };
    return score.clamp(40, 95);
  }
}
