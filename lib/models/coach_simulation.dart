import 'package:flutter/material.dart';

/// Message affiché dans le fil du coach.
class CoachChatMessage {
  const CoachChatMessage({
    required this.text,
    this.fromCoach = true,
    this.outcome,
  });

  final String text;
  final bool fromCoach;
  final CoachSimOutcome? outcome;
}

/// Carte bilan en fin d’étape.
class CoachSimOutcome {
  const CoachSimOutcome({
    required this.title,
    required this.rows,
    required this.tip,
    this.positive = true,
  });

  final String title;
  final List<(String label, String value)> rows;
  final String tip;
  final bool positive;
}

/// Choix proposé à l’utilisateur.
class CoachSimChoice {
  const CoachSimChoice({
    required this.id,
    required this.label,
    required this.replies,
    this.nextStepId,
    this.outcome,
  });

  final String id;
  final String label;

  /// Réponses du coach après ce choix (une ou plusieurs bulles).
  final List<String> replies;
  final String? nextStepId;
  final CoachSimOutcome? outcome;
}

/// Étape d’un scénario.
class CoachSimStep {
  const CoachSimStep({
    required this.coachText,
    this.choices = const [],
    this.outcome,
  });

  final String coachText;
  final List<CoachSimChoice> choices;
  final CoachSimOutcome? outcome;
}

