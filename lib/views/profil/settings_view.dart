import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/feedback/app_feedback.dart';
import '../../core/preferences/app_preferences.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/finedge_mascot.dart';

/// Paramètres — préférences + connexion/déconnexion + lien À propos.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Future<void> _signOut() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: SoftUiColors.cream,
        title: Text('Se déconnecter ?', style: AppTypography.heading),
        content: Text(
          'Tu repasses en mode invité. Ta progression reste sur cet appareil.',
          style: AppTypography.body.copyWith(color: SoftUiColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: SoftUiColors.ink),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await SessionScope.of(context).signOut();
    AppFeedback.light();
    if (mounted) context.go('/accueil');
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context).session;
    final connected = session.isSignedIn && !session.isGuest;

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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                value: AppPreferences.notificationsEnabled,
                onChanged: (v) async {
                  await AppPreferences.setNotifications(v);
                  if (v) AppFeedback.selection();
                  setState(() {});
                },
                title: Text('Notifications', style: AppTypography.label),
                activeThumbColor: SoftUiColors.orange,
              ),
              const Divider(height: 1, color: SoftUiColors.border),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                value: AppFeedback.soundsEnabled,
                onChanged: (v) async {
                  await AppPreferences.setSounds(v);
                  if (v) AppFeedback.selection();
                  setState(() {});
                },
                title: Text('Sons', style: AppTypography.label),
                activeThumbColor: SoftUiColors.orange,
              ),
              const Divider(height: 1, color: SoftUiColors.border),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                value: AppFeedback.hapticsEnabled,
                onChanged: (v) async {
                  await AppPreferences.setHaptics(v);
                  if (v) AppFeedback.selection();
                  setState(() {});
                },
                title: Text('Vibrations', style: AppTypography.label),
                activeThumbColor: SoftUiColors.orange,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle('Compte'),
          _card(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: Icon(
                  connected
                      ? Icons.logout_rounded
                      : Icons.login_rounded,
                  color: SoftUiColors.orangeDeep,
                ),
                title: Text(
                  connected ? 'Se déconnecter' : 'Se connecter',
                  style: AppTypography.label,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  AppFeedback.selection();
                  if (connected) {
                    _signOut();
                  } else {
                    context.push('/login');
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle('À propos'),
          _card(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Text(FinedgeMascot.emoji, style: TextStyle(fontSize: 22)),
                title: Text('FinEdge', style: AppTypography.label),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  AppFeedback.selection();
                  context.push('/a-propos');
                },
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
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}
