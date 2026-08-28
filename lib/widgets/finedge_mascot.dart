import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

/// Mascotte / logo FinEdge — renard (`assets/images/logo.png`).
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
    final logoSize = emojiSize ?? size;
    final child = Image.asset(
      assetPath,
      width: logoSize,
      height: logoSize,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );

    if (!showCircle) return child;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: SoftUiColors.tanSoft,
        shape: BoxShape.circle,
        border: Border.all(color: SoftUiColors.border, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
