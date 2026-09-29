import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.brown,
          side: const BorderSide(color: AppColors.brown, width: 1.2),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTypography.label.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
