import 'package:flutter/material.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/diagnostic.dart';
import '../../widgets/guest_profile_card.dart';
import '../../widgets/trophy_badge_tile.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final diagnostic = SessionScope.of(context).session.diagnostic;
    final subtitle = diagnostic == null
        ? 'Mode local · progrès conservés sur l’appareil'
        : diagnostic.age != null
        ? '${diagnostic.age} ans · ${diagnostic.pace.label}'
        : '${diagnostic.activity.label} · ${diagnostic.pace.label}';

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            GuestProfileCard(
              displayName: diagnostic?.displayName?.trim().isNotEmpty == true
                  ? diagnostic!.displayName!.trim()
                  : 'Invité',
              subtitle: subtitle,
            ),
            const SizedBox(height: 24),
            Text('Trophées', style: AppTypography.heading),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                TrophyBadgeTile(title: 'Premier Pas', locked: true),
                TrophyBadgeTile(title: 'Maître de la Caisse', locked: true),
                TrophyBadgeTile(title: 'Série de 7 Jours', locked: true),
                TrophyBadgeTile(title: 'As de la Négociation', locked: true),
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
