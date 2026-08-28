import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.isUser = false,
  });

  final String message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser
              ? SoftUiColors.orange.withValues(alpha: 0.14)
              : SoftUiColors.card,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 20 : 4),
            topRight: Radius.circular(isUser ? 4 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
          border: Border.all(
            color: isUser ? SoftUiColors.orange : SoftUiColors.border,
          ),
        ),
        child: Text(
          message,
          style: AppTypography.body.copyWith(color: SoftUiColors.ink),
        ),
      ),
    );
  }
}
