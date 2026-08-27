import 'package:findge/models/diagnostic.dart';
import 'package:findge/models/learning_path.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('commerçant → premier nœud caisse', () {
    final path = LearningPath.fromDiagnostic(
      const Diagnostic(
        activity: ActivityProfile.pagneSeller,
        goal: FinancialGoal.emergencySave,
        pace: DailyPace.calm,
      ),
    );
    expect(path.activeLesson.id, 'cashbox');
    expect(path.activeLesson.label, 'Ma caisse du jour');
  });

  test('salarié + épargne → coffre des imprévus', () {
    final path = LearningPath.fromDiagnostic(
      const Diagnostic(
        activity: ActivityProfile.employee,
        goal: FinancialGoal.emergencySave,
        pace: DailyPace.recommended,
      ),
    );
    expect(path.activeLesson.id, 'emergency');
  });

  test('étudiant + mobile money → frais MM', () {
    final path = LearningPath.fromDiagnostic(
      const Diagnostic(
        activity: ActivityProfile.student,
        goal: FinancialGoal.mobileMoney,
        pace: DailyPace.intense,
      ),
    );
    expect(path.activeLesson.id, 'mobile_money');
  });
}
