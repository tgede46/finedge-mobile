import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_controller.dart';
import '../../views/accueil/accueil_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/welcome_view.dart';
import '../../views/coach/coach_view.dart';
import '../../views/intro/intro_view.dart';
import '../../views/onboarding/onboarding_view.dart';
import '../../views/profil/profil_view.dart';
import '../../views/sentier/sentier_view.dart';
import '../../views/shell/main_shell_view.dart';
import '../../views/simulateur/simulateur_view.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

GoRouter createAppRouter({required SessionController session}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/accueil',
    refreshListenable: session,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final intro = location == '/intro';
      final welcome = location == '/welcome';
      final login = location == '/login';
      final onboarding = location == '/onboarding';
      final authGate = welcome || login;

      if (session.isOnboarded) {
        if (intro || onboarding || authGate) return '/accueil';
        return null;
      }
      if (!session.hasSeenIntro && !intro) return '/intro';
      if (session.hasSeenIntro && intro) return '/welcome';
      if (!session.isSignedIn) {
        if (authGate) return null;
        return '/welcome';
      }
      if (!onboarding) return '/onboarding';
      return null;
    },
    routes: [
      GoRoute(
        path: '/intro',
        name: 'intro',
        builder: (context, state) => const IntroView(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
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
                path: '/accueil',
                name: 'accueil',
                builder: (context, state) => const AccueilView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lecons',
                name: 'lecons',
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
