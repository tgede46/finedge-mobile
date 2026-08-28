import 'package:flutter/material.dart';

import 'course_progress.dart';

enum LessonNodeKind { lesson, trophy, chest }

enum LessonNodeStatus { completed, active, locked }

class LessonNode {
  const LessonNode({
    required this.id,
    required this.title,
    required this.icon,
    required this.status,
    this.kind = LessonNodeKind.lesson,
    this.alignment = 0,
  });

  final String id;
  final String title;
  final IconData icon;
  final LessonNodeStatus status;
  final LessonNodeKind kind;

  /// -1 gauche · 0 centre · 1 droite
  final int alignment;
}

class CourseUnit {
  const CourseUnit({
    required this.id,
    required this.index,
    required this.title,
    required this.icon,
    required this.nodes,
  });

  final String id;
  final int index;
  final String title;
  final IconData icon;
  final List<LessonNode> nodes;
}

class _PathNodeSpec {
  const _PathNodeSpec({
    required this.id,
    required this.title,
    required this.icon,
    required this.kind,
    required this.alignment,
  });

  final String id;
  final String title;
  final IconData icon;
  final LessonNodeKind kind;
  final int alignment;
}

/// Curriculum Leçons — sentier avec plusieurs leçons par unité.
abstract final class CourseCurriculum {
  static const _nodeSpacing = 124.0;
  static const _pathTopPad = 24.0;

  static double pathHeightFor(int nodeCount) =>
      _pathTopPad * 2 + nodeCount * _nodeSpacing;

  static List<CourseUnit> units({required Set<String> completed}) {
    final unit2Unlocked = CourseProgress.isUnit2Unlocked(completed);

    return [
      CourseUnit(
        id: 'unit_epargne',
        index: 1,
        title: 'Les Bases de l’Épargne',
        icon: Icons.savings_outlined,
        nodes: _buildNodes(
          completed: completed,
          specs: const [
            _PathNodeSpec(
              id: 'besoins_envies',
              title: 'Besoins vs Envies',
              icon: Icons.shopping_cart_outlined,
              kind: LessonNodeKind.lesson,
              alignment: 0,
            ),
            _PathNodeSpec(
              id: 'tri_depenses',
              title: 'Tri des dépenses',
              icon: Icons.filter_list_rounded,
              kind: LessonNodeKind.lesson,
              alignment: 1,
            ),
            _PathNodeSpec(
              id: 'epargne_urgence',
              title: 'Épargne d’urgence',
              icon: Icons.health_and_safety_outlined,
              kind: LessonNodeKind.lesson,
              alignment: -1,
            ),
            _PathNodeSpec(
              id: 'trophy_u1',
              title: 'Défi unité',
              icon: Icons.emoji_events_rounded,
              kind: LessonNodeKind.trophy,
              alignment: 0,
            ),
            _PathNodeSpec(
              id: 'budget_simple',
              title: 'Budget simple',
              icon: Icons.account_balance_wallet_outlined,
              kind: LessonNodeKind.lesson,
              alignment: 1,
            ),
            _PathNodeSpec(
              id: 'regle_503020',
              title: 'Règle 50-30-20',
              icon: Icons.pie_chart_outline_rounded,
              kind: LessonNodeKind.lesson,
              alignment: -1,
            ),
            _PathNodeSpec(
              id: 'objectif_epargne',
              title: 'Objectif d’épargne',
              icon: Icons.flag_outlined,
              kind: LessonNodeKind.lesson,
              alignment: 0,
            ),
            _PathNodeSpec(
              id: 'chest_u1',
              title: 'Coffre bonus',
              icon: Icons.redeem_rounded,
              kind: LessonNodeKind.chest,
              alignment: 1,
            ),
          ],
        ),
      ),
      CourseUnit(
        id: 'unit_commerce',
        index: 2,
        title: 'Gérer son petit commerce',
        icon: Icons.storefront_outlined,
        nodes: _buildNodes(
          completed: completed,
          unitLocked: !unit2Unlocked,
          specs: const [
            _PathNodeSpec(
              id: 'caisse_jour',
              title: 'Ma caisse du jour',
              icon: Icons.point_of_sale_outlined,
              kind: LessonNodeKind.lesson,
              alignment: -1,
            ),
            _PathNodeSpec(
              id: 'entrees_sorties',
              title: 'Entrées & sorties',
              icon: Icons.swap_vert_rounded,
              kind: LessonNodeKind.lesson,
              alignment: 1,
            ),
            _PathNodeSpec(
              id: 'marge_benefice',
              title: 'Marge & bénéfice',
              icon: Icons.trending_up_rounded,
              kind: LessonNodeKind.lesson,
              alignment: 0,
            ),
            _PathNodeSpec(
              id: 'trophy_u2',
              title: 'Défi commerce',
              icon: Icons.emoji_events_rounded,
              kind: LessonNodeKind.trophy,
              alignment: -1,
            ),
            _PathNodeSpec(
              id: 'credit_client',
              title: 'Crédit client',
              icon: Icons.handshake_outlined,
              kind: LessonNodeKind.lesson,
              alignment: 1,
            ),
            _PathNodeSpec(
              id: 'stock_minimum',
              title: 'Stock minimum',
              icon: Icons.inventory_2_outlined,
              kind: LessonNodeKind.lesson,
              alignment: 0,
            ),
            _PathNodeSpec(
              id: 'separer_caisse',
              title: 'Caisse & perso',
              icon: Icons.account_balance_outlined,
              kind: LessonNodeKind.lesson,
              alignment: -1,
            ),
          ],
        ),
      ),
    ];
  }

