# Skill Pathway

Skill Pathway is an educational guidance platform designed to empower Pakistani students from matriculation through their early careers, while also providing valuable insights for parents and school counselors.

## Tech Stack

- **Mobile:** Flutter (Dart SDK >=3.0.0), Supabase (Auth + Postgres), Gemini API (Chatbot)
- **Backend:** FastAPI (Python), Supabase (Postgres + Auth), google-genai
- **Web:** Next.js
- **Database:** Supabase/Postgres

## Repo Structure

- `apps/mobile/`: Flutter application for students and parents.
- `apps/web/`: Next.js web interface (placeholder/limited).
- `services/api/`: FastAPI backend for API endpoints.
- `database/`: Schema migrations and seed data.
- `LICENSE.txt`: Project license.
- `CONTRIBUTING.md`: Contributing guidelines.

## Setup Instructions

### Backend
1. Create `services/api/.env` with the following variables:
   - `SUPABASE_URL`
   - `SUPABASE_KEY`
   - `GEMINI_API_KEY`
2. Install dependencies: `pip install -r requirements.txt`
3. Run: `uvicorn main:app --reload` (port 8000)

### Mobile
1. Flutter SDK (>=3.0.0)
2. Supabase config: `flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
3. `flutter pub get`

### Database
1. Run migrations in `database/migrations/`.

## Features

### Implemented
- User Authentication (Supabase)
- Pathway Selection & Progress Tracking
- AI-powered Career Guidance Chatbot (Gemini)
- Parent Dashboard

### Planned
- Advanced Counselor Analytics
- Scholarship Search Optimization

## License
Licensed under the [MIT License](LICENSE.txt).

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md).
