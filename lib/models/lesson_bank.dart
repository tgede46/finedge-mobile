import 'lesson_step.dart';

/// Contenu des leçons — à enrichir quand tu envoies tes textes.
abstract final class LessonBank {
  static List<LessonStep> stepsFor(String lessonId) {
    return switch (lessonId) {
      'besoins_envies' => _besoinsEnvies,
      'budget_simple' => _budgetSimple,
      _ => _generic(lessonId),
    };
  }

  static const _besoinsEnvies = [
    LessonStep.read(
      id: 'intro',
      title: 'Besoins vs Envies',
      mascotLine: 'Salut ! Aujourd’hui on apprend à trier ton argent du marché.',
      body:
          'Savoir faire la différence entre un **besoin** et une **envie** '
          'est la première étape pour maîtriser ton budget en FCFA.',
    ),
    LessonStep.read(
      id: 'explain',
      title: 'La règle simple',
      mascotLine: 'Un besoin, c’est indispensable. Une envie, c’est un plus.',
      body:
          '**Besoin** : nourriture, transport pour le travail, loyer.\n\n'
          '**Envie** : nouveau téléphone, snack extra, sortie impulsive.\n\n'
          'Au marché, pose-toi : « Est-ce que je peux m’en passer ce mois ? »',
    ),
    LessonStep.mcq(
      id: 'q1',
      prompt: 'Le loyer du mois, c’est plutôt…',
      options: ['Un besoin', 'Une envie', 'Un luxe'],
      correctIndex: 0,
    ),
    LessonStep.fillBlank(
      id: 'q2',
      prompt: 'Complète la phrase :',
      segments: ['Un ', '', ' est indispensable pour vivre ou travailler.'],
      wordBank: ['besoin', 'envie', 'cadeau', 'besoin'],
      correctWords: ['besoin'],
    ),
    LessonStep.mcq(
      id: 'q3',
      prompt: 'Tu as 5 000 FCFA. Le riz manque à la maison. Tu achètes…',
      options: ['Le riz d’abord', 'Des accessoires mode', 'Un jeu en ligne'],
      correctIndex: 0,
    ),
    LessonStep.fillBlank(
      id: 'q4',
      prompt: 'Complète :',
      segments: [
        'Avant une dépense, demande-toi si c’est un ',
        '',
        ' ou une ',
        '',
        '.',
      ],
      wordBank: ['besoin', 'envie', 'besoin', 'envie'],
      correctWords: ['besoin', 'envie'],
    ),
  ];

  static const _budgetSimple = [
    LessonStep.read(
      id: 'intro',
      title: 'Budget simple',
      mascotLine: 'On va répartir ton argent du mois en trois poches.',
      body:
          'Entrées − sorties = ce qu’il te reste.\n\n'
          'Note tes dépenses fixes (loyer, transport) puis le reste pour la semaine.',
    ),
    LessonStep.mcq(
      id: 'q1',
      prompt: 'Le budget, c’est surtout…',
      options: [
        'Un plan pour tes dépenses',
        'Une punition',
        'Un compte bancaire secret',
      ],
      correctIndex: 0,
    ),
    LessonStep.fillBlank(
      id: 'q2',
      prompt: 'Complète :',
      segments: ['Entrées − ', '', ' = reste disponible'],
      wordBank: ['sorties', 'envies', 'sorties'],
      correctWords: ['sorties'],
    ),
  ];

  static List<LessonStep> _generic(String lessonId) {
    return [
      LessonStep.read(
        id: 'intro',
        title: 'Leçon',
        mascotLine: 'C’est parti pour cette leçon !',
        body: 'Contenu à venir pour « $lessonId ». Envoie-nous ton texte pour qu’on le branche ici.',
      ),
      LessonStep.mcq(
        id: 'q1',
        prompt: 'Prêt à continuer ton sentier ?',
        options: ['Oui', 'Bien sûr', 'C’est parti'],
        correctIndex: 0,
      ),
    ];
  }
}
