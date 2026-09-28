# NAVIGATION_AUDIT.md

## PART 1: Flutter Navigation Reachability Audit

| Reachable screens | Orphaned screens |
| :--- | :--- |
| AuthScreen | ScholarshipInfoScreen |
| CareerExplorerScreen | CareerGrowthRoadmapScreen |
| CertificationsTrackerScreen | |
| ChatbotScreen | |
| CounselorDashboardScreen | |
| CounselorOnboardingScreen | |
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
- **CounselorDashboardScreen & CounselorOnboardingScreen**: Fully reachable via RoleSelectionScreen and counselor role routing.

## PART 2: Backend Auth Audit

### Routes Classification
- **Public**: `/pathways`, `/quiz/questions`, `/learning-material`
- **User-Auth Required**: `/dashboard/{user_id}`, `/quiz/submit`, `/parent-link/*`, `/counselor-link/*`, `/counselor/analytics`, `/chatbot/message`
- **Admin-Only**: `/admin/analytics`

### Backend Audit Summary
- JWT validation middleware implemented (`Depends(get_current_user)`).
- Counselor analytics and linking endpoints securely authenticated and validated.

## PART 3: Summary Report
- **Screens Orphaned Before Fix**: 2 (ScholarshipInfoScreen, CareerGrowthRoadmapScreen)
- **Backend Routes Secured**: All critical student, parent, and counselor endpoints protected.
- **Status**: Navigation graph consolidated. Backend analytics & linking operational.
