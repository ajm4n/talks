# Unit 17 Lab — Write a Professional Report Section (Sample Report)

- **Platform:** Any word processor (Google Docs, Microsoft Word) or a Markdown editor. **No attack tools or targets are used in this lab** — you write up findings you *already* produced in an earlier unit (Unit 07 OSINT, Units 10–12 web, or Unit 15 privesc). Browser-only; no install required.
- **Time:** ~4 class periods (Days 1–4), revised and submitted Day 5
- **Difficulty:** intro (writing & communication)

## 🔒 Safety & authorization reminder
You may only run security techniques inside an approved lab environment, and **only**
against the **intentionally vulnerable practice targets** your instructor approves.
This week you are **not** attacking anything new — you are **writing about findings you
already produced in an earlier, authorized lab.** That rule still matters here for two
reasons: (1) the report itself must **restate the scope and authorization** of the
original test — a real report is the written proof the test was permitted and stayed in
bounds; and (2) you must **report only what actually happened**. Do not invent findings,
do not exaggerate, and do not run any new commands against any system to "get a better
screenshot." Reporting truthfully — no inventing, no exaggerating, no hiding — is the
ethical core of this unit. If your old notes are thin, report honestly on what you have.

## Objectives
- Select one real finding from an earlier authorized lab and gather its evidence.
- Fill in a professional report template with all five core sections.
- Write a **finding** that includes evidence, a justified **severity**, and **impact**.
- Write an **executive summary** in plain language for a non-technical leader.
- Write **specific, actionable remediation** for the finding.
- Restate **scope and authorization** in the report.
- Self- and peer-evaluate the report against the penetration-test report rubric, then revise.

## Setup
1. **Read the Safety & authorization reminder above out loud** with your partner. At the top of your report, write the scope statement for the *original* lab: *"This finding comes from an authorized test of [the intentionally vulnerable practice target], performed in [Unit __] with my instructor's permission."*
2. Open your **lab journal** from the unit your instructor assigned (or the unit you chose, if allowed). Find one finding with usable evidence — a labeled screenshot, the commands you ran, the affected URL/host.
3. Open the **report template** below in a new document. You will fill it in across Days 1–4.
4. Have the **penetration-test report rubric** (from `instructor/grading-and-rubrics.md`) next to you. You are graded on exactly those rows.

## Walkthrough

### Part A (Day 1) — Pick a finding and fill in the facts
- From your lab journal, choose **one** finding (advanced students may choose two of different severities).
- In the template, fill in the **Engagement info** and the **finding's basic facts**: a clear title, the affected system/URL, and a one-line description of what was found.
- **Record / produce:** the filled-in header + finding title and affected asset.

### Part B (Day 2) — Write the finding: evidence, severity, impact
- **Evidence:** paste or describe your labeled screenshot(s) and the exact commands/steps so a reader could reproduce the finding. Label every screenshot ("Figure 1: login form accepts `' OR 1=1 --`").
- **Severity:** assign **Low / Medium / High / Critical** using the quick-guide below. **Justify it** in one sentence using *likelihood* (how easy to exploit) and *impact* (how bad if exploited).
- **Impact:** write 1–2 sentences on what an attacker could actually do to the organization.
- **Record / produce:** a complete finding block (title, asset, evidence, severity + justification, impact).

**Severity quick-guide**
| Rating | Rough meaning | Example |
|--------|---------------|---------|
| **Critical** | Easy to exploit AND severe impact (full system / customer data) | Unauthenticated remote code execution; SQL injection dumping the user table |
| **High** | Serious impact, exploit takes some effort or one condition | Stored XSS that steals admin sessions; default admin password on a key system |
| **Medium** | Real risk, limited impact or harder to exploit | Reflected XSS needing a victim to click a crafted link; directory listing exposing config |
| **Low** | Minor; little direct impact | Verbose error message leaking software version; missing security header |

### Part C (Day 3) — Executive summary + remediation
- **Executive summary:** 2–4 sentences for a **non-technical leader**. No commands, no acronyms without a plain-language gloss. Answer: *how exposed are we, and what should we do?*
- **Remediation:** write a **specific, actionable** fix for the finding (e.g., "use parameterized queries for all database calls," not "make it more secure").
- **Record / produce:** the executive summary + remediation section.

