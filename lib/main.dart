import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/session_controller.dart';
import 'controllers/session_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = SessionController(store: SharedPreferencesSessionStore());
  await session.restore();
  runApp(FinEdgeApp(session: session));
}
