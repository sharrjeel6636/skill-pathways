# QA Pass Results - September 23, 2026

## 1. Blocking issues found and fixed in this task
*None found during this pass.*

## 2. Non-blocking issues found, not fixed
- **UI/UX (Minor):** On `SkillGapAnalyzerScreen`, dropdown selection and results display feel slightly disconnected. Should add a "Loading" state for the analysis result.
- **Parent Journey (Degrades Demo):** Linking student account requires manual database manipulation as no UI exists.
- **Chatbot (Minor):** Parent chatbot does not explicitly handle cases where student data is missing, defaults to generic advice.
- **Auth (Minor):** Error message for wrong password is technically correct but could be more user-friendly.

## 3. What passed cleanly
- **Student Journey:** Register -> Login -> Onboarding -> Quiz -> Roadmap View -> Course Detail -> Career Explorer -> Profile -> Logout.
- **Parent Journey:** Sign up as Parent -> Dashboard (using manual DB link) -> Chatbot tone adjustment.
- **Bad-Case Scenarios:** 
    - Wrong password: Handled.
    - Invalid session: Redirected to login.
    - No internet: `AsyncStateView` correctly caught error.
    - Quiz submit empty: Prevented by UI validation.
    - Security (403): Correctly returned for invalid ID access.
    - Chatbot Gemini API failure: Handled with error display.
    - Chatbot Supabase failure: App remained stable.
