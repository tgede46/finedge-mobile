import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/learning_path.dart';

class PathPreview extends StatelessWidget {
  const PathPreview({super.key, required this.path});

  final LearningPath path;

  @override
  Widget build(BuildContext context) {
    final nodes = path.nodes;
    return Column(
      children: [
        for (var i = 0; i < nodes.length; i++) ...[
          PathNode(node: nodes[i]),
          if (i < nodes.length - 1)
            PathConnector(locked: nodes[i + 1].status != PathNodeStatus.active),
        ],
      ],
    );
  }
}

class PathConnector extends StatelessWidget {
  const PathConnector({super.key, this.locked = false});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 28,
      decoration: BoxDecoration(
        color: locked
            ? AppColors.locked.withValues(alpha: 0.4)
            : AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class PathNode extends StatelessWidget {
  const PathNode({super.key, required this.node});

  final PathNodeData node;

  @override
  Widget build(BuildContext context) {
    final (Color fill, IconData icon) = switch (node.status) {
      PathNodeStatus.completed => (AppColors.gold, Icons.check_rounded),
      PathNodeStatus.active => (AppColors.primary, Icons.play_arrow_rounded),
      PathNodeStatus.locked => (AppColors.locked, Icons.lock_rounded),
      PathNodeStatus.chest => (AppColors.brown, Icons.inventory_2_rounded),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              boxShadow: node.status == PathNodeStatus.active
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.45),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, color: AppColors.onPrimary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(node.label, style: AppTypography.heading),
                Text(node.subtitle, style: AppTypography.caption),
                if (node.stars > 0)
                  Row(
                    children: List.generate(
                      node.stars,
                      (_) => const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
