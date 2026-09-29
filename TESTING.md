# Testing Guide & Coverage

## Overview
Skill Pathways maintains automated test suites for both the FastAPI backend (`pytest`) and the Flutter mobile application (`flutter test`).

---

## 1. Running Tests Locally

### Backend (`services/api`)
Requires Python 3.10+.
```bash
cd services/api
pip install -r requirements.txt
pip install pytest httpx
pytest
```

### Mobile App (`apps/mobile/skill_pathway_mobile`)
Requires Flutter SDK (`3.x`).
```bash
cd apps/mobile/skill_pathway_mobile
flutter pub get
flutter test
```

---

## 2. Test Coverage & Scope

### Backend (`pytest`)
- **Health Check (`/health`)**: Validates service status and API version.
- **Public Endpoints**: Verifies data availability for `/pathways`, `/quiz/questions`, `/universities`, `/scholarships`, and `/learning-material`.
- **Authentication & Authorization**: Ensures protected routes reject unexpired / invalid tokens (401 Unauthorized) and enforce ownership checks.
- **Quiz Submission (`/quiz/submit`)**: Tests pathway scoring logic and recommendation output.
- **Rate Limiting**: Validates in-memory sliding window rate limits on the AI chatbot endpoint (429 Too Many Requests).

### Mobile App (`flutter test`)
- **Router Integrity (`router_integrity_test.dart`)**: Scans GoRouter configuration and ensures all primary context navigation paths are registered correctly.
- **Quiz Logic (`quiz_logic_test.dart`)**: Validates quiz scoring and state management.
- **Provider API Tests (`provider_api_test.dart`)**: Tests state providers and data parsing.

---

## 3. Known Gaps in Coverage
- End-to-end (E2E) integration tests with a live Supabase test instance are not yet run in automated CI (mocked responses used instead).
- Widget test coverage is partial; high-priority screens have foundational test scaffolding, but full user flow simulation (e.g. multi-step onboarding wizard) is limited.