  static List<LessonNode> _buildNodes({
    required Set<String> completed,
    required List<_PathNodeSpec> specs,
    bool unitLocked = false,
  }) {
    final nextId = CourseProgress.nextLessonId(completed);
    final nodes = <LessonNode>[];

    for (final spec in specs) {
      if (spec.kind == LessonNodeKind.lesson) {
        final status = unitLocked
            ? LessonNodeStatus.locked
            : _statusForLesson(spec.id, completed, nextId);
        nodes.add(
          LessonNode(
            id: spec.id,
            title: spec.title,
            icon: spec.icon,
            status: status,
            kind: spec.kind,
            alignment: spec.alignment,
          ),
        );
        continue;
      }

      if (unitLocked) {
        nodes.add(
          LessonNode(
            id: spec.id,
            title: spec.title,
            icon: spec.icon,
            status: LessonNodeStatus.locked,
            kind: spec.kind,
            alignment: spec.alignment,
          ),
        );
        continue;
      }

      final lessonsBefore = specs
          .takeWhile((s) => s.id != spec.id)
          .where((s) => s.kind == LessonNodeKind.lesson)
          .map((s) => s.id)
          .every((id) => completed.contains(id));
      final status = lessonsBefore
          ? LessonNodeStatus.active
          : LessonNodeStatus.locked;
      nodes.add(
        LessonNode(
          id: spec.id,
          title: spec.title,
          icon: spec.icon,
          status: status,
          kind: spec.kind,
          alignment: spec.alignment,
        ),
      );
    }

    return nodes;
  }

  static LessonNodeStatus _statusForLesson(
    String id,
    Set<String> completed,
    String? nextId,
  ) {
    if (completed.contains(id)) return LessonNodeStatus.completed;
    if (id == nextId) return LessonNodeStatus.active;
    return LessonNodeStatus.locked;
  }

  static LessonNode? byId(String id, {required Set<String> completed}) {
    for (final unit in units(completed: completed)) {
      for (final node in unit.nodes) {
        if (node.id == id) return node;
      }
    }
    return null;
  }

  static const lessonCopy = {
    'besoins_envies': (
      'Besoins vs Envies',
      'Savoir faire la différence est la première étape pour '
          'maîtriser ton budget et atteindre tes objectifs.',
    ),
    'tri_depenses': (
      'Tri des dépenses',
      'Classe chaque dépense : fixe, variable ou imprévue.',
    ),
    'epargne_urgence': (
      'Épargne d’urgence',
      'Constitue un matelas avant les projets plus ambitieux.',
    ),
    'budget_simple': (
      'Budget simple',
      'Apprends à répartir ton argent du mois sans te ruiner.',
    ),
    'regle_503020': (
      'Règle 50-30-20',
      '50 % besoins · 30 % envies · 20 % épargne — en FCFA.',
    ),
    'objectif_epargne': (
      'Objectif d’épargne',
      'Fixe un montant réaliste et une date pour y arriver.',
    ),
    'caisse_jour': (
      'Ma caisse du jour',
      'Suis tes entrées et sorties pour garder la boutique saine.',
    ),
    'entrees_sorties': (
      'Entrées & sorties',
      'Note chaque franc entrant et chaque dépense de la journée.',
    ),
    'marge_benefice': (
      'Marge & bénéfice',
      'Prix de vente − coût = ce qu’il te reste vraiment.',
    ),
    'credit_client': (
      'Crédit client',
      'Décide quand faire crédit — et comment te protéger.',
    ),
    'stock_minimum': (
      'Stock minimum',
      'Évite la rupture sans bloquer ta trésorerie.',
    ),
    'separer_caisse': (
      'Caisse & perso',
      'L’argent du shop et ton argent perso : deux poches distinctes.',
    ),
  };
}
