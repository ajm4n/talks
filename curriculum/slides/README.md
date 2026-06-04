# Slide Decks

Classroom slide decks for the course, one per unit plus a course-introduction deck. They are written in **[Marp](https://marp.app/)** (Markdown Presentation Ecosystem), so they live in the repo as plain Markdown, version-control cleanly, and export to **HTML, PDF, or PowerPoint (PPTX)**.

## Files
- `00-course-intro.md` — first-day orientation: what the course is, the rules, the ethics/law backbone, how labs work.
- `unit-01.md` … `unit-18.md` — one teaching deck per unit, built from that unit's `lesson-plan.md`.
- `themes/bootstrap.css` — a Bootstrap-inspired Marp theme (Bootstrap 5 palette + system font stack) used by every deck.
- `pdf/` — **pre-rendered PDFs** of all 19 decks, so you can present/print without installing anything.

## Look & feel
All decks use the custom **`bootstrap`** theme (`themes/bootstrap.css`): Bootstrap's primary-blue accents, striped tables, dark rounded code blocks, alert-style callouts, and full-bleed gradient title slides. It uses the system font stack (no web fonts), so it renders identically offline and in headless Chrome.

## How to use / render the slides

> Pre-rendered PDFs already live in `pdf/` — you only need the steps below if you want to **edit and re-render**.

### Option 1 — VS Code (easiest)
1. Install the **"Marp for VS Code"** extension.
2. Register the theme: add this to your settings → `"markdown.marp.themes": ["./curriculum/slides/themes/bootstrap.css"]`.
3. Open any `*.md` deck. Click the preview icon to present, or use the Marp menu to **export** to PDF/PPTX/HTML.

### Option 2 — Marp CLI
```bash
# install once (requires Node.js)
npm install -g @marp-team/marp-cli

# re-render a single deck WITH the bootstrap theme
marp curriculum/slides/unit-03.md --theme-set curriculum/slides/themes/bootstrap.css --pdf

# re-render everything to the pdf/ folder
for f in curriculum/slides/unit-*.md curriculum/slides/00-*.md; do
  marp "$f" --theme-set curriculum/slides/themes/bootstrap.css --pdf \
    -o "curriculum/slides/pdf/$(basename "${f%.md}").pdf"
done
```
> PDF/PPTX export needs a Chrome/Chromium browser. Set `CHROME_PATH` if Marp can't find one.

### Option 3 — present without installing
Paste a deck into the web editor at https://web.marp.app to preview/export.

## Deck conventions
- Each deck opens with a **title slide** and a **learning-objectives** slide.
- Every deck includes an **ethics & authorization** slide (the course's recurring theme).
- A **lab launch** slide points students to that unit's `lab.md`.
- Decks close with a **recap** and an **exit-ticket / discussion** slide.
- Slides are concise (talking points, not paragraphs) — the depth lives in `lesson-plan.md`.
- Speaker notes use Marp's HTML-comment syntax: `<!-- note to the teacher -->`.

> These decks are a teaching aid. The authoritative content is each unit's `lesson-plan.md`, `lab.md`, and `assessment.md`.