### Part D (Day 4) — Assemble, polish, peer-review
- Assemble Parts A–C into one **complete sample report** using the template (all five sections + appendix).
- **Polish:** restate scope/authorization, label every screenshot, number your finding, use consistent terms.
- **Peer review (15 min):** swap with a partner and score each other against the **report rubric**. Give one **glow** (strength) and one **grow** (improvement).
- **Record / produce:** the assembled report + your partner's scored rubric with glow/grow.

### Day 5 — Revise & submit + capstone scope
- Revise your report using the peer feedback, then **submit**.
- With your **capstone team**, confirm your assigned target (picoCTF set / approved TryHackMe room) and write your **capstone scope statement** (one sentence naming the target and stating you are authorized to test only it).

---

## Report template (fill in)

```markdown
# Penetration Test Report — [Target / Lab Name]

**Tester:** [your name]   **Team:** [if applicable]   **Date:** [date]
**Scope & authorization:** This report covers an authorized test of [the approved
practice target], performed in [Unit __] with instructor permission. No systems
outside this scope were tested.

## 1. Executive summary
[2–4 plain-language sentences for a non-technical leader. How exposed are we? What is
the headline risk? What should we do first? No jargon.]

## 2. Methodology
[How you tested, in phases: recon → scanning/enumeration → exploitation →
(post-exploitation) → documentation. 3–6 sentences. Name the tools used.]

## 3. Findings

### Finding 1 — [clear title]
- **Affected system / URL:** [host, IP, or URL]
- **Severity:** [Low / Medium / High / Critical] — *Justification:* [likelihood × impact, one sentence]
- **Evidence:** [labeled screenshot(s) + exact commands/steps to reproduce]
- **Impact:** [what an attacker could do to the organization]

*(Repeat the block for additional findings.)*

## 4. Remediation & recommendations
- **Finding 1 fix:** [specific, actionable fix]
- **Broader recommendation:** [optional bigger-picture advice]

## 5. Appendices
- Appendix A: raw tool output (nmap, gobuster, etc.)
- Appendix B: references (CVE links, OWASP pages, CVSS calculator if used)
```

## Deliverables
- A **complete sample report** (all five sections + at least one fully-written finding with evidence, justified severity, impact, and remediation), graded with the **penetration-test report rubric**.
- The **scored peer-review rubric** you completed for a partner (one glow + one grow).
- Your **capstone scope statement** (team, target, one-sentence authorization statement).

## Stretch goals (optional)
- Write up **multiple findings** of different severities and add a **findings summary table** (number, title, severity).
- Use an online **CVSS v3.1 calculator** to produce a base score for one finding and explain, in plain language, why you chose each metric.
- Add a one-page **remediation roadmap** ordering fixes by risk vs. effort (quick wins first).
- Find a published, **sanitized** sample pentest report online and write a half-page critique of its clarity and honesty.

## Answer key (instructor only)
*(This is a writing lab; "answers" are calibration guidance, not fixed values.)*
- **Part A:** Full credit = a clear, specific finding title (not "the website is bad"), correct affected asset, and the original scope/authorization restated. Watch for students who try to report a finding they never actually produced — redirect them to their journal.
- **Part B — evidence:** A reader should be able to reproduce the finding from what's written. Screenshots must be **labeled**. Commands should be exact. Re-teach trigger: "trust me, it worked" with no evidence.
- **Part B — severity (most common error: inflation):** Force the likelihood × impact justification. Calibration examples: SQLi dumping user data = **Critical/High**; reflected XSS needing a click = **Medium**; verbose error / missing header = **Low**. If everything is "Critical," send them back to the quick-guide and have them contrast their finding with a true Critical.
- **Part C — executive summary (hardest skill):** Enforce **no commands, no un-glossed acronyms.** A good test: could the principal read it and know how worried to be and what to do? Remediation must be **specific** ("use parameterized queries / change the default password / add input validation server-side"), not "be more secure."
- **Part D — peer review:** Both rubrics should be scored on all five rows with a concrete glow and grow. Use this to surface severity disagreements as a class.
- **Day 5:** Every team must have a target from the **approved list only** (picoCTF / authorized room) and a written scope statement before leaving. No real or third-party systems — ever.
- **Ethics check throughout:** flag any sign of invented or exaggerated findings and re-teach the accuracy duty; this directly sets up the honest capstone report in Unit 18.
