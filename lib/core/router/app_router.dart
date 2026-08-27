import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_controller.dart';
import '../../views/accueil/accueil_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/welcome_view.dart';
import '../../views/coach/coach_view.dart';
import '../../views/intro/intro_view.dart';
import '../../views/lecon/first_lesson_flow_view.dart';
import '../../views/lecon/lesson_complete_view.dart';
import '../../views/lecon/lesson_intro_view.dart';
import '../../views/lecon/streak_goal_view.dart';
import '../../views/lecon/streak_renewal_flow_view.dart';
import '../../views/onboarding/onboarding_view.dart';
import '../../views/profil/profil_view.dart';
import '../../views/sentier/sentier_view.dart';
import '../../views/shell/main_shell_view.dart';
import '../../views/classement/classement_view.dart';

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
      GoRoute(
        path: '/premiere-lecon',
        name: 'premiere-lecon',
        builder: (context, state) => const FirstLessonFlowView(),
      ),
      GoRoute(
        path: '/lecon/:id',
        name: 'lecon',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'besoins_envies';
          return LessonIntroView(lessonId: id);
        },
      ),
      GoRoute(
        path: '/lecon-complete',
        name: 'lecon-complete',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final xp = int.tryParse(state.uri.queryParameters['xp'] ?? '') ?? 125;
          final next = state.uri.queryParameters['next'] ?? '/lecons';
          return LessonCompleteView(xpEarned: xp, nextRoute: next);
        },
      ),
      GoRoute(
        path: '/objectif-serie',
        name: 'objectif-serie',
        builder: (context, state) {
          final renew = state.uri.queryParameters['renew'] == '1';
          if (renew) return const StreakRenewalFlowView();
          return const StreakGoalView();
        },
      ),
      GoRoute(
        path: '/renouvellement-serie',
        name: 'renouvellement-serie',
        builder: (context, state) => const StreakRenewalFlowView(),
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
                path: '/classement',
                name: 'classement',
                builder: (context, state) => const ClassementView(),
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
