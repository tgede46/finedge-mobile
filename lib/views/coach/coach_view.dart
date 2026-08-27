import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/mascot_header.dart';
import '../../widgets/question_pills.dart';

class CoachView extends StatelessWidget {
  const CoachView({super.key});

  static const _pills = [
    'Comment calculer ma marge ?',
    'Aide pour mon budget Wave',
    'Gérer un crédit client',
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: MascotHeader(
                title: 'Coach FinEdge',
                subtitle: 'Koko le Calao · toujours là',
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                children: const [
                  ChatBubble(
                    message: 'Salut ! Prêt à faire fructifier ton argent ? Pose-moi une question en FCFA, Mobile Money ou caisse.',
                  ),
                ],
              ),
            ),
            const QuestionPills(labels: _pills),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Écrire au coach…',
                  hintStyle: AppTypography.caption,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(
                    Icons.send_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
