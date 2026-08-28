import 'package:flutter/material.dart';

/// Mascotte / logo FinEdge — `assets/images/logo.png` (déjà circulaire).
class FinedgeMascot extends StatelessWidget {
  const FinedgeMascot({
    super.key,
    this.size = 72,
    this.emojiSize,
    this.showCircle = false,
  });

  final double size;
  /// Conservé pour compatibilité ; ignore si logo image.
  final double? emojiSize;
  final bool showCircle;

  static const assetPath = 'assets/images/logo.png';
  static const emoji = '🦊';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: emojiSize ?? size,
      height: emojiSize ?? size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
