import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../views/coach/coach_view.dart';
import '../../views/onboarding/onboarding_view.dart';
import '../../views/profil/profil_view.dart';
import '../../views/sentier/sentier_view.dart';
import '../../views/shell/main_shell_view.dart';
import '../../views/simulateur/simulateur_view.dart';
import '../../controllers/session_controller.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

GoRouter createAppRouter({required SessionController session}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/sentier',
    refreshListenable: session,
    redirect: (context, state) {
      final onboarding = state.matchedLocation == '/onboarding';
      if (!session.isOnboarded && !onboarding) return '/onboarding';
      if (session.isOnboarded && onboarding) return '/sentier';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sentier',
                name: 'sentier',
                builder: (context, state) => const SentierView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/simulateur',
                name: 'simulateur',
                builder: (context, state) => const SimulateurView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/coach',
                name: 'coach',
                builder: (context, state) => const CoachView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profil',
                name: 'profil',
                builder: (context, state) => const ProfilView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
