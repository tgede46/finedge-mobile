import 'package:flutter/foundation.dart';

import '../models/diagnostic.dart';
import '../models/guest_session.dart';
import '../models/learning_path.dart';
import 'session_store.dart';

/// Contrôleur MVC de session invité + diagnostic.
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
  LearningPath get path => _session.path;

  Future<void> restore() async {
    final loaded = await _store.load();
    if (loaded != null) {
      _session = loaded;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding(Diagnostic diagnostic) async {
    _session = _session.copyWith(diagnostic: diagnostic);
    await _store.save(_session);
    notifyListeners();
  }
}
