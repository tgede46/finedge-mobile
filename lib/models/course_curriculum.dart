import 'package:flutter/material.dart';

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

/// Curriculum Leçons — aligné maquette Unité 1 / 2.
abstract final class CourseCurriculum {
  static List<CourseUnit> units({required bool firstLessonDone}) {
    // Maquette : ✓ · trophée · Besoins vs Envies (active) puis unité 2 verrouillée.
    // Avant 1ʳᵉ leçon : Besoins active. Après : Besoins ✓, trophée ✓, Budget active.
    final besoinsStatus = firstLessonDone
        ? LessonNodeStatus.completed
        : LessonNodeStatus.active;
    final afterBesoins = firstLessonDone
        ? LessonNodeStatus.completed
        : LessonNodeStatus.locked;
    final budgetStatus = firstLessonDone
        ? LessonNodeStatus.active
        : LessonNodeStatus.locked;

    return [
      CourseUnit(
        id: 'unit_epargne',
        index: 1,
        title: 'Les Bases de l’Épargne',
        icon: Icons.savings_outlined,
        nodes: [
          LessonNode(
            id: 'besoins_envies',
            title: 'Besoins vs Envies',
            icon: Icons.shopping_cart_outlined,
            status: besoinsStatus,
            alignment: firstLessonDone ? -1 : 0,
          ),
          LessonNode(
            id: 'trophy_u1',
            title: 'Défi unité',
            icon: Icons.emoji_events_rounded,
            status: afterBesoins,
            kind: LessonNodeKind.trophy,
            alignment: 1,
          ),
          LessonNode(
            id: 'budget_simple',
            title: 'Budget simple',
            icon: Icons.account_balance_wallet_outlined,
            status: budgetStatus,
            alignment: 0,
          ),
        ],
      ),
      const CourseUnit(
        id: 'unit_commerce',
        index: 2,
        title: 'Gérer son petit commerce',
        icon: Icons.storefront_outlined,
        nodes: [
          LessonNode(
            id: 'caisse_jour',
            title: 'Ma caisse du jour',
            icon: Icons.lock_rounded,
            status: LessonNodeStatus.locked,
            alignment: -1,
          ),
          LessonNode(
            id: 'credit_client',
            title: 'Crédit client',
            icon: Icons.lock_rounded,
            status: LessonNodeStatus.locked,
            alignment: 1,
          ),
        ],
      ),
    ];
  }

  static LessonNode? byId(String id, {required bool firstLessonDone}) {
    for (final unit in units(firstLessonDone: firstLessonDone)) {
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
    'budget_simple': (
      'Budget simple',
      'Apprends à répartir ton argent du mois sans te ruiner.',
    ),
    'caisse_jour': (
      'Ma caisse du jour',
      'Suis tes entrées et sorties pour garder la boutique saine.',
    ),
    'credit_client': (
      'Crédit client',
      'Décide quand faire crédit — et comment te protéger.',
    ),
  };
}
