import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

/// En-tête FinEdge style quête (Duolingo / FinQuest).
class FinedgeQuestHeader extends StatelessWidget {
  const FinedgeQuestHeader({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null)
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            color: SoftUiColors.ink,
          )
        else
          const SizedBox(width: 48),
        const Expanded(
          child: Text(
            'FinEdge',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SoftUiColors.orangeDeep,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}
