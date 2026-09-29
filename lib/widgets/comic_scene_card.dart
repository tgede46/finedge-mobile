import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class ComicSceneCard extends StatelessWidget {
  const ComicSceneCard({
    super.key,
    required this.title,
    required this.dialogue,
  });

  final String title;
  final String dialogue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.storefront,
                color: AppColors.onPrimary,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.heading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              dialogue,
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
