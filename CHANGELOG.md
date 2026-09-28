# CHANGELOG

## [1.2.0] - 2026-09-27
### Added
- **Web App Feature Parity:** Brought the Next.js web app closer to mobile parity by adding the Parent Dashboard (`/parent`), Scholarships listing (`/scholarships`), Universities listing (`/universities`), Career Explorer (`/career-explorer`), and Profile & Settings (`/profile`) pages, along with a consistent role-aware top navigation bar (`TopNav`).
- **Production Hardening:** Enhanced backend CORS configuration (`ALLOWED_ORIGINS`), improved request logging, hardened health endpoint (`/health`), and updated `.env.example` files across backend, mobile, and web.
- **Documentation:** Updated `README.md` with current web routes, production deployment setup, and production limitations regarding rate limiting and CORS.

## [1.1.0] - 2026-09-27
### Added
- **Counselor Analytics & Linking:** Implemented secure backend endpoints (`/counselor/analytics`, `/counselor-link/generate`, `/counselor-link/redeem`) providing total linked students, average progress %, pathway distribution, quiz completion rates, and attention alerts.
- **Upgraded Mobile Counselor Dashboard:** Upgraded `CounselorDashboardScreen` with real API data, summary metrics cards, student progress tracking, invite code linking, and AsyncStateView loading/error/empty handling.
- **Enhanced Content Seed Data:** Upgraded `database/seed.sql` with accurate real Pakistani universities, realistic scholarships, comprehensive pathway steps, and free learning resources relevant to Pakistan.

## [1.0.0] - 2026-09-26
### Added
- **Parent-Child Linking:** Implemented code-based account linking flow (generate/redeem).
- **Web MVP:** Functional landing, auth, dashboard, quiz, roadmap, and chatbot.
- **Backend Hardening:** Added logging, health endpoint, rate-limiting improvements, and CORS enforcement.
- **Data:** Expanded seeding for Pakistani universities, scholarships, and career paths.

### Fixed
- **Mobile Roadmap:** Restored Home screen to exact Figma specifications.
- **Environment Configuration:** Removed hardcoded assumptions; switched to environment-driven configuration using `--dart-define` and `.env` files.
- **CI/Testing:** Fixed test timeouts and enabled functional test coverage for backend and mobile.

### Changed
- Refactored mobile providers to use `ApiClient` for network-backed data.
