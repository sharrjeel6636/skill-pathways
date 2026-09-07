# Skill Pathway Onboarding Screen (Flutter)

A clean, modern, and trustworthy mobile onboarding and language-selection screen for **Skill Pathway**, a career-guidance education platform designed specifically for Pakistani students.

This codebase is crafted as a premium, interactive, Dribbble-style mockup with a 9:16 aspect ratio (390x844 px) in mind.

## 📱 Visual Features
1. **Responsive Device Frame Wrapper:** 
   * When run on **Wide Screens (Web or Desktop)**, the app renders inside a beautifully styled iOS-like smartphone mockup frame with real bezels, status bar info, dynamic island, and home indicator.
   * When run on a **Mobile Device**, it automatically behaves as a fullscreen native app, responding to the exact system boundaries.
2. **Top App Header:** Curved app-bar style section colored in deep teal (`#0B766F`), featuring the warm orange logo circle (`#F5A20B`) and clean `Inter` typography.
3. **Editorial Typography:** Highlights the dark forest green serifs paired with elegant italicized highlights.
4. **Urdu Nastaliq Integration:** Perfectly aligns the right-to-left flowing Nastaliq script using `GoogleFonts.notoNastaliqUrdu` in a warm rust terracotta (`#C05A3E`).
5. **Custom Geometric Vector Graphic:** Overlapping geometric circles with modern multiply blend opacities centered around a custom white card. The card draws a gorgeous vector roadmap with milestone nodes using a high-performance custom `CustomPainter`.
6. **Interactive Language Selection:** Large English and Urdu option cards with custom selected borders, checked indicator state animation, and soft elevation shadows.

---

## 🛠️ Getting Started

### Prerequisites
Make sure you have Flutter installed:
* [Flutter SDK installation guide](https://docs.flutter.dev/get-started/install)

### Setup & Run

1. **Get Dependencies:**
   Run the following command in the project root:
   ```bash
   flutter pub get
   ```

2. **Run the Application:**
   To run on your connected device (or emulator/simulator/chrome):
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
├── pubspec.yaml            # Project dependencies and configurations
├── lib/
│   └── main.dart           # Pure Flutter Onboarding application layout & widgets
```

---

## 🎨 Color Palette & Typography Specifications
* **Deep Teal Header:** `#0B766F`
* **Orange Logo:** `#F5A20B`
* **Warm Cream BG:** `#F9F8F3`
* **Dark Forest Green (Headline):** `#0E382A`
* **Warm Rust Terracotta (Urdu):** `#C05A3E`
* **Balanced Charcoal (Subtext):** `#52615E`
* **English Font:** `Inter` (Sans-serif)
* **English Headline Font:** `Playfair Display` (Serif / Italic)
* **Urdu Font:** `Noto Nastaliq Urdu` (Calligraphy)
