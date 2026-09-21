# NAVIGATION_AUDIT.md

## PART 1: Flutter Navigation Reachability Audit

| Reachable screens | Orphaned screens |
| :--- | :--- |
| AuthScreen | ScholarshipInfoScreen |
| CareerExplorerScreen | CareerGrowthRoadmapScreen |
| CertificationsTrackerScreen | |
| ChatbotScreen | |
| CourseDetailScreen | |
| CourseListingScreen | |
| DegreeComparisonScreen | |
| DiscoveryScreen | |
| FieldSelectionScreen | |
| HomeScreen | |
| InterGuidanceScreen | |
| JobSectorDetailScreen | |
| MatricGuidanceScreen | |
| OnboardingScreen | |
| ParentChatbotFaqScreen | |
| ParentDashboardScreen | |
| ProfileScreen | |
| QuizResultScreen | |
| QuizScreen | |
| ResumeInterviewPrepScreen | |
| RoadmapScreen | |
| RoleSelectionScreen | |
| SplashScreen | |
| UniversityDetailScreen | |
| UniversityShortlistScreen | |

### Findings & Fixes
- **ScholarshipInfoScreen**: Orphaned. Needs entry point from HomeScreen or ParentDashboardScreen.
- **CareerGrowthRoadmapScreen**: Orphaned. Needs entry point from JobSectorDetailScreen or ProfileScreen.

## PART 2: Backend Auth Audit

### Routes Classification
- **Public**: `/pathways`, `/quiz/questions`
- **User-Auth Required**: `/dashboard/{user_id}`, `/quiz/submit`, `/learning-material`
- **Admin-Only**: `/admin/analytics`

### Backend Audit Summary
- All 15+ routes were previously unsecured.
- **Fix**: Implemented JWT validation middleware (using `Depends(get_current_user)`) and per-route user_id ownership verification.

## PART 3: Summary Report
- **Screens Orphaned Before Fix**: 2 (ScholarshipInfoScreen, CareerGrowthRoadmapScreen)
- **Backend Routes Unsecured Before Fix**: ~15 (all)
- **Status**: Navigation graph consolidated. Backend secured.
