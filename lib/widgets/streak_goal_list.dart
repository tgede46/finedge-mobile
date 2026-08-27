import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';
import 'duo_choice_tile.dart';

class StreakGoalOption {
  const StreakGoalOption({required this.days, required this.rewardLabel});

  final int days;
  final String rewardLabel;
}

class StreakGoalList extends StatelessWidget {
  const StreakGoalList({
    super.key,
    required this.options,
    required this.selectedDays,
    required this.onSelect,
  });

  final List<StreakGoalOption> options;
  final int? selectedDays;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final o in options)
          DuoChoiceTile(
            title: '${o.days} jours',
            subtitle: o.rewardLabel,
            selected: selectedDays == o.days,
            onTap: () => onSelect(o.days),
            leading: Icon(
              Icons.local_fire_department_rounded,
              color: selectedDays == o.days
                  ? SoftUiColors.orangeDeep
                  : SoftUiColors.muted,
            ),
          ),
      ],
    );
  }
}

class StreakHeroBlock extends StatelessWidget {
  const StreakHeroBlock({super.key, required this.days, this.message});

  final int days;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (message != null) ...[
          MascotBubble(message: message!),
          const SizedBox(height: 24),
        ],
        const Icon(
          Icons.local_fire_department_rounded,
          size: 72,
          color: SoftUiColors.orange,
        ),
        const SizedBox(height: 8),
        Text(
          '$days',
          style: AppTypography.display.copyWith(
            color: SoftUiColors.orangeDeep,
            fontSize: 64,
            height: 1,
          ),
        ),
        Text(
          days <= 1 ? 'jour de série' : 'jours de série',
          style: AppTypography.heading.copyWith(
            color: SoftUiColors.orangeDeep,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class MascotBubble extends StatelessWidget {
  const MascotBubble({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: SoftUiColors.tanSoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SoftUiColors.border),
          ),
          child: const Icon(
            Icons.support_agent_rounded,
            color: SoftUiColors.orangeDeep,
            size: 32,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: SoftUiColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: SoftUiColors.border, width: 1.8),
            ),
            child: Text(
              message,
              style: AppTypography.speech.copyWith(color: SoftUiColors.ink),
            ),
          ),
        ),
      ],
    );
  }
}
