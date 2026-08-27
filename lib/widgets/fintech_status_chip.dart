import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class FintechStatusChip extends StatelessWidget {
  const FintechStatusChip({
    super.key,
    required this.icon,
    required this.label,
    this.emphasized = false,
  });

  final IconData icon;
  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: emphasized
            ? AppColors.onPrimary.withValues(alpha: 0.18)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: emphasized ? AppColors.onPrimary : AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: emphasized ? AppColors.onPrimary : AppColors.brown,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
