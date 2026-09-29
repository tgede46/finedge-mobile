import 'package:findge/models/diagnostic.dart';
import 'package:findge/models/learning_path.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('objectif budget → imprévus', () {
    final path = LearningPath.fromDiagnostic(
      const Diagnostic(
        goals: ['budget'],
        level: 'beginner',
        energy: 'calm',
        avatar: 'stratege',
      ),
    );
    expect(path.activeLesson.id, 'emergency');
  });

  test('objectif épargne → imprévus', () {
    final path = LearningPath.fromDiagnostic(
      const Diagnostic(
        goals: ['save_project'],
        level: 'curious',
        energy: 'recommended',
        avatar: 'stratege',
      ),
    );
    expect(path.activeLesson.id, 'emergency');
  });

  test('objectif investissement → mobile money', () {
    final path = LearningPath.fromDiagnostic(
      const Diagnostic(
        goals: ['invest'],
        level: 'economist',
        energy: 'intense',
        avatar: 'patient',
      ),
    );
    expect(path.activeLesson.id, 'mobile_money');
  });
}
