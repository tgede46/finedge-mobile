import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';

/// Champ style Duolingo — charte FinEdge (crème / orange).
class DuoOutlineField extends StatelessWidget {
  const DuoOutlineField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.showValid = false,
    this.showError = false,
    this.errorText,
    this.suffix,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool showValid;
  final bool showError;
  final String? errorText;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final borderColor = showError
        ? const Color(0xFFEF4444)
        : SoftUiColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: AppTypography.body.copyWith(
            color: SoftUiColors.ink,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body.copyWith(color: SoftUiColors.muted),
            filled: true,
            fillColor: SoftUiColors.card,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            suffixIcon:
                suffix ??
                (showValid
                    ? const Icon(Icons.check_circle, color: SoftUiColors.orange)
                    : showError
                    ? const Icon(Icons.error, color: Color(0xFFEF4444))
                    : null),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 1.6),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: showError
                    ? const Color(0xFFEF4444)
                    : SoftUiColors.orange,
                width: 2,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: AppTypography.caption.copyWith(
              color: const Color(0xFFEF4444),
            ),
          ),
        ],
      ],
    );
  }
}
