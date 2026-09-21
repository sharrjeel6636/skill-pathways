# Schema Notes

This document provides a consolidated view of the database schema and resolves naming inconsistencies found across multiple legacy SQL files.

## Table Inventory

| Table Name | File(s) Defined In | Referenced in API? | Notes |
| :--- | :--- | :--- | :--- |
| `profiles` | `database.sql`, `supabase_schema.sql` | No | |
| `pathways` | `database.sql`, `quiz_schema.sql` | Yes | Canonical name. |
| `pathway_steps` | `database.sql` | Yes | Matches `main.py` query `pathway_steps`. `roadmap_schema.sql` calls this `pathway_nodes`. |
| `user_progress` | `database.sql` | Yes | Matches `main.py` query `user_progress`. `roadmap_schema.sql` calls this `user_node_progress`. |
| `user_pathways` | `database.sql`, `quiz_schema.sql` | Yes | Canonical name. |
| `quiz_questions`| `database.sql`, `quiz_schema.sql` | Yes | Canonical name. |
| `quiz_options` | `database.sql` | Yes | Canonical name. |
| `quiz_answers` | `quiz_schema.sql` | No | |
| `mentors` | `database.sql` | No | |
| `learning_materials` | `content_schema.sql`, `database.sql` | Yes | Canonical name. |
| `reviews` | `database.sql` | No | |
| `opportunities` | `database.sql` | No | |

## Naming Inconsistencies Resolved
- `pathway_nodes` (legacy) → `pathway_steps` (canonical, based on `main.py` queries)
- `user_node_progress` (legacy) → `user_progress` (canonical, based on `main.py` queries)

## Migration Instructions
1. This project uses SQL migration files located in `database/migrations/`.
2. To apply migrations to a Supabase database:
   - Ensure the Supabase CLI is installed.
   - Run `supabase db push`.
3. For local development without CLI:
   - Apply files in `database/migrations/` numerically.
