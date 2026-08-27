import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';
import '../models/avatar_catalog.dart';

/// Carte avatar style maquette : cercle + label, sélection grise + anneau or.
class AvatarOptionCard extends StatelessWidget {
  const AvatarOptionCard({
    super.key,
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final AvatarSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF0EBE6) : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SoftUiColors.card,
                  border: Border.all(
                    color: selected
                        ? SoftUiColors.orangeDeep
                        : SoftUiColors.border,
                    width: selected ? 2.5 : 1.5,
                  ),
                  boxShadow: selected
                      ? const [
                          BoxShadow(
                            color: Color(0x22E07818),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                child: spec.assetPath != null
                    ? Image.asset(
                        spec.assetPath!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                        errorBuilder: (_, error, stackTrace) => Text(
                          spec.emoji,
                          style: const TextStyle(fontSize: 42),
                        ),
                      )
                    : Text(spec.emoji, style: const TextStyle(fontSize: 42)),
              ),
              const SizedBox(height: 10),
              Text(
                spec.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.optionTitle.copyWith(
                  color: SoftUiColors.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
