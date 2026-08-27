import 'package:findge/controllers/session_controller.dart';
import 'package:findge/controllers/session_store.dart';
import 'package:findge/models/diagnostic.dart';

Future<SessionController> onboardedSession({
  List<String> goals = const ['budget'],
  String level = 'curious',
  String energy = 'recommended',
  String avatar = 'explorateur',
  String displayName = 'Awa',
  String age = '18_25',
}) async {
  final session = SessionController(store: MemorySessionStore());
  await session.completeOnboarding(
    Diagnostic(
      goals: goals,
      level: level,
      energy: energy,
      avatar: avatar,
      displayName: displayName,
      age: age,
    ),
  );
  return session;
}
