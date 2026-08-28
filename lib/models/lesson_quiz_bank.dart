import 'course_progress.dart';
import 'lesson_quiz_question.dart';

/// Quiz de fin de leçon (10 questions · 5 min).
abstract final class LessonQuizBank {
  static List<LessonQuizQuestion> questionsFor(String lessonId) {
    final base = switch (lessonId) {
      'besoins_envies' => List<LessonQuizQuestion>.from(_besoinsEnvies),
      'tri_depenses' => List<LessonQuizQuestion>.from(_triDepenses),
      'budget_simple' => List<LessonQuizQuestion>.from(_budgetSimple),
      _ => _generic(lessonId),
    };
    while (base.length < CourseProgress.quizQuestionCount) {
      base.addAll(_generic('${lessonId}_extra'));
    }
    return base.take(CourseProgress.quizQuestionCount).toList();
  }

  static const _besoinsEnvies = [
    LessonQuizQuestion(
      id: 'be1',
      prompt: 'Un besoin, c’est…',
      options: [
        'Indispensable au quotidien',
        'Un achat plaisir',
        'Un cadeau surprise',
      ],
      correctIndex: 0,
      explanation:
          'Un besoin couvre l’essentiel : logement, nourriture, transport utile.',
    ),
    LessonQuizQuestion(
      id: 'be2',
      prompt: 'Le loyer du mois est plutôt…',
      options: ['Un besoin', 'Une envie', 'Un luxe'],
      correctIndex: 0,
      explanation: 'Le loyer est une dépense fixe indispensable.',
    ),
    LessonQuizQuestion(
      id: 'be3',
      prompt: 'Un nouveau téléphone sans urgence, c’est…',
      options: ['Une envie', 'Un besoin', 'Une taxe'],
      correctIndex: 0,
      explanation: 'Tu peux reporter une envie ; un besoin, non.',
    ),
    LessonQuizQuestion(
      id: 'be4',
      prompt: 'Avant d’acheter au marché, tu dois te demander…',
      options: [
        'Est-ce un besoin ou une envie ?',
        'Quelle est la mode ?',
        'Qui paie pour moi ?',
      ],
      correctIndex: 0,
      explanation: 'Cette question t’aide à protéger ton budget FCFA.',
    ),
    LessonQuizQuestion(
      id: 'be5',
      prompt: 'Il reste 5 000 FCFA et plus de riz à la maison. Tu achètes…',
      options: ['Le riz d’abord', 'Des accessoires', 'Un jeu en ligne'],
      correctIndex: 0,
      explanation: 'Priorise les besoins avant les envies.',
    ),
    LessonQuizQuestion(
      id: 'be6',
      prompt: 'Le transport pour aller au travail, c’est…',
      options: ['Un besoin', 'Une envie', 'Un hobby'],
      correctIndex: 0,
      explanation: 'Ce qui te permet de gagner de l’argent est souvent un besoin.',
    ),
    LessonQuizQuestion(
      id: 'be7',
      prompt: 'Une sortie restaurant alors que le budget est serré…',
      options: [
        'Peut être une envie à reporter',
        'Est toujours un besoin',
        'Ne compte pas',
      ],
      correctIndex: 0,
      explanation: 'Tu peux la planifier quand le budget le permet.',
    ),
    LessonQuizQuestion(
      id: 'be8',
      prompt: 'Trier besoins et envies sert surtout à…',
      options: [
        'Mieux utiliser ton argent',
        'Gagner à la loterie',
        'Éviter d’avoir un compte',
      ],
      correctIndex: 0,
      explanation: 'C’est la base d’un budget qui tient.',
    ),
    LessonQuizQuestion(
      id: 'be9',
      prompt: 'Les médicaments prescrits sont…',
      options: ['Des besoins', 'Des envies', 'Des dettes'],
      correctIndex: 0,
      explanation: 'La santé fait partie des priorités.',
    ),
    LessonQuizQuestion(
      id: 'be10',
      prompt: 'La règle d’or au marché :',
      options: [
        'Besoins d’abord, envies ensuite',
        'Tout acheter vite',
        'Ne rien noter',
      ],
      correctIndex: 0,
      explanation: 'C’est le réflexe FinEdge pour la 1ʳᵉ leçon.',
    ),
  ];

