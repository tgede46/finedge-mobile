import 'package:flutter/material.dart';

/// Logo FinEdge — toujours `assets/images/logo.png`, tel quel.
class FinedgeMascot extends StatelessWidget {
  const FinedgeMascot({super.key, this.size = 72});

  final double size;

  static const assetPath = 'assets/images/logo.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
