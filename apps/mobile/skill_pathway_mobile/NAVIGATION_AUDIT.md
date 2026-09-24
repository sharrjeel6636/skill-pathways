# Navigation Audit

## Summary
The application currently uses `go_router` for routing. This audit reviewed screen reachability and addressed orphaned routes.

## Screens Overview
| Screen File | Route Path | Reachable | Entry Points |
| :--- | :--- | :--- | :--- |
| `auth_screen.dart` | `/auth` | Yes | App Start |
| `career_explorer_screen.dart` | `/career-explorer` | TBD | TBD |
| `career_growth_roadmap_screen.dart` | `/career-growth-roadmap` | Yes | JobSectorDetail, ProfileScreen |
| `certifications_tracker_screen.dart` | `/certifications-tracker` | TBD | TBD |
| `chatbot_screen.dart` | `/chatbot` | TBD | TBD |
| `counselor_dashboard_screen.dart` | `/counselor-dashboard` | TBD | TBD |
| `counselor_onboarding_screen.dart` | `/counselor-onboarding` | TBD | TBD |
| `course_detail_screen.dart` | `/course-detail` | TBD | TBD |
| `course_listing_screen.dart` | `/course-listing` | TBD | TBD |
| `degree_comparison_screen.dart` | `/degree-comparison` | TBD | TBD |
| `field_selection_screen.dart` | `/field-selection` | TBD | TBD |
| `home_screen.dart` | `/home` | Yes | Auth Success |
| `inter_guidance_screen.dart` | `/inter-guidance` | TBD | TBD |
| `job_sector_detail_screen.dart` | `/job-sector-detail` | TBD | TBD |
| `linkedin_guide_screen.dart` | `/linkedin-guide` | Yes | ResumeInterviewPrepScreen |
| `matric_guidance_screen.dart` | `/matric-guidance` | TBD | TBD |
| `notifications_screen.dart` | `/notifications` | TBD | TBD |
| `onboarding_screen.dart` | `/discovery` | TBD | TBD |
| `parent_chatbot_faq_screen.dart` | `/parent-chatbot-faq` | TBD | TBD |
| `parent_dashboard_screen.dart` | `/parent-dashboard` | TBD | TBD |
| `profile_screen.dart` | `/profile` | TBD | TBD |
| `questions_list_screen.dart` | `/interview-questions` | Yes | ResumeInterviewPrepScreen |
| `quiz_result_screen.dart` | `/quiz/result` | TBD | TBD |
| `quiz_screen.dart` | `/quiz` | TBD | TBD |
| `resume_interview_prep_screen.dart` | `/resume-interview-prep` | TBD | TBD |
| `roadmap_screen.dart` | `/roadmap` | TBD | TBD |
| `role_selection_screen.dart` | `/role-selection` | TBD | TBD |
| `scholarship_info_screen.dart` | `/scholarship-info` | Yes | HomeScreen, ParentDashboardScreen |
| `splash_screen.dart` | `/splash` | Yes | App Start |
| `template_picker_screen.dart` | `/resume-templates` | Yes | ResumeInterviewPrepScreen |
| `university_detail_screen.dart` | `/university-detail` | TBD | TBD |
| `university_shortlist_screen.dart` | `/university-shortlist` | TBD | TBD |
| `vocational_path_screen.dart` | `/vocational-path` | TBD | TBD |

## Actions Taken
- **ScholarshipInfoScreen**: Added to `HomeScreen` and `ParentDashboardScreen`.
- **CareerGrowthRoadmapScreen**: Refactored to make role optional (default 'student'), added to `JobSectorDetailScreen` and `ProfileScreen`.
- **Resume & Interview Prep Navigation**: Implemented navigation to `/resume-templates`, `/linkedin-guide`, and `/interview-questions` from `ResumeInterviewPrepScreen`.

## Remaining Known Issues
- Several screens are still marked as "TBD" for reachability. A further audit is recommended to ensure complete coverage.
