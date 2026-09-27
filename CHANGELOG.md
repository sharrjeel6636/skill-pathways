# CHANGELOG

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
