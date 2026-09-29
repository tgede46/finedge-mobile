import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Badge étoile + rayons tournants (maquette Félicitations).
class StarBurstBadge extends StatefulWidget {
  const StarBurstBadge({super.key, this.size = 140});

  final double size;

  @override
  State<StarBurstBadge> createState() => _StarBurstBadgeState();
}

class _StarBurstBadgeState extends State<StarBurstBadge>
    with TickerProviderStateMixin {
  late final AnimationController _spin;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _spin.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_spin, _pulse]),
      builder: (context, _) {
        final scale = 0.92 + (_pulse.value * 0.08);
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Transform.scale(
            scale: scale,
            child: CustomPaint(
              painter: _StarBurstPainter(rotation: _spin.value * math.pi * 2),
            ),
          ),
        );
      },
    );
  }
}

class _StarBurstPainter extends CustomPainter {
  _StarBurstPainter({required this.rotation});

  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.28;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final rayPaint = Paint()
      ..color = const Color(0xFFFF9800).withValues(alpha: 0.28);
    for (var i = 0; i < 8; i++) {
      canvas.save();
      canvas.rotate(i * math.pi / 4);
      final path = Path()
        ..moveTo(0, -size.width * 0.48)
        ..lineTo(size.width * 0.05, -r * 0.35)
        ..lineTo(-size.width * 0.05, -r * 0.35)
        ..close();
      canvas.drawPath(path, rayPaint);
      canvas.restore();
    }
    canvas.restore();

    final gradient = RadialGradient(
      colors: const [Color(0xFFFFD700), Color(0xFFFF8C00)],
    ).createShader(Rect.fromCircle(center: center, radius: r));

    canvas.drawCircle(center, r, Paint()..shader = gradient);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    final starPath = _star(center, r * 0.55, r * 0.24);
    canvas.drawPath(starPath, Paint()..color = Colors.white);
  }

  Path _star(Offset c, double outer, double inner) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * math.pi / 5;
      final radius = i.isEven ? outer : inner;
      final p = Offset(
        c.dx + math.cos(angle) * radius,
        c.dy + math.sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _StarBurstPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}
