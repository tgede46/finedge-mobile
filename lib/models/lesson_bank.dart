import 'lesson_step.dart';

/// Contenu des leçons — lecture seule ; le quiz de fin teste les acquis.
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
          'est la première étape pour maîtriser ton budget.',
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
    LessonStep.read(
      id: 'example_loyer',
      title: 'Exemple concret',
      mascotLine: 'Le loyer du mois, c’est un besoin, pas une envie.',
      body:
          'Chaque mois, le loyer doit être payé en priorité. '
          'C’est indispensable pour avoir un toit.\n\n'
          'Un nouveau téléphone alors que l’ancien fonctionne encore ? '
          'C’est une envie. Elle peut attendre.',
    ),
    LessonStep.read(
      id: 'phrase_cle',
      title: 'La phrase à retenir',
      mascotLine: 'Avant chaque dépense, pose-toi cette question.',
      body:
          '« Est-ce un besoin ou une envie ? »\n\n'
          'Un **besoin** est indispensable pour vivre ou travailler.\n'
          'Une **envie** est un plus, agréable, mais pas urgent.',
    ),
    LessonStep.read(
      id: 'marche',
      title: 'Au marché',
      mascotLine: 'Imaginons : tu as 5 000 FCFA en poche.',
      body:
          'Le riz manque à la maison ? Achète le riz d’abord, c’est un besoin.\n\n'
          'Les accessoires mode ou un jeu en ligne peuvent attendre.',
    ),
    LessonStep.read(
      id: 'recap',
      title: 'À retenir',
      mascotLine: 'Tu as fini la leçon. Passons au quiz !',
      body:
          'Avant une dépense, demande-toi si c’est un **besoin** ou une **envie**.\n\n'
          'Au quiz, tu t’entraîneras sur des cas concrets pour valider la leçon.',
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
    LessonStep.read(
      id: 'definition',
      title: 'C’est quoi un budget ?',
      mascotLine: 'Ce n’est ni une punition, ni un compte secret.',
      body:
          'Un budget, c’est un **plan pour tes dépenses** : '
          'tu sais combien entre, combien sort, et ce qu’il te reste.\n\n'
          'Sans plan, l’argent part souvent sans qu’on s’en rende compte.',
    ),
    LessonStep.read(
      id: 'formule',
      title: 'La formule de base',
      mascotLine: 'Retiens cette équation simple.',
      body:
          '**Entrées − sorties = reste disponible**\n\n'
          'Les entrées : salaire, aide, petits revenus.\n'
          'Les sorties : loyer, transport, nourriture, factures.',
    ),
    LessonStep.read(
      id: 'recap',
      title: 'À retenir',
      mascotLine: 'Tu es prêt pour le quiz !',
      body:
          'Note tes dépenses, calcule ce qu’il te reste, '
          'et ajuste avant de dépenser.\n\n'
          'Le quiz te permettra de vérifier que tu as bien compris.',
    ),
  ];

  static List<LessonStep> _generic(String lessonId) {
    return [
      LessonStep.read(
        id: 'intro',
        title: 'Leçon',
        mascotLine: 'C’est parti pour cette leçon !',
        body:
            'Contenu à venir pour « $lessonId ». '
            'Lis ce résumé puis passe au quiz de fin pour valider la leçon.',
      ),
    ];
  }
}
