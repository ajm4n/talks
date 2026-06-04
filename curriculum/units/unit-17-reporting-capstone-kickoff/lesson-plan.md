# Unit 17 — Reporting & Professional Communication + Capstone Kickoff

- **Module:** Module 5 — Putting It Together
- **Suggested week:** Week 17
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Report Writing / Assembling the Pieces

> This unit opens Module 5. After 16 weeks of learning *how* to find and demonstrate weaknesses, students now learn the part that pays the bills: **the report**. In professional penetration testing, the client is not buying the hack — they are buying the written report that tells them what is wrong, how bad it is, and how to fix it. A brilliant test with a sloppy report is a failed engagement. This week students learn to write for two audiences (executives and technical staff), to rate risk honestly, and to communicate like a professional. Then we **kick off the capstone**: the CTF challenge they will complete and report on next week. The ethics thread this unit is **accuracy** — never exaggerate a finding to look impressive, and never hide a finding to look polite.

## Learning objectives
By the end of this unit, students can:
- **Explain** why the written report is the real deliverable of a penetration test and what a client actually pays for.
- **Identify and describe** the standard sections of a penetration-test report: executive summary, methodology, findings, remediation/recommendations, and appendices.
- **Write** an executive summary aimed at a non-technical leader, and a technical finding aimed at IT staff, from the same underlying issue.
- **Assign** a severity rating (Low / Medium / High / Critical) to a finding and justify it in terms of likelihood and impact, with awareness of how CVSS produces a score.
- **Document** a finding with evidence (labeled screenshots, commands, affected systems), an impact statement, and specific remediation.
- **Apply** the penetration-test report rubric (in `instructor/grading-and-rubrics.md`) to evaluate and improve a report section.
- **Explain** the ethics of accurate reporting — no exaggeration, no minimizing, no hiding — and why client trust depends on it.
- **Produce** a complete sample report based on a prior unit's lab and receive their capstone target assignment.

## Standards alignment
- **NICE Framework:** Task — prepare assessment reports and document findings (T0048, T0084); communicate results to stakeholders (T0152); Knowledge of report-writing and risk-communication practices (K0624). Work-role exposure: Vulnerability Assessment Analyst, Cyber Defense Analyst.
- **CSTA / state CS standards:** 3A-IC-25 (impact and communication of computing solutions), 3A-NI-05 (security of data), 3B-NI-04 (security risks); plus Common Core writing-for-audience anchors (W.9-12.2, W.9-12.4).
- **Security+ domain(s):** 4.0 (security operations — reporting), 5.0 (governance, risk, communication of risk). Reinforces CVSS/severity awareness.

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Deliverable | The thing a client actually receives and pays for — here, the written report. |
| Penetration-test report | The formal document describing what was tested, what was found, how serious it is, and how to fix it. |
| Executive summary | A short, plain-language overview for busy, non-technical leaders (the "so what" in one page). |
| Methodology | The section explaining *how* the test was done — the phases and approach used. |
| Finding | A single security issue discovered during the test, written up with evidence, severity, and impact. |
| Evidence | Proof a finding is real — labeled screenshots, the commands run, affected hosts/URLs. |
| Severity / risk rating | How serious a finding is, usually Low / Medium / High / Critical. |
| Impact | What could actually go wrong for the organization if the finding is exploited. |
| Likelihood | How easy or probable it is that an attacker exploits the finding. |
| Remediation | The specific, actionable fix recommended for a finding. |
| Recommendation | Broader advice to improve security beyond a single fix. |
| Appendix | Supporting material at the end of the report (raw tool output, full host lists, references). |
| CVSS | Common Vulnerability Scoring System — an industry method that turns factors into a 0–10 severity score. |
| Audience | Who you are writing for; here, executives vs. technical staff need different language. |
| Scope | The agreed boundary of what was authorized to be tested — restated in the report. |
| Accuracy (in reporting) | Reporting findings truthfully — not exaggerated, not minimized, not hidden. |
| Capstone | The end-of-course project: complete a CTF-style target, then report and present on it. |

