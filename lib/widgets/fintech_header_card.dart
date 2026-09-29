import 'package:flutter/material.dart';

import '../core/theme/app_gradients.dart';

class FintechHeaderCard extends StatelessWidget {
  const FintechHeaderCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.fintech,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}
