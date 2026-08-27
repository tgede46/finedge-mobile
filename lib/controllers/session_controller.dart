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

  Future<void> completeOnboarding(Diagnostic diagnostic) async {
    _session = _session.copyWith(
      diagnostic: diagnostic,
      hasSeenIntro: true,
      authProvider: _session.authProvider ?? 'guest',
    );
    await _store.save(_session);
    notifyListeners();
  }

  Future<void> setMfaMethod(MfaMethod method) async {
    _session = _session.copyWith(mfaMethod: method);
    await _store.save(_session);
    notifyListeners();
  }
}
