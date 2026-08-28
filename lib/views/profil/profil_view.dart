import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/feedback/app_feedback.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/avatar_catalog.dart';
import '../../models/diagnostic.dart';
import '../../models/guest_session.dart';

/// Profil — maquette : header, stats, badges, dernier diagnostic.
class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  static int levelForXp(int xp) => (1 + xp ~/ 250).clamp(1, 20);

  static String rankTitleForLevel(int level) {
    if (level >= 10) return 'Maître de la Caisse';
    if (level >= 5) return 'Apprenti Économe';
    if (level >= 3) return 'Explorateur Financier';
    return 'Débutant';
  }

  static String leagueForXp(int xp) {
    if (xp >= 1000) return 'Ligue Or';
    if (xp >= 400) return 'Ligue Argent';
    return 'Ligue Bronze';
  }

  /// Score démo dérivé du diagnostic (pas encore de vrai quiz santé).
  static int diagnosticScore(Diagnostic? d) {
    if (d == null) return 0;
    var score = 55;
    score += (d.goals.length * 6).clamp(0, 24);
    score += switch (d.level) {
      'economist' => 18,
      'solid' => 14,
      'daily' => 10,
      'basics' => 6,
      _ => 2,
    };
    return score.clamp(40, 95);
  }

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

  void _showDiagnosticDetails(BuildContext context, GuestSession session) {
    final d = session.diagnostic;
    if (d == null) return;
    final score = diagnosticScore(d);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Détails du diagnostic',
                  style: AppTypography.heading.copyWith(
                    color: SoftUiColors.ink,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Score · $score/100', style: AppTypography.label),
                const SizedBox(height: 8),
                Text(
                  'Activité · ${d.activity.label}',
                  style: AppTypography.body.copyWith(color: SoftUiColors.muted),
                ),
                Text(
                  'Niveau · ${d.level}',
                  style: AppTypography.body.copyWith(color: SoftUiColors.muted),
                ),
                Text(
                  'Rythme · ${d.pace.label}',
                  style: AppTypography.body.copyWith(color: SoftUiColors.muted),
                ),
                if (d.goals.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Objectifs · ${d.goals.length}',
                    style: AppTypography.body.copyWith(
                      color: SoftUiColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionController = SessionScope.of(context);
    final session = sessionController.session;
    final canRetakeDiagnostic = sessionController.canRetakeDiagnostic;
    final diagnostic = session.diagnostic;
    final name = diagnostic?.displayName?.trim().isNotEmpty == true
        ? diagnostic!.displayName!.trim()
        : (session.isGuest ? 'Invité' : 'Membre FinEdge');
    final level = levelForXp(session.xp);
    final rank = rankTitleForLevel(level);
    final score = diagnosticScore(diagnostic);
    final firstBadgeUnlocked = session.hasCompletedFirstLesson;
    final streakBadgeUnlocked = session.streakDays >= 7;

    return ColoredBox(
      color: SoftUiColors.cream,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FinedgeAvatar(
                  avatarId: diagnostic?.avatar,
                  radius: 32,
                  onTap: () => _showAvatarSheet(context, diagnostic?.avatar),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.title.copyWith(
                          color: SoftUiColors.ink,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8B923),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.monetization_on_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Niveau $level - $rank',
                              style: AppTypography.caption.copyWith(
                                color: SoftUiColors.muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Paramètres',
                  onPressed: () {
                    AppFeedback.selection();
                    context.push('/parametres');
                  },
                  icon: const Icon(Icons.settings_outlined, size: 22),
                  color: SoftUiColors.ink,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Stats
            Row(
              children: [
                Expanded(
                  child: _ProfileStatCard(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: const Color(0xFFFF6B00),
                    iconBg: const Color(0xFFFFE8D6),
                    value: '${session.streakDays} Jours',
                    label: 'Série Actuelle',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ProfileStatCard(
                    icon: Icons.bolt_rounded,
                    iconColor: const Color(0xFFE8B923),
                    iconBg: const Color(0xFFFFF6D6),
                    value: _formatXp(session.xp),
                    label: 'XP Total',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ProfileStatCard(
                    icon: Icons.emoji_events_rounded,
                    iconColor: const Color(0xFF5B8DEF),
                    iconBg: const Color(0xFFE3EDFF),
                    value: leagueForXp(session.xp),
                    label: 'Rang Actuel',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Vos Badges',
              style: AppTypography.heading.copyWith(
                color: SoftUiColors.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _BadgeCard(
                    title: 'Épargnant Débutant',
                    locked: !firstBadgeUnlocked,
                    unlockedColor: const Color(0xFF8D6E63),
                    icon: Icons.savings_rounded,
                    borderColor: const Color(0xFF8D6E63),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _BadgeCard(
                    title: 'Maître du Budget',
                    locked: !firstBadgeUnlocked,
                    unlockedColor: const Color(0xFFE8B923),
                    icon: Icons.account_balance_wallet_rounded,
                    borderColor: const Color(0xFFE8B923),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _BadgeCard(
                    title: 'Investisseur Pro',
                    locked: !streakBadgeUnlocked,
                    unlockedColor: SoftUiColors.orangeDeep,
                    icon: Icons.trending_up_rounded,
                    borderColor: SoftUiColors.border,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Diagnostic
            if (diagnostic != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    size: 20,
                    color: SoftUiColors.ink,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dernier Diagnostic',
                      style: AppTypography.heading.copyWith(
                        color: SoftUiColors.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    'Récent',
                    style: AppTypography.caption.copyWith(
                      color: SoftUiColors.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SoftUiColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: SoftUiColors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7EFE6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: SoftUiColors.card,
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: const Color(0xFFE8B923),
                                width: 2.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$score',
                              style: AppTypography.title.copyWith(
                                color: SoftUiColors.ink,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Score : $score/100',
                                  style: AppTypography.label.copyWith(
                                    color: SoftUiColors.ink,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  score >= 70
                                      ? 'Votre santé financière est bonne, mais il reste des opportunités d’optimisation.'
                                      : 'Bon début — continue les leçons pour renforcer ta santé financière.',
                                  style: AppTypography.caption.copyWith(
                                    color: SoftUiColors.muted,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                AppFeedback.selection();
                                _showDiagnosticDetails(context, session);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: SoftUiColors.ink,
                                backgroundColor: const Color(0xFFF7EFE6),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Voir les détails',
                                style: AppTypography.label.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: FilledButton(
                              onPressed: () {
                                AppFeedback.light();
                                if (!canRetakeDiagnostic) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Termine la leçon « Épargne d’urgence » '
                                        '(Unité 1 · leçon 3) pour repasser le diagnostic.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                context.push('/onboarding?retake=1');
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: canRetakeDiagnostic
                                    ? SoftUiColors.ink
                                    : SoftUiColors.muted,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Refaire le test',
                                style: AppTypography.label.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                'Dernier Diagnostic',
                style: AppTypography.heading.copyWith(
                  color: SoftUiColors.ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: SoftUiColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: SoftUiColors.border),
                ),
                child: Text(
                  'Termine l’onboarding pour voir ton diagnostic.',
                  style: AppTypography.body.copyWith(color: SoftUiColors.muted),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _formatXp(int xp) {
    final s = xp.toString();
    if (s.length <= 3) return s;
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
      decoration: BoxDecoration(
        color: SoftUiColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SoftUiColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SoftUiColors.ink,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SoftUiColors.muted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({
    required this.title,
    required this.locked,
    required this.unlockedColor,
    required this.icon,
    required this.borderColor,
  });

  final String title;
  final bool locked;
  final Color unlockedColor;
  final IconData icon;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final tint = locked ? SoftUiColors.muted : unlockedColor;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
      decoration: BoxDecoration(
        color: SoftUiColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: locked ? SoftUiColors.border : borderColor.withValues(alpha: 0.55),
          width: 1.4,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: locked
                  ? SoftUiColors.tanSoft
                  : unlockedColor.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              locked ? Icons.lock_outline_rounded : icon,
              color: tint,
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: SoftUiColors.ink,
              fontWeight: FontWeight.w700,
              height: 1.2,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
