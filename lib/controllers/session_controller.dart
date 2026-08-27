import 'package:flutter/foundation.dart';

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
  LearningPath get path => _session.path;
  MfaMethod get mfaMethod => _session.mfaMethod;

  Future<void> restore() async {
    final loaded = await _store.load();
    if (loaded != null) {
      _session = loaded;
      notifyListeners();
    }
  }

  Future<void> completeIntro() async {
    _session = _session.copyWith(hasSeenIntro: true);
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> signIn({required String provider}) async {
    _session = _session.copyWith(hasSeenIntro: true, authProvider: provider);
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
}