/// Scénario jouable depuis l’onglet Coach.
class CoachScenario {
  const CoachScenario({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.intro,
    required this.steps,
    required this.startStepId,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String intro;
  final Map<String, CoachSimStep> steps;
  final String startStepId;

  CoachSimStep get startStep => steps[startStepId]!;
}

/// Banque de simulations & réponses rapides (MVP — pas d’IA).
abstract final class CoachSimulationBank {
  static String formatFcfa(int amount) {
    final s = amount.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    final sign = amount < 0 ? '−' : '';
    return '$sign${buf.toString()} $_code';
  }

  static String _code = 'XOF';

  static List<CoachScenario> get scenarios => scenariosFor(_code);

  static List<CoachScenario> scenariosFor(String code) {
    _code = code;
    return [
    CoachScenario(
      id: 'journee_boutique',
      title: 'Ma journée en boutique',
      subtitle: 'Caisse · ventes · stock',
      icon: Icons.storefront_outlined,
      intro:
          'On simule une matinée de commerce. Tu décides, je te montre l’impact sur ta caisse.',
      startStepId: 'open',
      steps: {
        'open': CoachSimStep(
          coachText:
              '7 h : tu ouvres. Caisse de départ : ${formatFcfa(25000)}.\n'
              '9 h : vente cash ${formatFcfa(8500)}.\n'
              'Que fais-tu en premier ?',
          choices: [
            CoachSimChoice(
              id: 'register',
              label: 'J’enregistre la vente en caisse pro',
              replies: [
                'Parfait — ta caisse pro passe à ${formatFcfa(33500)}.',
                'Séparer perso et pro, c’est la base pour connaître ta marge.',
              ],
              nextStepId: 'stock',
            ),
            CoachSimChoice(
              id: 'pocket',
              label: 'Je mets l’argent dans ma poche perso',
              replies: [
                'Attention : ta caisse pro reste à ${formatFcfa(25000)} '
                'mais tu mélanges les flux.',
                'Résultat : tu ne sauras pas combien la boutique a vraiment gagné ce mois.',
              ],
              nextStepId: 'stock',
            ),
          ],
        ),
        'stock': CoachSimStep(
          coachText:
              '11 h : tu rachètes du stock pour ${formatFcfa(12000)} '
              '(sortie caisse pro).\n'
              '14 h : vente Wave ${formatFcfa(15000)} — frais ${formatFcfa(300)}.\n'
              'Comment tu gères la vente Wave ?',
          choices: [
            CoachSimChoice(
              id: 'wave_ok',
              label: 'Je note vente ${formatFcfa(15000)} − frais ${formatFcfa(300)}',
              replies: [
                'Bien vu. Net Wave : ${formatFcfa(14700)}.',
              ],
              nextStepId: 'close',
            ),
            CoachSimChoice(
              id: 'wave_gross',
              label: 'Je compte ${formatFcfa(15000)} sans les frais',
              replies: [
                'Tu te fais une illusion de ${formatFcfa(300)} sur la journée.',
                'Les frais Mobile Money, ça s’additionne vite sur un mois.',
              ],
              nextStepId: 'close',
            ),
          ],
        ),
        'close': CoachSimStep(
          coachText: '18 h : bilan de la journée simulée.',
          outcome: CoachSimOutcome(
            title: 'Bilan boutique',
            rows: [
              ('Entrées cash + Wave net', formatFcfa(23200)),
              ('Stock acheté', formatFcfa(-12000)),
              ('Variation caisse pro', formatFcfa(11200)),
            ],
            tip:
                'Refais cette simu en notant chaque mouvement dans un carnet ou Wave Business.',
            positive: true,
          ),
        ),
      },
    ),
    CoachScenario(
      id: 'budget_wave',
      title: 'Mon budget Wave',
      subtitle: 'Répartir 150 000 $_code',
      icon: Icons.account_balance_wallet_outlined,
      intro:
          'Tu viens de recevoir ${formatFcfa(150000)} sur Wave. On teste ta répartition du mois.',
      startStepId: 'income',
      steps: {
        'income': CoachSimStep(
          coachText:
              'Revenu du mois : ${formatFcfa(150000)}.\n'
              'Règle 50-30-20 adaptée : besoins · envies · épargne.\n'
              'Tu choisis quoi ?',
          choices: [
            CoachSimChoice(
              id: 'rule_503020',
              label: '50 % besoins · 30 % envies · 20 % épargne',
              replies: [
                'Besoins ${formatFcfa(75000)} · Envies ${formatFcfa(45000)} · '
                'Épargne ${formatFcfa(30000)}.',
                'C’est équilibré pour tenir le mois sans culpabiliser.',
              ],
              nextStepId: 'impulse',
            ),
            CoachSimChoice(
              id: 'all_needs',
              label: '100 % dans les dépenses du mois',
              replies: [
                'Tu vis au jour le jour — aucun matelas si imprévu.',
              ],
              nextStepId: 'impulse',
            ),
            CoachSimChoice(
              id: 'save_half',
              label: '50 % épargne · 50 % dépenses',
              replies: [
                'Très ambitieux ! Vérifie que tes besoins fixes passent vraiment.',
              ],
              nextStepId: 'impulse',
            ),
          ],
        ),
        'impulse': CoachSimStep(
          coachText:
              'Un ami te propose un groupage téléphone à ${formatFcfa(35000)} '
              '(envie, pas besoin).\n'
              'Tu as ${formatFcfa(45000)} prévus pour les envies. Tu fais quoi ?',
          choices: [
            CoachSimChoice(
              id: 'wait',
              label: 'J’attends le mois prochain',
              replies: [
                'Tu gardes ta marge de manœuvre — bon réflexe.',
              ],
              nextStepId: 'result',
            ),
            CoachSimChoice(
              id: 'buy_now',
              label: 'J’achète tout de suite',
              replies: [
                'Il te reste ${formatFcfa(10000)} d’envies pour 3 semaines… serré.',
              ],
              nextStepId: 'result',
            ),
            CoachSimChoice(
              id: 'borrow',
              label: 'Je emprunte ${formatFcfa(15000)} à un proche',
              replies: [
                'Dette informelle + envie = double pression le mois suivant.',
              ],
              nextStepId: 'result',
            ),
          ],
        ),
        'result': CoachSimStep(
          coachText: 'Fin du mois simulé — où en es-tu ?',
          outcome: CoachSimOutcome(
            title: 'Budget Wave',
            rows: [
              ('Revenu', formatFcfa(150000)),
              ('Besoins couverts', 'Oui (si 50 %)'),
              ('Épargne visée', formatFcfa(30000)),
              ('Risque impulsion', 'Variable'),
            ],
            tip:
                'Fixe ton virement épargne le jour de réception Wave — avant les envies.',
            positive: true,
          ),
        ),
      },
    ),
    CoachScenario(
      id: 'credit_client',
      title: 'Crédit client',
      subtitle: 'Accorder ou refuser ?',
      icon: Icons.handshake_outlined,
      intro:
          'Un client régulier demande ${formatFcfa(15000)} à crédit pour 2 semaines. Simulation.',
      startStepId: 'ask',
      steps: {
        'ask': CoachSimStep(
          coachText:
              'Contexte : il doit déjà ${formatFcfa(8000)} depuis 3 semaines.\n'
              'Marge du jour : ${formatFcfa(22000)}.\n'
              'Ta décision ?',
          choices: [
            CoachSimChoice(
              id: 'refuse',
              label: 'Je refuse poliment — d’abord l’ancienne dette',
              replies: [
                'Tu protèges ta trésorerie. Propose un paiement partiel immédiat.',
              ],
              nextStepId: 'follow',
            ),
            CoachSimChoice(
              id: 'accept',
              label: 'J’accorde ${formatFcfa(15000)} sans conditions',
              replies: [
                'Tu doubles l’exposition : ${formatFcfa(23000)} au total à recouvrer.',
                'Si impayé, ta marge du mois fond.',
              ],
              nextStepId: 'follow',
            ),
            CoachSimChoice(
              id: 'partial',
              label: 'Crédit ${formatFcfa(7000)} si paiement ${formatFcfa(8000)} aujourd’hui',
              replies: [
                'Compromis malin : tu limites le risque et tu récupères l’ancien dû.',
              ],
              nextStepId: 'follow',
            ),
          ],
        ),
        'follow': CoachSimStep(
          coachText: '2 semaines plus tard (simulation)…',
          outcome: CoachSimOutcome(
            title: 'Impact trésorerie',
            rows: [
              ('Dette totale (si tout accordé)', formatFcfa(23000)),
              ('Marge jour simulée', formatFcfa(22000)),
              ('Caisse sous tension', 'Oui'),
            ],
            tip:
                'Note chaque crédit client dans un registre avec date et montant dû.',
            positive: false,
          ),
        ),
      },
    ),
  ];
  }

  static CoachScenario? scenarioById(String id) {
    for (final s in scenarios) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Réponses rapides aux pills.
  static List<String> quickReplyFor(String question, [String? code]) {
    if (code != null) _code = code;
    return switch (question) {
      'Comment calculer ma marge ?' => [
        'Marge = Ventes − Coût des marchandises − Frais (transport, Wave…).',
        'Exemple simulé : ventes ${formatFcfa(85000)} − achats stock ${formatFcfa(52000)} '
        '− frais ${formatFcfa(4500)} = marge ${formatFcfa(28500)}.',
        'Lance la simu « Ma journée en boutique » pour t’entraîner pas à pas.',
      ],
      'Aide pour mon budget Wave' => [
        'Dès que ${formatFcfa(150000)} arrive, decoupe : 50 % besoins, 30 % envies, 20 % épargne.',
        'Envoie l’épargne sur un second compte ou vers Orange Money épargne — avant de dépenser.',
        'Simu « Mon budget Wave » : tu testes une vraie décision d’impulsion.',
      ],
      'Gérer un crédit client' => [
        'Règle d’or : jamais de nouveau crédit si l’ancien n’est pas clarifié.',
        'Fixe un plafond (ex. 10 % de ta marge hebdo) et une date de remboursement écrite.',
        'Simu « Crédit client » pour voir l’impact sur ta caisse.',
      ],
      _ => [
        'Bonne question ! Pour l’instant, choisis une simulation ci-dessus '
        'ou repasse par les leçons du sentier.',
      ],
    };
  }

  static CoachSimStep? step(String scenarioId, String stepId) {
    return scenarioById(scenarioId)?.steps[stepId];
  }

  static CoachSimChoice? findChoice(
    String scenarioId,
    String stepId,
    String choiceId,
  ) {
    final step = CoachSimulationBank.step(scenarioId, stepId);
    if (step == null) return null;
    for (final c in step.choices) {
      if (c.id == choiceId) return c;
    }
    return null;
  }
}
