import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Color(0xFF4285F4),
            height: 1,
          ),
        ),
      ),
    );
  }
}

class AppleMark extends StatelessWidget {
  const AppleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.apple, size: 22, color: AppColors.brown);
  }
}
