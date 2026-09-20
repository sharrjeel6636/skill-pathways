# Skill Pathways

**Career guidance platform for students & young professionals**

Personalized skill pathways • Verified learning resources • AI mentorship • Deadline tracking • Peer community

Built for Pakistani students (Matric → Intermediate → University → Career)

---

## Overview

Skill Pathways helps students who feel lost between too much advice and not enough clear direction.  
The goal is simple: **turn “I don’t know what path to take” into a visible, trustworthy path** — one unlocked step at a time.

### Key Features

- **Personalized Roadmaps** — From Matric to Career with clear stages
- **Aptitude & Interest Quiz** — Discover suitable fields
- **AI Career Mentor** — Context-aware chatbot (Student / Parent / Mock Interview modes)
- **University & Scholarship Info** — Pakistan-focused (HEC, MDCAT, ECAT, NUST NET, local scholarships)
- **Parent Dashboard** — Track child’s progress
- **Counselor Support** — For teachers and school counselors
- **Verified Learning Resources** — Curated courses, articles & materials
- **Multi-language** — English + Urdu support

---

## Tech Stack

| Layer       | Technology              |
|-------------|-------------------------|
| Mobile      | Flutter                 |
| Web         | Next.js + Tailwind CSS  |
| Backend     | FastAPI (Python)        |
| Database    | Supabase (PostgreSQL)   |
| Auth        | Supabase Auth           |
| AI          | Google Gemini           |
| Monorepo    | npm workspaces          |

---

## Project Structure

```text
skill-pathways/
├── apps/
│   ├── mobile/          # Flutter app
│   └── web/             # Next.js web app
├── services/
│   └── api/             # FastAPI backend
├── design-system/       # Design tokens & guidelines
└── *.sql                # Database schemas
