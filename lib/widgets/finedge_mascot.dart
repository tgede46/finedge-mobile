import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

/// Mascotte FinEdge — renard emoji (charte crème / orange).
class FinedgeMascot extends StatelessWidget {
  const FinedgeMascot({
    super.key,
    this.size = 72,
    this.emojiSize,
    this.showCircle = true,
  });

  final double size;
  final double? emojiSize;
  final bool showCircle;

  static const emoji = '🦊';

  @override
  Widget build(BuildContext context) {
    final child = Text(
      emoji,
      style: TextStyle(fontSize: emojiSize ?? size * 0.55),
      textAlign: TextAlign.center,
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
      child: child,
    );
  }
}
