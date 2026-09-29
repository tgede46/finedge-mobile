import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Dégradé signature Fintech : #FF6B00 → #7B3E19.
abstract final class AppGradients {
  static const LinearGradient fintech = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gradientStart, AppColors.gradientEnd],
  );
}