  static const _triDepenses = [
    LessonQuizQuestion(
      id: 'td1',
      prompt: 'Une dépense fixe, c’est…',
      options: ['Qui revient chaque mois', 'Qui change tout le temps', 'Un cadeau'],
      correctIndex: 0,
      explanation: 'Ex. : loyer, abonnement, transport régulier.',
    ),
    LessonQuizQuestion(
      id: 'td2',
      prompt: 'Le loyer est une dépense…',
      options: ['Fixe', 'Variable', 'Imprévue'],
      correctIndex: 0,
      explanation: 'Montant connu chaque mois.',
    ),
    LessonQuizQuestion(
      id: 'td3',
      prompt: 'Les courses du marché sont plutôt…',
      options: ['Variables', 'Fixes', 'Gratuites'],
      correctIndex: 0,
      explanation: 'Le montant change selon la semaine.',
    ),
    LessonQuizQuestion(
      id: 'td4',
      prompt: 'Une réparation imprévue est…',
      options: ['Imprévue', 'Fixe', 'Toujours une envie'],
      correctIndex: 0,
      explanation: 'Prévois une petite réserve pour ce type de dépense.',
    ),
    LessonQuizQuestion(
      id: 'td5',
      prompt: 'Trier ses dépenses aide à…',
      options: ['Voir où part l’argent', 'Dépenser plus', 'Oublier le budget'],
      correctIndex: 0,
      explanation: 'Tu identifies ce qui est compressible.',
    ),
    LessonQuizQuestion(
      id: 'td6',
      prompt: 'Le salaire mensuel est une…',
      options: ['Entrée', 'Sortie', 'Envie'],
      correctIndex: 0,
      explanation: 'L’argent qui entre alimente ton budget.',
    ),
    LessonQuizQuestion(
      id: 'td7',
      prompt: 'Noter ses dépenses pendant 1 semaine…',
      options: [
        'Donne une photo réaliste',
        'Ne sert à rien',
        'Augmente les dettes',
      ],
      correctIndex: 0,
      explanation: 'Tu vois les fuites avant de corriger.',
    ),
    LessonQuizQuestion(
      id: 'td8',
      prompt: 'Une dépense variable peut être…',
      options: ['Réduite plus facilement', 'Jamais touchée', 'Toujours fixe'],
      correctIndex: 0,
      explanation: 'C’est souvent là qu’on optimise en premier.',
    ),
    LessonQuizQuestion(
      id: 'td9',
      prompt: '3 catégories utiles : fixe, variable et…',
      options: ['Imprévue', 'Secrète', 'Interdite'],
      correctIndex: 0,
      explanation: 'Les imprévus existent — il faut les anticiper.',
    ),
    LessonQuizQuestion(
      id: 'td10',
      prompt: 'Après le tri, la prochaine étape logique est…',
      options: ['Fixer un budget', 'Tout dépenser', 'Fermer son compte'],
      correctIndex: 0,
      explanation: 'Tu passes de l’observation à l’action.',
    ),
  ];

  static const _budgetSimple = [
    LessonQuizQuestion(
      id: 'bs1',
      prompt: 'Un budget, c’est…',
      options: ['Un plan', 'Une punition', 'Un prêt'],
      correctIndex: 0,
      explanation: 'Tu décides à l’avance où va ton argent.',
    ),
    LessonQuizQuestion(
      id: 'bs2',
      prompt: 'Entrées − sorties = …',
      options: ['Reste disponible', 'Dette obligatoire', 'Impôt'],
      correctIndex: 0,
      explanation: 'Formule de base du budget.',
    ),
    LessonQuizQuestion(
      id: 'bs3',
      prompt: 'Le budget se fait plutôt…',
      options: ['Par mois', 'Une fois par an', 'Jamais'],
      correctIndex: 0,
      explanation: 'Un mois = cycle naturel pour la plupart des revenus.',
    ),
    LessonQuizQuestion(
      id: 'bs4',
      prompt: 'Si le reste est négatif, tu dois…',
      options: ['Réduire des sorties', 'Ignorer', 'Dépenser plus'],
      correctIndex: 0,
      explanation: 'Sinon tu creuses un trou.',
    ),
    LessonQuizQuestion(
      id: 'bs5',
      prompt: 'Les dépenses fixes se paient…',
      options: ['En priorité', 'En dernier', 'Au hasard'],
      correctIndex: 0,
      explanation: 'Loyer et factures avant le reste.',
    ),
    LessonQuizQuestion(
      id: 'bs6',
      prompt: 'Épargner 10 % dès réception du salaire…',
      options: ['Facilite l’épargne', 'Est impossible', 'Est interdit'],
      correctIndex: 0,
      explanation: 'Payer-toi en premier.',
    ),
    LessonQuizQuestion(
      id: 'bs7',
      prompt: 'Un budget réaliste inclut…',
      options: ['Un peu de marge', 'Zéro imprévu', 'Que des envies'],
      correctIndex: 0,
      explanation: 'La vie réserve des surprises.',
    ),
    LessonQuizQuestion(
      id: 'bs8',
      prompt: 'Revoir son budget chaque semaine…',
      options: ['Garde le cap', 'Sert à rien', 'Crée des dettes'],
      correctIndex: 0,
      explanation: 'Petits ajustements = gros progrès.',
    ),
    LessonQuizQuestion(
      id: 'bs9',
      prompt: 'Le budget en FCFA doit être…',
      options: ['Écrit ou noté', 'Mental seulement', 'Secret'],
      correctIndex: 0,
      explanation: 'Ce qui est écrit est plus facile à suivre.',
    ),
    LessonQuizQuestion(
      id: 'bs10',
      prompt: 'Objectif du budget simple :',
      options: [
        'Ne plus subir son argent',
        'Tout dépenser vite',
        'Éviter les comptes',
      ],
      correctIndex: 0,
      explanation: 'Tu reprends le contrôle.',
    ),
  ];

  static List<LessonQuizQuestion> _generic(String lessonId) {
    return List.generate(
      10,
      (i) => LessonQuizQuestion(
        id: '${lessonId}_q$i',
        prompt: 'Question ${i + 1} — valide ta compréhension de la leçon.',
        options: ['Réponse A (correcte)', 'Réponse B', 'Réponse C'],
        correctIndex: 0,
        explanation: 'Revois la leçon si besoin — la bonne réponse est A.',
      ),
    );
  }
}
