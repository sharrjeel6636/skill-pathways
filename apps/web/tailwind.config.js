/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    // Tailwind v4 uses @theme in CSS.
    // This config file may be redundant if @tailwindcss/postcss is used as the primary engine.
    extend: {
      fontFamily: {
        sans: ['var(--font-manrope)', 'sans-serif'],
        serif: ['var(--font-fraunces)', 'serif'],
      },
      colors: {
        paper: 'var(--color-paper)',
        ink: 'var(--color-ink)',
        teal: 'var(--color-teal)',
        'teal-2': 'var(--color-teal-2)',
        amber: 'var(--color-amber)',
        rust: 'var(--color-rust)',
        sage: 'var(--color-sage)',
        'sage-soft': 'var(--color-sage-soft)',
        card: 'var(--color-card)',
      },
    },
  },
  plugins: [],
}
