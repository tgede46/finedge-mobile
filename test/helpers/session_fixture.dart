import 'package:findge/controllers/session_controller.dart';
import 'package:findge/controllers/session_store.dart';
import 'package:findge/models/diagnostic.dart';

Future<SessionController> onboardedSession({
  ActivityProfile activity = ActivityProfile.merchant,
  FinancialGoal goal = FinancialGoal.cashbox,
  DailyPace pace = DailyPace.recommended,
}) async {
  final session = SessionController(store: MemorySessionStore());
  await session.completeOnboarding(
    Diagnostic(activity: activity, goal: goal, pace: pace),
  );
  return session;
}
