import 'diagnostic.dart';

enum PathNodeStatus { completed, active, locked, chest }

class PathNodeData {
  const PathNodeData({
    required this.id,
    required this.label,
    required this.status,
    this.stars = 0,
  });

  final String id;
  final String label;
  final PathNodeStatus status;
  final int stars;

  String get subtitle => switch (status) {
    PathNodeStatus.completed => 'Complété',
    PathNodeStatus.active => 'Leçon active',
    PathNodeStatus.locked => 'Verrouillé',
    PathNodeStatus.chest => '+100 XP',
  };
}

class LearningPath {
  const LearningPath({required this.nodes});

  final List<PathNodeData> nodes;

  PathNodeData get activeLesson =>
      nodes.firstWhere((node) => node.status == PathNodeStatus.active);

  factory LearningPath.fromDiagnostic(Diagnostic diagnostic) {
    final firstId = _firstLessonId(diagnostic);
    final ordered = [
      ..._lessons.where((lesson) => lesson.$1 == firstId),
      ..._lessons.where((lesson) => lesson.$1 != firstId),
    ];

    return LearningPath(
      nodes: [
        for (var i = 0; i < ordered.length; i++)
          PathNodeData(
            id: ordered[i].$1,
            label: ordered[i].$2,
            status: i == 0 ? PathNodeStatus.active : PathNodeStatus.locked,
          ),
        const PathNodeData(
          id: 'chest',
          label: 'Coffre du chapitre',
          status: PathNodeStatus.chest,
        ),
      ],
    );
  }

  static const _lessons = [
    ('cashbox', 'Ma caisse du jour'),
    ('emergency', 'Le coffre des imprévus'),
    ('mobile_money', 'Frais Mobile Money'),
  ];

  static String _firstLessonId(Diagnostic diagnostic) {
    if (diagnostic.wantsInvest) return 'mobile_money';
    if (diagnostic.wantsCashbox) return 'cashbox';
    if (diagnostic.wantsEmergency) return 'emergency';
    return 'cashbox';
  }
}
