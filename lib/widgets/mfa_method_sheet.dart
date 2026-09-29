import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';
import '../models/mfa_method.dart';

/// Sélecteur MFA à la carte (préférence locale — OTP réel = story 1.3).
class MfaMethodSheet extends StatelessWidget {
  const MfaMethodSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MfaMethod selected;
  final ValueChanged<MfaMethod> onSelected;

  static Future<void> show(
    BuildContext context, {
    required MfaMethod selected,
    required ValueChanged<MfaMethod> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: SoftUiColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) =>
          MfaMethodSheet(selected: selected, onSelected: onSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: SoftUiColors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sécurité MFA',
              style: AppTypography.title.copyWith(color: SoftUiColors.ink),
            ),
            const SizedBox(height: 6),
            Text(
              'Choisis comment sécuriser ton compte. Tu pourras changer à tout moment.',
              style: AppTypography.body.copyWith(color: SoftUiColors.muted),
            ),
            const SizedBox(height: 16),
            for (final method in MfaMethod.values)
              _MfaTile(
                method: method,
                selected: selected == method,
                onTap: () {
                  onSelected(method);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _MfaTile extends StatelessWidget {
  const _MfaTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final MfaMethod method;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon => switch (method) {
    MfaMethod.none => Icons.shield_outlined,
    MfaMethod.whatsapp => Icons.chat_outlined,
    MfaMethod.sms => Icons.sms_outlined,
    MfaMethod.authenticator => Icons.phonelink_lock_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? const Color(0xFFFFF1E0) : SoftUiColors.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? SoftUiColors.orange : SoftUiColors.border,
                width: selected ? 2 : 1.4,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _icon,
                  color: selected
                      ? SoftUiColors.orangeDeep
                      : SoftUiColors.muted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.label,
                        style: AppTypography.optionTitle.copyWith(
                          color: SoftUiColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        method.description,
                        style: AppTypography.optionSubtitle,
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle, color: SoftUiColors.orange),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
