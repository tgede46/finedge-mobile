/// Progression sentier & déblocages.
abstract final class CourseProgress {
  /// Unité 1 · leçon 2 — débloque l’unité 2.
  static const unit2UnlockLessonId = 'tri_depenses';

  /// Unité 1 · leçon 3 — débloque le diagnostic (1 · 2 · 3).
  static const diagnosticUnlockLessonId = 'epargne_urgence';

  static const quizDurationMinutes = 5;
  static const quizQuestionCount = 10;
  static const dailyQuizLives = 5;

  static const unit1LessonOrder = [
    'besoins_envies',
    'tri_depenses',
    'epargne_urgence',
    'budget_simple',
    'regle_503020',
    'objectif_epargne',
  ];

  static const unit2LessonOrder = [
    'caisse_jour',
    'entrees_sorties',
    'marge_benefice',
    'credit_client',
    'stock_minimum',
    'separer_caisse',
  ];

  static bool canRetakeDiagnostic(Set<String> completed) =>
      completed.contains(diagnosticUnlockLessonId);

  static String? nextLessonId(Set<String> completed) {
    for (final id in [...unit1LessonOrder, ...unit2LessonOrder]) {
      if (!completed.contains(id)) return id;
    }
    return null;
  }

  static bool isUnit2Unlocked(Set<String> completed) =>
      completed.contains(unit2UnlockLessonId);
}
