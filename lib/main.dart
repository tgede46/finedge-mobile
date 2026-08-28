import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/session_controller.dart';
import 'controllers/session_store.dart';
import 'core/preferences/app_preferences.dart';

/// Démo téléphone (MVP) :
/// - Lancer en debug : `flutter run` (pas `--release`).
/// - Après edit de `main` / enums / MFA sim → Hot Restart (pas seulement reload).
/// - Guest film : clear data → Welcome → Commencer → onboarding → 1ʳᵉ leçon → prompt profil.
/// - Connecté : Continuer leçon → complete sans prompt / sans chrono RAPIDE.
/// - USB/Wi‑Fi debug stable ; MFA OTP : Hot Restart avant le flux.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = SessionController(store: SharedPreferencesSessionStore());
  await Future.wait([
    AppPreferences.load(),
    session.restore(),
  ]);
  runApp(FinEdgeApp(session: session));
}
