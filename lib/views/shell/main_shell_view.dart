import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/finedge_bottom_nav.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: FinedgeBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
