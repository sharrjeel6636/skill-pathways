# Counselor Analytics & Linking Documentation

## Overview
The Counselor module in **Skill Pathways** empowers school and college counselors in Pakistan to monitor student progress, track popular career pathway distributions, identify students needing attention, and share guidance announcements.

---

## Available Metrics & Endpoints (`/counselor/analytics`)

Secured via Bearer token authentication (`Depends(get_current_user)`).

### Metrics Provided:
1. **Total Linked Students (`total_students`)**: Count of students successfully linked to the counselor via invite codes.
2. **Average Progress Percentage (`average_progress_percent`)**: Mean completion percentage across all linked student roadmaps.
3. **Pathway Distribution (`pathway_distribution`)**: Breakdown of popular pathways chosen by linked students (e.g., Pre-Engineering, Computer Science / IT, Pre-Medical, Business/Commerce).
4. **Quiz Completion Rate (`quiz_completion_rate`)**: Percentage of linked students who have completed the initial aptitude and interest quiz.
5. **Students Needing Attention (`students_needing_attention`)**: List of students whose progress is below 30% or who have been inactive.
6. **Detailed Student List (`students`)**: Individual student profiles showing name, email, current pathway, progress percentage, completed steps, and status (`on-track` or `needs-attention`).

---

## Counselor Linking Flows

- **Student Invite Code Generation**: `POST /counselor-link/generate` (generates a 24-hour secure invite code for a student).
- **Code Redemption**: `POST /counselor-link/redeem` (links a student account to the counselor profile upon code entry).
