import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';
import '../models/course_progress.dart';

/// Cœurs de vies quiz (5 max par jour).
class QuizLivesIndicator extends StatelessWidget {
  const QuizLivesIndicator({super.key, required this.lives});

  final int lives;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < CourseProgress.dailyQuizLives; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 2),
            child: Icon(
              i < lives ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 20,
              color: i < lives
                  ? const Color(0xFFE05252)
                  : SoftUiColors.muted.withValues(alpha: 0.45),
            ),
          ),
      ],
    );
  }
}
