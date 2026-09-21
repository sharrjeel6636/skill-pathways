import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../splash_screen.dart';
import '../home_screen.dart';
import '../auth_screen.dart';
import '../role_selection_screen.dart';
import '../chatbot_screen.dart';
import '../profile_screen.dart';
import '../parent_dashboard_screen.dart';
import '../quiz_screen.dart';
import '../quiz_result_screen.dart';
import '../roadmap_screen.dart';
import '../onboarding_screen.dart';
import '../counselor_onboarding_screen.dart';
import '../counselor_dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/auth', builder: (context, state) => AuthScreen(onSuccess: () => context.go('/role-selection'))),
    GoRoute(path: '/role-selection', builder: (context, state) => RoleSelectionScreen(onContinue: (role) {
      if (role == UserRole.student) context.go('/discovery');
      else if (role == UserRole.parent) context.go('/parent-dashboard');
      else context.go('/counselor-onboarding');
    })),
    GoRoute(path: '/discovery', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/counselor-onboarding', builder: (context, state) => const CounselorOnboardingScreen()),
    GoRoute(path: '/counselor-dashboard', builder: (context, state) => const CounselorDashboardScreen()),
    GoRoute(path: '/chatbot', builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return ChatbotScreen(
        isParentMode: extra?['isParentMode'] ?? false,
        isMockInterview: extra?['isMockInterview'] ?? false,
      );
    }),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/parent-dashboard', builder: (context, state) => const ParentDashboardScreen()),
    GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
    GoRoute(path: '/quiz/result', builder: (context, state) => const QuizResultScreen()),
    GoRoute(path: '/roadmap', builder: (context, state) => const RoadmapScreen()),
  ],
);
