import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feedback/app_feedback.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/star_burst_badge.dart';

/// Fin de leçon / unité — écran Félicitations (maquette).
///
/// Vies (5/jour) et quiz 10 questions : plus tard — pas encore branchés.
class LessonCompleteView extends StatefulWidget {
  const LessonCompleteView({
    super.key,
    this.xpEarned = 125,
    this.level = 5,
    this.levelProgress = 0.75,
    this.gemsEarned = 3,
    this.nextRoute = '/lecons',
  });

  final int xpEarned;
  final int level;
  final double levelProgress;
  final int gemsEarned;
  final String nextRoute;

  @override
  State<LessonCompleteView> createState() => _LessonCompleteViewState();
}

class _LessonCompleteViewState extends State<LessonCompleteView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bg;

  @override
  void initState() {
    super.initState();
    AppFeedback.success();
    _bg = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
  }

  @override
  void dispose() {
    _bg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bg,
        builder: (context, child) {
          return CustomPaint(
            painter: _WarmOrangeBgPainter(t: _bg.value),
            child: child,
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const StarBurstBadge(size: 156),
                const SizedBox(height: 20),
                Text(
                  'Félicitations !',
                  textAlign: TextAlign.center,
                  style: AppTypography.display.copyWith(
                    color: SoftUiColors.ink,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vous avez brillamment réussi cette leçon.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: SoftUiColors.ink,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  decoration: BoxDecoration(
                    color: SoftUiColors.card,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '+${widget.xpEarned} XP',
                            style: AppTypography.optionTitle.copyWith(
                              color: SoftUiColors.ink,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Niveau ${widget.level}',
                            style: AppTypography.label.copyWith(
                              color: SoftUiColors.muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: widget.levelProgress.clamp(0.05, 1),
                          minHeight: 10,
                          backgroundColor: SoftUiColors.progressTrack,
                          color: SoftUiColors.orange,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1E0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.diamond_rounded,
                              color: Color(0xFFFFC107),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${widget.gemsEarned} Gemmes gagnées',
                              style: AppTypography.label.copyWith(
                                color: SoftUiColors.ink,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: () => context.go(widget.nextRoute),
                    style: FilledButton.styleFrom(
                      backgroundColor: SoftUiColors.ink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Continuer →',
                      style: AppTypography.button.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Partage bientôt disponible'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.ios_share_rounded, size: 20),
                    label: const Text('Partager mon succès'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SoftUiColors.ink,
                      side: const BorderSide(
                        color: SoftUiColors.border,
                        width: 1.6,
                      ),
                      backgroundColor: SoftUiColors.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fond orange animé (équivalent soft du shader ANIMATION_41).
class _WarmOrangeBgPainter extends CustomPainter {
  _WarmOrangeBgPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final wave = math.sin(t * math.pi * 2) * 0.5 + 0.5;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-0.2 + wave * 0.3, -1),
        end: Alignment(0.3 - wave * 0.2, 1),
        colors: [
          Color.lerp(const Color(0xFFFFB347), const Color(0xFFFF8C00), wave)!,
          Color.lerp(
            const Color(0xFFFFCC80),
            const Color(0xFFFFE0B2),
            1 - wave,
          )!,
          const Color(0xFFFFF3E0),
        ],
        stops: const [0, 0.45, 1],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Vignette légère
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.12)],
          radius: 1.05,
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _WarmOrangeBgPainter oldDelegate) =>
      oldDelegate.t != t;
}
