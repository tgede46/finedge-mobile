import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

class HomeContinueCard extends StatelessWidget {
  const HomeContinueCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SoftUiColors.orange, SoftUiColors.orangeDeep],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 13.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton.icon(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: SoftUiColors.orangeDeep,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'Continuer',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
