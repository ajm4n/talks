# Slide Decks

Classroom slide decks for the course, one per unit plus a course-introduction deck. They are written in **[Marp](https://marp.app/)** (Markdown Presentation Ecosystem), so they live in the repo as plain Markdown, version-control cleanly, and export to **HTML, PDF, or PowerPoint (PPTX)**.

## Files
- `00-course-intro.md` — first-day orientation: what the course is, the rules, the ethics/law backbone, how labs work.
- `unit-01.md` … `unit-18.md` — one teaching deck per unit, built from that unit's `lesson-plan.md`.

## How to use / render the slides

### Option 1 — VS Code (easiest)
1. Install the **"Marp for VS Code"** extension.
2. Open any `*.md` deck in this folder.
3. Click the preview icon to present, or use the Marp menu to **export** to PDF/PPTX/HTML.

### Option 2 — Marp CLI
```bash
# install once (requires Node.js)
npm install -g @marp-team/marp-cli

# export a single deck
marp curriculum/slides/unit-03.md --pdf      # or --pptx / --html

# export everything
marp curriculum/slides/ --pdf
```

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