## Materials & prep
- Student laptops with a word processor or Google Docs / Markdown editor (the report can be written in any of these). No special install required for the writing work.
- Their **lab journals** from earlier units (the recon/OSINT report from Unit 07, the web-vuln writeups from Units 10–12, or the privesc work from Unit 15) — students mine these for a finding to write up.
- Handouts: **Report outline / fill-in template** (provided in `lab.md`); **severity rating quick-guide** (Low/Med/High/Critical with examples); **"two audiences" side-by-side example**; the **report rubric** printed from `instructor/grading-and-rubrics.md`.
- **Capstone kickoff packet:** team assignments, the capstone target list (picoCTF set and/or an authorized TryHackMe beginner room — see Unit 18), the capstone checklist, and due dates.
- **Instructor prep notes:**
  - **Pick the prior lab everyone will report on.** Easiest path: have the whole class write up a finding from a *shared* earlier lab (e.g., the Unit 12 SQL-injection lab or the Unit 07 OSINT report) so you can model and grade consistently. Allow advanced students to choose their own prior finding.
  - **Prepare ONE fully-worked sample finding** (executive summary blurb + technical finding + severity + evidence + remediation) to model on Day 2. Reuse a finding the class already produced so it is familiar.
  - Decide your **severity scale** up front. Keep it simple: a Low/Med/High/Critical scale with a one-line definition each. Introduce CVSS at **awareness level only** — students should know it exists and roughly what feeds it, not compute vectors by hand.
  - **Form capstone teams now** (2–3 students) and pre-assign or let teams pick from the approved target list. Confirm every target is picoCTF or an authorized challenge room — no real or third-party systems, ever.
  - Print or share the report rubric so students grade against the same criteria they'll be graded on.

## ⚖️ Ethics & legal callout
A penetration-test report is a document a client will make real decisions and spend real money on. That makes **accuracy** an ethical duty. Two failures are equally serious: **exaggerating** a finding to make your work look more impressive (scaring a client into wasting money, or crying wolf), and **minimizing or hiding** a finding because it's awkward, you ran out of time, or you like the client. Both betray trust. A professional reports what is true — with evidence — and rates it honestly. You also restate the **scope and authorization** in the report itself: the report is the written record proving the test was authorized and stayed in bounds.

**Discussion prompt:** You found a Critical flaw, but it was *embarrassingly* easy — basically a default password. You worry the client will think the test was "too simple" and not value your work. Are you tempted to dress it up as something more sophisticated, or to downplay it? What does honest reporting require here, and why does the client's safety outrank your ego?

## Lesson sequence

### Day 1 — Why the report is the real product + report anatomy
- **Warm-up (5–10 min):** "A penetration tester spends two weeks brilliantly breaking into a client's network, then hands over a one-paragraph email. Did the client get what they paid for? Why not?" Discuss.
- **Direct instruction (15–20 min):** The big idea — **clients pay for the report, not the hack.** Walk through the anatomy of a pentest report: **executive summary** (for leaders), **methodology** (how we tested), **findings** (each with evidence, severity, impact), **remediation/recommendations** (how to fix), **appendices** (raw output, references). Show a real-shaped (sanitized) sample table of contents.
- **Guided practice (15 min):** Give students a scrambled list of report contents (a screenshot, a CEO-friendly paragraph, raw nmap output, a fix recommendation, a risk rating). As a class, sort each into the correct section.
- **Independent practice / lab:** Begin `lab.md` Part A — choose a prior-unit finding and fill in the basic facts (affected system, what was found).
- **Closure / exit ticket (5 min):** "Name the five main sections of a pentest report and say which one a non-technical CEO reads first."

### Day 2 — Findings, evidence, severity, and CVSS awareness
- **Warm-up (5–10 min):** Show two versions of the same finding — one with a labeled screenshot and exact steps, one that just says "the site is hackable." Which would a developer be able to act on?
- **Direct instruction (15–20 min):** Anatomy of a single **finding**: title, affected asset, **evidence** (labeled screenshots, commands, URLs), **impact** (what an attacker could do), **severity** (Low/Med/High/Critical based on likelihood × impact), and **remediation**. Introduce **CVSS** at awareness level — it exists, it outputs a 0–10 score, and it considers things like how easy the attack is and how much damage it does. Model the instructor's pre-built sample finding end to end.
- **Guided practice (15 min):** Give students three findings (e.g., default admin password, reflected XSS, missing security header) and have pairs assign Low/Med/High/Critical and **justify** each with likelihood and impact. Compare answers; surface disagreements.
- **Independent practice / lab:** Lab Part B — write the **finding(s)** for the chosen issue with evidence and a justified severity.
- **Closure / exit ticket (5 min):** "What three things must every finding include? Rate one example finding and justify it in one sentence."

### Day 3 — Writing for two audiences: executive summary vs technical detail
- **Warm-up (5–10 min):** "Explain SQL injection to (a) your principal and (b) a database administrator. How does the language change?"
- **Direct instruction (15–20 min):** The **two-audience** problem. The **executive summary** is plain-language, risk-focused, and short — no jargon, no commands; it answers "how exposed are we and what should we do?" The **technical findings** are precise, reproducible, and detailed for the staff who will fix them. Show a side-by-side of the same issue written both ways. Stress: same truth, different altitude.
- **Guided practice (15 min):** Students take their Day-2 technical finding and draft a 2–3 sentence executive-summary version of it — no jargon allowed. Peer-swap and flag any jargon that slipped through.
- **Independent practice / lab:** Lab Part C — write the **executive summary** and the **remediation/recommendations** for the report.
- **Closure / exit ticket (5 min):** "Rewrite this technical sentence for a non-technical executive: 'Unsanitized input in the login form permits UNION-based SQL injection.'"

