import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class WelcomeHeroArt extends StatelessWidget {
  const WelcomeHeroArt({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.25,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDCEEF8), Color(0xFFFDF6E8), Color(0xFFFDFBF7)],
          ),
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            _Bokeh(left: 28, top: 36, size: 54, color: Color(0x66FFF3B0)),
            _Bokeh(right: 36, top: 24, size: 40, color: Color(0x55A8D4F0)),
            _Bokeh(left: 48, bottom: 28, size: 28, color: Color(0x55FFFFFF)),
            _PiggyExplorer(),
          ],
        ),
      ),
    );
  }
}

class _Bokeh extends StatelessWidget {
  const _Bokeh({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.size,
    required this.color,
  });

  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class _PiggyExplorer extends StatelessWidget {
  const _PiggyExplorer();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 230,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(right: 16, top: 52, child: _GoldCoin()),
          Positioned(left: 40, top: 48, child: _PiggyBody()),
          Positioned(left: 68, top: 22, child: _ExplorerHat()),
        ],
      ),
    );
  }
}

class _PiggyBody extends StatelessWidget {
  const _PiggyBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124,
      height: 124,
      decoration: const BoxDecoration(
        color: Color(0xFFE88A3C),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Stack(
        children: [
          Positioned(
            left: 38,
            top: 54,
            child: SizedBox(
              width: 48,
              height: 28,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFF2A25C),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
          Positioned(
            left: 42,
            top: 42,
            child: Row(children: [_Eye(), SizedBox(width: 22), _Eye()]),
          ),
        ],
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  const _Eye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: AppColors.brown,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ExplorerHat extends StatelessWidget {
  const _ExplorerHat();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFF6B4423),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
        Container(
          width: 78,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFF5C3A21),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}

class _GoldCoin extends StatelessWidget {
  const _GoldCoin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.gold,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x66C9A227),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Text(
        'FIN',
        style: TextStyle(
          color: AppColors.brown,
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
