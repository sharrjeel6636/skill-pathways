import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shared_models.dart';
import '../quiz_model.dart';
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
import '../career_explorer_screen.dart';
import '../certifications_tracker_screen.dart';
import '../career_growth_roadmap_screen.dart';
import '../course_detail_screen.dart';
import '../course_listing_screen.dart';
import '../degree_comparison_screen.dart';
import '../field_selection_screen.dart';
import '../inter_guidance_screen.dart';
import '../job_sector_detail_screen.dart';
import '../matric_guidance_screen.dart';
import '../notifications_screen.dart';
import '../parent_chatbot_faq_screen.dart';
import '../resume_interview_prep_screen.dart';
import '../scholarship_info_screen.dart';
import '../university_detail_screen.dart';
import '../university_shortlist_screen.dart';
import '../vocational_path_screen.dart';
import '../screens/skill_gap_analyzer_screen.dart';
import '../screens/template_picker_screen.dart';
import '../screens/linkedin_guide_screen.dart';
import '../screens/questions_list_screen.dart';
import '../providers/skill_gap_provider.dart';
import '../providers/CertificationProvider.dart';
import '../providers/RoadmapProvider.dart';
import '../services/skill_requirement_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => RoleSelectionScreen(
        onContinue: (role) {
          if (role == UserRole.student) {
            context.go('/home');
          } else if (role == UserRole.parent) {
            context.go('/parent-dashboard');
          } else {
            context.go('/counselor-onboarding');
          }
        },
      ),
    ),
    GoRoute(
      path: '/discovery',
      builder: (context, state) => OnboardingScreen(
        onLanguageConfirmed: (lang) => context.go('/home'),
      ),
    ),
    GoRoute(
      path: '/counselor-onboarding',
      builder: (context, state) => const CounselorOnboardingScreen(),
    ),
    GoRoute(
      path: '/counselor-dashboard',
      builder: (context, state) => CounselorDashboardScreen(
        profile: state.extra as CounselorProfile? ??
            CounselorProfile(
              name: 'Counselor',
              institutionName: 'Institute',
              linkedStudentIds: [],
            ),
      ),
    ),
    GoRoute(
      path: '/chatbot',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ChatbotScreen(
          isParentMode: extra?['isParentMode'] ?? false,
          isMockInterview: extra?['isMockInterview'] ?? false,
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/parent-dashboard',
      builder: (context, state) => const ParentDashboardScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/quiz/result',
      builder: (context, state) => QuizResultScreen(
        result: state.extra as QuizResult? ?? QuizResult.mock(),
      ),
    ),
    GoRoute(
      path: '/roadmap',
      builder: (context, state) => const RoadmapScreen(),
    ),
    GoRoute(
      path: '/skill-gap-analyzer',
      builder: (context, state) => ChangeNotifierProvider(
        create: (context) => SkillGapProvider(
          Provider.of<CertificationProvider>(context, listen: false),
          Provider.of<RoadmapProvider>(context, listen: false),
          SkillRequirementService(),
        ),
        child: SkillGapAnalyzerScreen(
          targetRole: state.extra as String? ?? 'Software Engineer',
        ),
      ),
    ),
    GoRoute(
      path: '/career-explorer',
      builder: (context, state) => const CareerExplorerScreen(),
    ),
    GoRoute(
      path: '/certifications-tracker',
      builder: (context, state) => const CertificationsTrackerScreen(),
    ),
    GoRoute(
      path: '/career-growth-roadmap',
      builder: (context, state) => const CareerGrowthRoadmapScreen(),
    ),
    GoRoute(
      path: '/course-detail',
      builder: (context, state) => CourseDetailScreen(
        course: state.extra as CourseDetail,
      ),
    ),
    GoRoute(
      path: '/course-listing',
      builder: (context, state) => const CourseListingScreen(),
    ),
    GoRoute(
      path: '/degree-comparison',
      builder: (context, state) => DegreeComparisonScreen(
        confirmedField: state.extra as String? ?? 'Computer Science',
      ),
    ),
    GoRoute(
      path: '/field-selection',
      builder: (context, state) => FieldSelectionScreen(
        recommendedField: state.extra as String? ?? 'Software Engineering',
      ),
    ),
    GoRoute(
      path: '/inter-guidance',
      builder: (context, state) => const InterGuidanceScreen(),
    ),
    GoRoute(
      path: '/job-sector-detail',
      builder: (context, state) => JobSectorDetailScreen(
        job: state.extra as JobListing,
      ),
    ),
    GoRoute(
      path: '/matric-guidance',
      builder: (context, state) => const MatricGuidanceScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/parent-chatbot-faq',
      builder: (context, state) => const ParentChatbotFaqScreen(),
    ),
    GoRoute(
      path: '/resume-interview-prep',
      builder: (context, state) => ResumeInterviewPrepScreen(),
    ),
    GoRoute(
      path: '/resume-templates',
      builder: (context, state) => const TemplatePickerScreen(),
    ),
    GoRoute(
      path: '/linkedin-guide',
      builder: (context, state) => const LinkedInGuideScreen(),
    ),
    GoRoute(
      path: '/interview-questions',
      builder: (context, state) => const QuestionsListScreen(),
    ),
    GoRoute(
      path: '/scholarship-info',
      builder: (context, state) => const ScholarshipInfoScreen(),
    ),
    GoRoute(
      path: '/university-detail',
      builder: (context, state) => UniversityDetailScreen(
        university: state.extra as UniversityDetail,
      ),
    ),
    GoRoute(
      path: '/university-shortlist',
      builder: (context, state) => const UniversityShortlistScreen(),
    ),
    GoRoute(
      path: '/vocational-path',
      builder: (context, state) => const VocationalPathScreen(),
    ),
  ],
);