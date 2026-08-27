import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class QuestionPills extends StatelessWidget {
  const QuestionPills({super.key, required this.labels, this.onSelected});

  final List<String> labels;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = labels[index];
          return ActionChip(
            label: Text(label),
            labelStyle: AppTypography.caption.copyWith(
              color: AppColors.brown,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: AppColors.surface,
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.35)),
            onPressed: () => onSelected?.call(label),
          );
        },
      ),
    );
  }
}
