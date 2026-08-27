import 'package:flutter/material.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../models/diagnostic.dart';
import '../../models/learning_path.dart';
import '../shell/main_shell_view.dart';

/// Onglet 1 — Sentier d'apprentissage personnalisé (nœuds 3D Story 2.1).
class SentierView extends StatelessWidget {
  const SentierView({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final diagnostic = session.session.diagnostic;
    final path = session.path;

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppGradients.fintech,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'FinEdge',
                            style: AppTypography.heading.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                          const Spacer(),
                          const FintechStatusChip(
                            icon: Icons.local_fire_department,
                            label: '0',
                            emphasized: true,
                          ),
                          const SizedBox(width: 8),
                          const FintechStatusChip(
                            icon: Icons.stars_rounded,
                            label: '0 XP',
                            emphasized: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ton sentier est tracé',
                        style: AppTypography.title.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        diagnostic == null
                            ? '3 minutes pour mieux gérer ta caisse, en FCFA.'
                            : '${diagnostic.pace.label} · ${diagnostic.activity.label}',
                        style: AppTypography.body.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: _PathPreview(path: path)),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Reprendre'),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _PathPreview extends StatelessWidget {
  const _PathPreview({required this.path});

  final LearningPath path;

  @override
  Widget build(BuildContext context) {
    final nodes = path.nodes;
    return Column(
      children: [
        for (var i = 0; i < nodes.length; i++) ...[
          _PathNode(node: nodes[i]),
          if (i < nodes.length - 1)
            _PathConnector(
              locked: nodes[i + 1].status != PathNodeStatus.active,
            ),
        ],
      ],
    );
  }
}

class _PathConnector extends StatelessWidget {
  const _PathConnector({this.locked = false});

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

class _PathNode extends StatelessWidget {
  const _PathNode({required this.node});

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
