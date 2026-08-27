import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/soft_ui_colors.dart';

/// Formulaire final : prénom / pseudo + âge (capture « Faisons connaissance »).
class AcquaintanceFormCard extends StatelessWidget {
  const AcquaintanceFormCard({
    super.key,
    required this.nameController,
    required this.ageController,
  });

  final TextEditingController nameController;
  final TextEditingController ageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: SoftUiColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SoftUiColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: SoftUiColors.iconBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_add_alt_1_rounded,
              color: SoftUiColors.ink,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Faisons connaissance !',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SoftUiColors.ink,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dis-nous en un peu plus pour personnaliser ton aventure financière.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SoftUiColors.muted,
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          const _FieldLabel(
            icon: Icons.badge_outlined,
            label: 'Prénom ou Pseudo',
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(hint: 'Comment doit-on t’appeler ?'),
          ),
          const SizedBox(height: 18),
          const _FieldLabel(icon: Icons.cake_outlined, label: 'Ton Âge'),
          const SizedBox(height: 8),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: _inputDecoration(
              hint: 'Ex: 22',
              suffix: const Text(
                'ans',
                style: TextStyle(
                  color: SoftUiColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 16, color: Color(0xFF5B8DEF)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Cela nous aide à te proposer des quêtes adaptées à ta situation.',
                  style: TextStyle(
                    color: Color(0xFF5B8DEF),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: SoftUiColors.muted, fontSize: 14),
      suffix: suffix,
      filled: true,
      fillColor: SoftUiColors.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: SoftUiColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: SoftUiColors.orange, width: 1.6),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: SoftUiColors.ink),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: SoftUiColors.ink,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
