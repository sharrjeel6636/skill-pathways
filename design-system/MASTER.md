# SkillPathways Design System (MASTER.md)

This file defines the core design tokens and UI principles for the SkillPathways project. All Tailwind-based components must adhere to these definitions.

## 1. Color Palette (Tokens)
| Token | Hex | Usage |
| :--- | :--- | :--- |
| `--teal` | `#164B3C` | Primary / Trust |
| `--teal-2` | `#0E362A` | Deep Teal |
| `--amber` | `#E8A33D` | Progress / Action |
| `--rust` | `#B5502F` | Signal / Accent |
| `--sage` | `#8FAE86` | Verified / Status |
| `--sage-soft` | `#DCE7D3` | Backgrounds / Soft states |
| `--paper` | `#F5F2E9` | Main Background |
| `--ink` | `#1E2A22` | Text |
| `--card` | `#FFFFFF` | Card Background |

## 2. Typography
- **Primary Serif**: `Fraunces`
- **Primary Sans-Serif**: `Manrope`
- **Urdu Serif**: `Noto Nastaliq Urdu`

## 3. UI Component Styles
- **Border Radius**: `--radius: 26px` (General)
- **Buttons**:
    - `.btn-primary`: `background: var(--amber)`, `color: var(--teal-2)`, `border-radius: 100px`, `font-family: Manrope`, `font-weight: 800`.
- **Cards**:
    - Background: `--card`
    - Shadow: `0 3px 10px rgba(0,0,0,0.05)` (General) or `0 2px 6px rgba(0,0,0,0.04)` (List Row).
    - Rounded corners: `16px` to `20px` typical.

## 4. UI Principles
- Trust is paramount. Use clear visual feedback for progress (like the ring-chart in the dashboard).
- Use `Paper` (`#F5F2E9`) as the base background.
- Typography should be elegant and readable. Use `Fraunces` for headings/titles and `Manrope` for body text.

---
*Strictly follow this as the UI/UX Pro Max design engine for all future components.*
