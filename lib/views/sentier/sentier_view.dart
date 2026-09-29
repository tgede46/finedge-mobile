import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/course_curriculum.dart';

/// Onglet Leçons — sentier aéré par unités (style Duolingo).
class SentierView extends StatelessWidget {
  const SentierView({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context).session;
    final units = CourseCurriculum.units(
      completed: session.completedLessonIds,
    );

    return ColoredBox(
      color: SoftUiColors.cream,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text(
              'Ton sentier',
              style: AppTypography.display.copyWith(
                color: SoftUiColors.ink,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Avance leçon par leçon. Chaque étape compte.',
              style: AppTypography.body.copyWith(color: SoftUiColors.muted),
            ),
            const SizedBox(height: 20),
            for (final unit in units) ...[
              _UnitHeader(unit: unit),
              const SizedBox(height: 16),
              _UnitPath(
                nodes: unit.nodes,
                onLessonTap: (node) {
                  if (node.status == LessonNodeStatus.locked) return;
                  if (node.kind != LessonNodeKind.lesson) return;
                  context.push('/lecon/${node.id}');
                },
              ),
              const SizedBox(height: 36),
            ],
          ],
        ),
      ),
    );
  }
}

class _UnitHeader extends StatelessWidget {
  const _UnitHeader({required this.unit});

  final CourseUnit unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      decoration: BoxDecoration(
        color: SoftUiColors.tanSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unité ${unit.index}',
                  style: AppTypography.optionTitle.copyWith(
                    color: SoftUiColors.ink,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  unit.title,
                  style: AppTypography.body.copyWith(
                    color: SoftUiColors.ink,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: SoftUiColors.card,
              shape: BoxShape.circle,
            ),
            child: Icon(unit.icon, color: SoftUiColors.orangeDeep, size: 26),
          ),
        ],
      ),
    );
  }
}

class _UnitPath extends StatelessWidget {
  const _UnitPath({required this.nodes, required this.onLessonTap});

  static const _nodeSpacing = 124.0;
  static const _pathTopPad = 24.0;
  static const _horizontalOffset = 88.0;

  final List<LessonNode> nodes;
  final ValueChanged<LessonNode> onLessonTap;

  @override
  Widget build(BuildContext context) {
    final height = _pathTopPad * 2 + nodes.length * _nodeSpacing;

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: _pathTopPad + 36,
            bottom: _pathTopPad + 36,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: SoftUiColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          for (var i = 0; i < nodes.length; i++)
            Positioned(
              top: _pathTopPad + i * _nodeSpacing,
              left: 0,
              right: 0,
              child: _PathNodeRow(
                node: nodes[i],
                horizontalOffset: _horizontalOffset,
                rowHeight: _nodeSpacing,
                onTap: () => onLessonTap(nodes[i]),
              ),
            ),
        ],
      ),
    );
  }
}

class _PathNodeRow extends StatelessWidget {
  const _PathNodeRow({
    required this.node,
    required this.horizontalOffset,
    required this.rowHeight,
    required this.onTap,
  });

  final LessonNode node;
  final double horizontalOffset;
  final double rowHeight;
  final VoidCallback onTap;

  double get _dx => switch (node.alignment) {
    -1 => -horizontalOffset,
    1 => horizontalOffset,
    _ => 0,
  };

  @override
  Widget build(BuildContext context) {
    final locked = node.status == LessonNodeStatus.locked;
    final completed = node.status == LessonNodeStatus.completed;
    final active = node.status == LessonNodeStatus.active;

    final bg = locked ? SoftUiColors.tanSoft : SoftUiColors.orange;
    final icon = locked
        ? Icons.lock_rounded
        : completed && node.kind == LessonNodeKind.lesson
        ? Icons.check_rounded
        : node.icon;
    final iconColor = locked ? SoftUiColors.muted : Colors.white;
    final size = active ? 68.0 : 56.0;
    final showLabel = active && node.title.isNotEmpty;

    return SizedBox(
      height: rowHeight,
      child: Column(
        children: [
          if (showLabel) ...[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: horizontalOffset * 2 + 80),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: SoftUiColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: SoftUiColors.orange, width: 1.8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  node.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(
                    color: SoftUiColors.ink,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ] else
            const SizedBox(height: 44),
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(_dx, 0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: locked ? null : onTap,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: bg,
                        shape: BoxShape.circle,
                        border: active
                            ? Border.all(
                                color: SoftUiColors.orangeDeep,
                                width: 3,
                              )
                            : null,
                        boxShadow: active
                            ? const [
                                BoxShadow(
                                  color: Color(0x40E07818),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: active ? 28 : 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
