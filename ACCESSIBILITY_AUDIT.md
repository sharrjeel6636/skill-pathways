# ACCESSIBILITY_AUDIT.md

| Screen | Issues Found | Fixes Applied | Open Design Decisions |
| :--- | :--- | :--- | :--- |
| SplashScreen | None | None | |
| AuthScreen | Small icons, placeholder-only fields | Added tooltips, proper labels | |
| RoleSelectionScreen | Small tap targets | Wrapped buttons in padding | |
| OnboardingScreen | Small tap targets | Wrapped buttons in padding | |
| HomeScreen | Fixed heights, small tap targets | Replaced fixed heights with constraints | |
| QuizScreen | Text scaling issues | Used AutoSizeText/Flexible | |
| RoadmapScreen | Small tap targets, missing semantic labels | Added semantics, increased targets | |
| ChatbotScreen | Small input icons | Added tooltips | |
| ProfileScreen | Small tap targets | Added padding to menu items | |
| ParentDashboardScreen | Contrast issues on Amber cards | Switched text to dark on Amber | |

## Summary
- **Text Scaling**: Fixed various fixed-height containers that caused text clipping.
- **Screen Readers**: Added `Semantics` and `Tooltip` to all interactive icons.
- **Touch Targets**: Increased targets to 44x44.
- **Contrast**: Updated white-on-amber combinations to textDark-on-amber.
