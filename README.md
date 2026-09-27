# Skill Pathway

Skill Pathway is a career and education guidance platform for Pakistani students — from Matric through Intermediate, university selection, skill-building, and into their first job — with dedicated views for parents and school counselors who support them along the way.

The core idea: most students in Pakistan make life-defining decisions (which subjects to pick, which entry test to prepare for, which degree leads where) with very little structured guidance. Skill Pathway gives them a personalized roadmap, an AI chatbot for judgment-free questions, and real information on universities, scholarships, and career paths — in a bilingual (English/Urdu) interface.

---

## Tech Stack

- **Mobile app:** Flutter (Dart SDK `>=3.0.0 <4.0.0`), state managed with `provider`, navigation with `go_router`, Supabase for auth, Google Gemini for the AI chatbot
- **Backend API:** FastAPI (Python), Supabase (Postgres + Auth) as the data layer, `google-genai` for chatbot responses
- **Web app:** Next.js (App Router), Tailwind CSS, Supabase JS client — early-stage, see [Web App Status](#web-app-status) below
- **Database:** Supabase/Postgres, with versioned migrations under `database/migrations/`

---

## Repo Structure

```
skill-pathways/
├── apps/
│   ├── mobile/skill_pathway_mobile/   # Flutter app (primary product surface)
│   └── web/                            # Next.js web app (early-stage, see status below)
├── services/
│   └── api/                            # FastAPI backend
├── database/
│   ├── migrations/                     # Versioned schema migrations
│   ├── seed.sql / seed_skills.sql      # Seed data for local development
│   └── SCHEMA_NOTES.md                 # Schema documentation
├── design-system/                      # Shared design reference material
├── .github/workflows/ci.yml            # CI: flutter analyze + flutter test + pytest
├── NAVIGATION_AUDIT.md                 # Screen-reachability audit and history
├── ASYNC_STATE_AUDIT.md                # Loading/error/empty state coverage audit
├── ACCESSIBILITY_AUDIT.md              # Accessibility pass findings
├── QA_PASS_RESULTS.md                  # Manual end-to-end QA findings
└── CHANGELOG.md                        # Notable changes by task/session
```

---

## Architecture Overview

```
Flutter mobile app ──┐
                      ├──► FastAPI backend ──► Supabase (Postgres + Auth)
Next.js web app ──────┘         │
                                 └──► Google Gemini (chatbot responses)
```

Both the mobile and web clients talk to the same FastAPI backend over HTTP, authenticating with a Supabase-issued JWT sent as `Authorization: Bearer <token>`. The backend verifies that token against Supabase on every protected request and checks that the requesting user actually owns the data they're asking for (see `get_current_user` / `verify_user_access` in `services/api/main.py`).

---

## Setup Instructions

### Backend (`services/api`)

1. Create `services/api/.env` with:
   ```
   SUPABASE_URL=your-supabase-project-url
   SUPABASE_KEY=your-supabase-service-or-anon-key
   GEMINI_API_KEY=your-gemini-api-key
   ```
2. Install dependencies:
   ```
   pip install -r requirements.txt
   ```
3. Run the server:
   ```
   uvicorn main:app --reload
   ```
   Listens on `http://localhost:8000` by default.

### Mobile (`apps/mobile/skill_pathway_mobile`)

1. Flutter SDK `>=3.0.0` installed.
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app, providing environment variables at runtime:
   
   - **Android Emulator:**
     ```
     flutter run -d emulator-5554 --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... --dart-define=API_BASE_URL=http://10.0.2.2:8000
     ```
   - **iOS Simulator:**
     ```
     flutter run -d <device-id> --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... --dart-define=API_BASE_URL=http://127.0.0.1:8000
     ```
   - **Physical Device (on same LAN):**
     Replace `YOUR_LAN_IP` with your machine's IP (e.g., `192.168.1.5`):
     ```
     flutter run -d <device-id> --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... --dart-define=API_BASE_URL=http://YOUR_LAN_IP:8000
     ```

### Web (`apps/web`)

1. Copy `apps/web/.env.local.example` to `.env.local` and fill in:
   ```
   NEXT_PUBLIC_SUPABASE_URL=...
   NEXT_PUBLIC_SUPABASE_ANON_KEY=...
   NEXT_PUBLIC_API_URL=http://localhost:8000
   ```
2. Install and run:
   ```
   cd apps/web
   npm install
   npm run dev
   ```

### Database

Migrations live in `database/migrations/`, applied in numeric order. 

To re-seed the database locally:
1. Ensure the database is running.
2. Apply migrations (if not already applied):
   ```
   # Using Supabase CLI (if configured)
   supabase db push
   
   # Or manually apply scripts in numeric order
   psql -d <db_name> -f database/migrations/000001_initial_schema.sql
   psql -d <db_name> -f database/migrations/000002_rls_indexes_and_improvements.sql
   psql -d <db_name> -f database/migrations/000003_add_skill_tables.sql
   psql -d <db_name> -f database/migrations/000004_add_parent_links.sql
   psql -d <db_name> -f database/migrations/000005_add_edu_tables.sql
   ```
3. Run seed scripts:
   ```
   psql -d <db_name> -f database/seed.sql
   psql -d <db_name> -f database/seed_skills.sql
   ```
See `database/SCHEMA_NOTES.md` for table-by-table documentation.

---

## Features

### Implemented (Mobile — primary product surface)

The Flutter app has 27+ screens covering the full student and parent journey:

- **Onboarding & Auth:** Splash, Language selection, Login/Signup (Supabase auth), Role selection (Student/Parent/Counselor), profile setup
- **Core navigation:** Home dashboard, full Roadmap timeline with per-stage detail, Chatbot, Profile/Settings, in-app Notifications
- **Assessment:** Aptitude/interest quiz with scored results, Subject/field selection (Science/Arts/Commerce/Vocational)
- **Education path guidance:** Matric-stage guidance, Intermediate-stage guidance with entry test info, degree comparison, university shortlist and detail views, scholarship information, a dedicated Vocational/TEVTA training path
- **Skill building:** Course listing and detail views, certifications progress tracker
- **Career & job prep:** Career/job explorer with sector filters, job/sector detail, resume & interview prep tools, post-job career growth roadmap
- **AI Skill Gap Analyzer:** compares a student's current skills against a target role's requirements and surfaces missing skills with a recommended learning order
- **Parent-specific:** Parent dashboard with a linked child's real progress, parent-mode chatbot/FAQ
- **Counselor-specific:** Counselor onboarding and dashboard, read-only view of linked students' progress

### Implemented (Backend)

- Real Supabase JWT authentication on every protected endpoint, with per-request ownership verification (a user cannot read or modify another user's data)
- Endpoints for pathways/pathway steps, quiz questions/submission, dashboard summary, learning material, skill-gap analysis, and the AI chatbot
- Chatbot supports distinct conversational modes (student / parent / mock-interview) with context-aware prompting
- Basic in-memory rate limiting on the chatbot endpoint

### Implemented (Testing & CI)

- `flutter analyze` + `flutter test` (mobile) and `pytest` (backend) run automatically on every push/PR via GitHub Actions (`.github/workflows/ci.yml`)
- A router-integrity test guards against a known past failure mode: screens or navigation paths that reference an undefined route

### Web App Status

The Next.js web app is now functional as an MVP, covering all required routes:
- `/`: Language Selection
- `/login`: Supabase Authentication
- `/dashboard`: Student Dashboard (API-backed)
- `/quiz`: Aptitude Quiz
- `/roadmap`: Personalized Pathway Steps
- `/chatbot`: AI Guidance Assistant (API-backed)

The web app is now aligned with the mobile core flows for these features, using shared design tokens and authenticated API communication.

### Known Limitations

Being upfront about the current gaps rather than overselling them:

- **Rate limiting** is in-memory only — it resets on server restart and won't work correctly across multiple backend instances. Fine for a single-instance dev/demo deployment, not production-scale.
- **CORS** is currently configured for local development origins; update it before deploying the web app to a real domain.
- **No admin dashboard UI** yet — a couple of admin-facing operations exist as raw API endpoints only.
- **Automated test coverage is still shallow** relative to the app's surface area — CI catches real regressions in navigation/routing and core quiz logic, but most screens don't yet have dedicated tests.
- **Offline support is minimal** — the app expects network connectivity for most data; only limited local caching exists.
- Some content (universities, scholarships, courses) is seeded example data rather than a fully researched, continuously-updated real dataset.

### Planned

- Deeper counselor analytics
- Broader real-world content coverage (more universities, scholarships, and courses across all provinces)
- Production-grade rate limiting and an admin dashboard UI
- Web app parity with the mobile app's feature depth

---

## Environment Variables Reference

| Variable | Used by | Purpose |
|---|---|---|
| `SUPABASE_URL` | Backend | Supabase project URL |
| `SUPABASE_KEY` | Backend | Supabase service/anon key |
| `GEMINI_API_KEY` | Backend | Google Gemini API key for the chatbot |
| `SUPABASE_URL` / `SUPABASE_ANON_KEY` | Mobile (via `--dart-define`) | Supabase client config |
| `NEXT_PUBLIC_SUPABASE_URL` | Web | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Web | Supabase anon key |
| `NEXT_PUBLIC_API_URL` | Web | Backend base URL |

None of these should ever be committed with real values — `.env`, `.env.local`, and any Flutter secrets file are gitignored. If you ever find a real key committed to this public repo, rotate it immediately and flag it in an issue.

---

## API Endpoints (Backend Overview)

| Endpoint | Purpose |
|---|---|
| `GET /pathways` | List available education/career pathways |
| `GET /pathways/{pathway_id}/steps` | Steps within a specific pathway |
| `GET /quiz/questions` | Fetch aptitude quiz questions and options |
| `POST /quiz/submit` | Submit quiz answers, get a recommended pathway |
| `GET /dashboard/{user_id}` | A student's dashboard summary (progress, next step) |
| `GET /user/{user_id}/skills` | A user's recorded skills |
| `GET /skill-gap-analysis/{user_id}` | Skill gap analysis against a target role |
| `GET /learning-material` | Course/learning content listing |
| `POST /chatbot/message` | Send a message to the AI guidance chatbot |

All endpoints that touch user-specific data require a valid `Authorization: Bearer <token>` header and verify the token's user matches the requested resource.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). In short: any change claiming to be "done" should include verification evidence (test output, a description of what was manually checked, screenshots where relevant) — this project has learned the hard way that a checklist without evidence isn't reliable.

## License

Licensed under the [MIT License](LICENSE.txt).
