import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/feedback/app_feedback.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/mfa_method.dart';

/// Paramètres démo — toggles locaux + lien MFA (stub).
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context).session;
    final email = session.email?.trim();
    final accountLabel = (email != null && email.isNotEmpty)
        ? email
        : (session.isGuest ? 'Compte invité (local)' : 'Compte connecté');

    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      appBar: AppBar(
        backgroundColor: SoftUiColors.cream,
        elevation: 0,
        foregroundColor: SoftUiColors.ink,
        title: Text(
          'Paramètres',
          style: AppTypography.heading.copyWith(color: SoftUiColors.ink),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _sectionTitle('Préférences'),
          _card(
            children: [
              SwitchListTile(
                value: _notifications,
                onChanged: (v) {
                  AppFeedback.selection();
                  setState(() => _notifications = v);
                },
                title: Text('Notifications', style: AppTypography.label),
                subtitle: Text(
                  'Rappels de série (démo UI)',
                  style: AppTypography.caption,
                ),
                activeThumbColor: SoftUiColors.orange,
              ),
              SwitchListTile(
                value: AppFeedback.soundsEnabled,
                onChanged: (v) {
                  setState(() => AppFeedback.soundsEnabled = v);
                  if (v) AppFeedback.selection();
                },
                title: Text('Sons', style: AppTypography.label),
                subtitle: Text(
                  'Clics système sur les interactions',
                  style: AppTypography.caption,
                ),
                activeThumbColor: SoftUiColors.orange,
              ),
              SwitchListTile(
                value: AppFeedback.hapticsEnabled,
                onChanged: (v) {
                  setState(() => AppFeedback.hapticsEnabled = v);
                  if (v) AppFeedback.selection();
                },
                title: Text('Vibrations', style: AppTypography.label),
                subtitle: Text(
                  'Retour haptique Duolingo-like',
                  style: AppTypography.caption,
                ),
                activeThumbColor: SoftUiColors.orange,
              ),
            ],
          ),
          const SizedBox(height: 22),
          _sectionTitle('Compte'),
          _card(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: SoftUiColors.orangeDeep,
                ),
                title: Text('Identifiant', style: AppTypography.label),
                subtitle: Text(accountLabel, style: AppTypography.caption),
              ),
              if (session.isGuest)
                ListTile(
                  leading: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: SoftUiColors.orangeDeep,
                  ),
                  title: Text('Créer mon profil', style: AppTypography.label),
                  subtitle: Text(
                    'Lier un e-mail (stub démo)',
                    style: AppTypography.caption,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    AppFeedback.selection();
                    context.push('/login');
                  },
                ),
              ListTile(
                leading: const Icon(
                  Icons.verified_user_outlined,
                  color: SoftUiColors.orangeDeep,
                ),
                title: Text(
                  'Changer l’authentification',
                  style: AppTypography.label,
                ),
                subtitle: Text(
                  'MFA · ${session.mfaMethod.label}',
                  style: AppTypography.caption,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  AppFeedback.selection();
                  context.push('/mfa');
                },
              ),
            ],
          ),
          const SizedBox(height: 22),
          _sectionTitle('À propos'),
          _card(
            children: [
              ListTile(
                leading: const Text('🐊', style: TextStyle(fontSize: 22)),
                title: Text('FinEdge', style: AppTypography.label),
                subtitle: Text(
                  'MVP démo · multiplateforme',
                  style: AppTypography.caption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: AppTypography.heading.copyWith(color: SoftUiColors.ink),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: SoftUiColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SoftUiColors.border),
      ),
      child: Column(children: children),
    );
  }
}
