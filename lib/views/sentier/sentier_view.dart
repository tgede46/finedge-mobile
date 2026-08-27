import 'package:flutter/material.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/diagnostic.dart';
import '../../widgets/fintech_header_card.dart';
import '../../widgets/fintech_status_chip.dart';
import '../../widgets/path_preview.dart';

class SentierView extends StatelessWidget {
  const SentierView({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final diagnostic = session.session.diagnostic;

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: FintechHeaderCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'FinEdge',
                            style: AppTypography.heading.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                          const Spacer(),
                          const FintechStatusChip(
                            icon: Icons.local_fire_department,
                            label: '0',
                            emphasized: true,
                          ),
                          const SizedBox(width: 8),
                          const FintechStatusChip(
                            icon: Icons.stars_rounded,
                            label: '0 XP',
                            emphasized: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tes leçons',
                        style: AppTypography.title.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        diagnostic == null
                            ? '3 minutes pour mieux gérer ta caisse, en FCFA.'
                            : '${diagnostic.pace.label} · ${diagnostic.activity.label}',
                        style: AppTypography.body.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: PathPreview(path: session.path)),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Reprendre'),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
