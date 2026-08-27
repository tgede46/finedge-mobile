import 'package:flutter/material.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../models/diagnostic.dart';

/// Onglet 4 — Profil, trophées et MFA à la carte (Story 1.3 ensuite).
class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final diagnostic = SessionScope.of(context).session.diagnostic;

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppGradients.fintech,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.onPrimary,
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invité',
                          style: AppTypography.title.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                        Text(
                          diagnostic == null
                              ? 'Mode local · progrès conservés sur l’appareil'
                              : '${diagnostic.activity.label} · ${diagnostic.pace.label}',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Trophées', style: AppTypography.heading),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _BadgeTile(title: 'Premier Pas', locked: true),
                _BadgeTile(title: 'Maître de la Caisse', locked: true),
                _BadgeTile(title: 'Série de 7 Jours', locked: true),
                _BadgeTile(title: 'As de la Négociation', locked: true),
              ],
            ),
            const SizedBox(height: 28),
            Text('Sécurité', style: AppTypography.heading),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.primary,
                ),
                title: Text('MFA à la carte', style: AppTypography.label),
                subtitle: Text(
                  'WhatsApp, SMS, Authenticator ou aucun',
                  style: AppTypography.caption,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.title, required this.locked});

  final String title;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Icon(
                locked ? Icons.lock_outline : Icons.emoji_events_rounded,
                color: locked ? AppColors.locked : AppColors.gold,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.brown,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
