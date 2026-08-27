import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/avatar_catalog.dart';
import '../../models/diagnostic.dart';
import '../../models/mfa_method.dart';
import '../../widgets/guest_profile_card.dart';
import '../../widgets/trophy_badge_tile.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  void _showAvatarSheet(BuildContext context, String? avatarId) {
    final spec = AvatarCatalog.byId(avatarId);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: SoftUiColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: SoftUiColors.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 20),
                FinedgeAvatar(avatarId: avatarId, radius: 48),
                const SizedBox(height: 14),
                Text(
                  spec.title,
                  style: AppTypography.title.copyWith(color: SoftUiColors.ink),
                ),
                const SizedBox(height: 6),
                Text(
                  spec.subtitle,
                  style: AppTypography.body.copyWith(color: SoftUiColors.muted),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = SessionScope.of(context);
    final session = controller.session;
    final diagnostic = session.diagnostic;
    final subtitle = diagnostic == null
        ? 'Mode local · progrès conservés sur l’appareil'
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
              avatarId: diagnostic?.avatar,
              onAvatarTap: () => _showAvatarSheet(context, diagnostic?.avatar),
            ),
            const SizedBox(height: 10),
            Text(
              'ID local · ${session.localId}',
              style: AppTypography.caption.copyWith(color: SoftUiColors.muted),
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
                  session.mfaMethod.label,
                  style: AppTypography.caption,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/mfa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
