import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typographie officielle `Matt` (Fontfabric).
///
/// ⚠️ Les fichiers TTF ne sont pas encore dans `assets/fonts/` :
/// Flutter retombe sur la police système. Déposer Matt Regular/Medium/Bold/Black
/// puis décommenter le bloc `fonts:` dans `pubspec.yaml`.
abstract final class AppTypography {
  static const String fontFamily = 'Matt';

  static TextStyle _style({
    required FontWeight weight,
    required double size,
    Color color = AppColors.brown,
    double height = 1.35,
    double? letterSpacing,
    FontFeature? feature,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: weight,
      fontSize: size,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontFeatures: feature == null ? null : [feature],
    );
  }

  /// Marque / hero
  static final TextStyle display = _style(
    weight: FontWeight.w900,
    size: 32,
    letterSpacing: -0.5,
    height: 1.15,
  );

  /// Montants (monnaie de l’utilisateur)
  static final TextStyle amount = _style(
    weight: FontWeight.w900,
    size: 28,
    color: AppColors.onPrimary,
    letterSpacing: -0.2,
    feature: const FontFeature.tabularFigures(),
  );

  /// Titres d’écran
  static final TextStyle title = _style(
    weight: FontWeight.w800,
    size: 22,
    height: 1.25,
    letterSpacing: -0.2,
  );

  /// Sous-titres / sections
  static final TextStyle heading = _style(
    weight: FontWeight.w700,
    size: 17,
    height: 1.3,
  );

  /// Bulle mascotte / question
  static final TextStyle speech = _style(
    weight: FontWeight.w800,
    size: 17,
    height: 1.35,
    letterSpacing: -0.15,
  );

  /// Ligne principale d’une carte
  static final TextStyle optionTitle = _style(
    weight: FontWeight.w700,
    size: 15.5,
    height: 1.25,
  );

  /// Description sous une option
  static final TextStyle optionSubtitle = _style(
    weight: FontWeight.w400,
    size: 13,
    color: AppColors.muted,
    height: 1.35,
  );

  static final TextStyle label = _style(weight: FontWeight.w600, size: 14);

  static final TextStyle body = _style(weight: FontWeight.w400, size: 15);

  static final TextStyle caption = _style(
    weight: FontWeight.w500,
    size: 12,
    color: AppColors.muted,
    height: 1.3,
  );

  static final TextStyle button = _style(
    weight: FontWeight.w800,
    size: 16,
    color: AppColors.onPrimary,
    height: 1.2,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: display,
    headlineLarge: title,
    headlineMedium: heading,
    titleMedium: label,
    bodyLarge: body,
    bodyMedium: body,
    labelLarge: button,
    bodySmall: caption,
  );
}
