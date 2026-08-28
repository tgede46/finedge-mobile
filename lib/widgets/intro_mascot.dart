import 'package:flutter/material.dart';

import 'finedge_mascot.dart';

class IntroMascot extends StatelessWidget {
  const IntroMascot({
    super.key,
    required this.scale,
    required this.opacity,
    required this.size,
  });

  final Animation<double> scale;
  final Animation<double> opacity;
  final double size;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: ScaleTransition(
        scale: scale,
        child: FinedgeMascot(size: size),
      ),
    );
  }
}
