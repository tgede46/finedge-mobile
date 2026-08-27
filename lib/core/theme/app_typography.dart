import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typographie officielle `Matt` (Fontfabric).
///
/// Déposer les fichiers sous `assets/fonts/` puis les déclarer dans
/// `pubspec.yaml` :
/// - Matt-Regular.ttf (400)
/// - Matt-Medium.ttf (500)
/// - Matt-Bold.ttf (700)
/// - Matt-Black.ttf (900)
///
/// Tant que les fichiers ne sont pas présents, Flutter retombe sur la
/// police système tout en conservant graisses et tailles.
abstract final class AppTypography {
  static const String fontFamily = 'Matt';

  static TextStyle _style({
    required FontWeight weight,
    required double size,
    Color color = AppColors.brown,
    double height = 1.3,
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

  static final TextStyle display = _style(
    weight: FontWeight.w900,
    size: 32,
    letterSpacing: -0.4,
  );

  static final TextStyle amount = _style(
    weight: FontWeight.w900,
    size: 28,
    color: AppColors.onPrimary,
    letterSpacing: -0.2,
    feature: const FontFeature.tabularFigures(),
  );

  static final TextStyle title = _style(weight: FontWeight.w700, size: 22);

  static final TextStyle heading = _style(weight: FontWeight.w700, size: 18);

  static final TextStyle label = _style(weight: FontWeight.w500, size: 14);

  static final TextStyle body = _style(weight: FontWeight.w400, size: 15);

  static final TextStyle caption = _style(
    weight: FontWeight.w400,
    size: 12,
    color: AppColors.muted,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: display,
    headlineLarge: title,
    headlineMedium: heading,
    titleMedium: label,
    bodyLarge: body,
    bodyMedium: body,
    labelLarge: label,
    bodySmall: caption,
  );
}