### Day 4 — Assemble the full sample report + peer review with the rubric
- **Warm-up (5–10 min):** Read the **report rubric** aloud (from `instructor/grading-and-rubrics.md`). "Which row do you think you'll lose the most points on, and how will you fix that today?"
- **Direct instruction (10 min):** Professional polish: restate **scope/authorization** in the report, label every screenshot, use consistent terminology, number findings, add an appendix for raw output. Note-taking habit: good reports come from good lab journals — you can only report what you wrote down.
- **Guided practice / independent lab:** Students assemble Parts A–C into one **complete sample report** using the template.
- **Peer review (last 15 min):** Swap reports with a partner and score each other against the **report rubric**; give one "glow" and one "grow." 
- **Closure / exit ticket (5 min):** Hand in the rubric you used to score your partner, with your one glow + one grow.

### Day 5 — Revise & submit + Capstone Kickoff
- **Warm-up (5–10 min):** "What's one change you're making to your report based on yesterday's peer feedback?"
- **Direct instruction / kickoff (20 min):** **Capstone Kickoff.** Reveal the capstone: next week each team will run the **full attack lifecycle** (recon → scan/enumerate → exploit → privilege-escalate → document) against an **authorized** target — a **picoCTF** challenge set and/or an approved beginner TryHackMe room — then write a **full report** (report rubric) and give a **short presentation** (presentation rubric). Hand out team assignments, the **capstone checklist**, the target list, and due dates. Restate the **safety/authorization rule**: capstone targets are picoCTF / approved challenge rooms ONLY.
- **Independent practice / lab:** Finish revising and **submit the sample report**. Teams confirm their target and write their capstone scope statement.
- **Closure / exit ticket (5 min):** Each team submits: target name, team members, and a one-sentence scope/authorization statement.
- **Assessment:** Sample report submitted; unit quiz (`assessment.md`) given end of Day 5 or start of Week 18.

## Differentiation
- **Support:** Provide the **fill-in report template** with section prompts and sentence frames ("This finding matters because an attacker could ___, which would affect ___."). Let students report on a *single* finding rather than several. Provide a word bank for the executive summary and a pre-filled severity guide with worked examples. Pair for peer review. Allow the report in Google Docs rather than Markdown.
- **Extension:** Report on multiple findings of differing severity and build a findings summary table. Research and apply a real **CVSS v3.1 base score** using an online calculator and explain each metric chosen. Write a one-page "remediation roadmap" prioritizing fixes by risk and effort. Critique a published (sanitized) sample pentest report for clarity and honesty.

## Homework / independent work
- Finish/polish the **sample report** if not completed in class.
- Read your assigned capstone target's rules of engagement (picoCTF rules / TryHackMe room intro) and write your team's **scope statement**.
- Short write-up (½ page): "Why is *accuracy* an ethical duty in a pentest report? Give one example of harm from exaggerating a finding and one from hiding a finding."

## Assessment
- **Formative:** Daily exit tickets; the scramble-sort of report sections; the severity-rating pair activity; the executive-summary rewrite; the rubric-based peer review.
- **Summative:** Unit quiz + the **complete sample report** deliverable, graded with the **penetration-test report rubric** in `instructor/grading-and-rubrics.md`. See `assessment.md`.

## Instructor notes & common pitfalls
- **Students undervalue the report** ("the hacking was the fun part"). Counter it early and often: in industry, the report *is* the job. A finding that isn't clearly written and reproducible effectively doesn't exist for the client.
- **Severity inflation is the most common error** — students mark everything "Critical." Force a likelihood × impact justification for every rating, and contrast a Critical (remote code execution, exposed customer data) with a Low (verbose error message). 
- Keep **CVSS awareness-level**. Computing full vectors by hand frustrates beginners; the goal is to know it exists and what feeds it. Save the calculator for the extension task.
- The **executive summary** is the hardest skill — students leak jargon. Enforce a hard "no commands, no acronyms without a plain-language gloss" rule and have peers hunt for jargon.
- **Reports come from notes.** If a student's lab journal was thin earlier in the course, this is where it bites. Use it to motivate good note-taking going into the capstone.
- Tie everything forward: the skills and template here are exactly what teams use for the **capstone report in Unit 18**. The sample report is the dress rehearsal.
- Reinforce **scope/authorization in writing** — the report restates that the test was authorized and in-scope. This is both professional practice and the ethics thread of the whole course.
