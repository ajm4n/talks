# Unit 18 Lab / Capstone — Full Attack Lifecycle on an Authorized Target

- **Platform:** **picoCTF** (free, browser-based; year-round practice gym at picoctf.org) and/or an **instructor-approved beginner TryHackMe room** (free tier / AttackBox). **Targets = picoCTF and approved challenge rooms ONLY.**
- **Time:** ~4 class periods of hands-on + writing (Days 1–4), presentations Day 5
- **Difficulty:** beginner capstone (synthesizes the whole course)

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment, and **only** against the
**approved capstone target** your instructor assigned — a **picoCTF** challenge set or an
**authorized TryHackMe room**. These targets are legal, isolated, and **built to be
attacked** so you can learn safely. Pointing any of these tools at a real, third-party,
or out-of-scope system — a website, a game server, a classmate's account, *anything*
not on the approved list — is **illegal** under computer-crime laws like the CFAA, even
if you "only look" or "change nothing." Under deadline pressure the temptation to "just
try one more thing" outside scope is real: **don't.** Scope discipline is exactly what
keeps a professional employable. The approved list is the **entire** universe of legal
targets this week. If you are not 100% sure a target is approved, stop and ask your
instructor. Report only what actually happened — no inventing, no exaggerating, no hiding.

## Objectives
- Apply the full attack lifecycle to an authorized target: **recon → scan/enumerate → exploit → privilege-escalate → document.**
- Capture **labeled evidence** (screenshots + exact commands) throughout, in your lab journal.
- Write a complete **penetration-test report** using the Unit 17 template and the report rubric.
- Build and deliver a **3–5 minute team presentation** using the presentation rubric.
- Frame **authorization and impact** explicitly in both the report and the presentation.

## Setup
1. **Read the Safety & authorization reminder above out loud** as a team. Write your team's scope statement at the top of your shared lab journal: *"We are authorized to test only [the approved capstone target our instructor assigned]. No other systems are in scope."*
2. Confirm your **approved target** with your instructor (picoCTF set and/or approved room). Verify accounts/AttackBox work; you may **reset from snapshot** without penalty if something breaks.
3. Open your **lab journal** and the **Unit 17 report template**. Assign roles (lead per phase, evidence/screenshots, report sections), but everyone documents.
4. Open the **capstone checklist** below and check items off as you go.

## Walkthrough — the lifecycle (over Days 1–3)

### Phase 1 — Recon (Day 1)
- Gather what you can about the target: open the room/challenge brief, note in-scope hosts/URLs, identify the goal.
- **Capture:** the scope/RoE, the target details, and your initial observations.

### Phase 2 — Scan / Enumerate (Day 2)
- Discover services, ports, versions, pages, and users as appropriate to the target (e.g., `nmap`, `gobuster`, manual enumeration).
- **Capture:** the exact commands run and labeled screenshots of the key results ("Figure 1: nmap shows port 80 running Apache 2.4.x").

### Phase 3 — Exploit (Day 2–3)
- Use what enumeration revealed to gain a foothold (a vulnerable web input, weak/default credentials, a known public exploit used responsibly). Capture the **flag(s)** the challenge defines.
- **Capture:** the vulnerability, the exact steps/payload, a labeled screenshot of success, and any flag value.

### Phase 4 — Privilege escalation (Day 3)
- If applicable, escalate to higher privileges (e.g., a Linux privesc check, a misconfiguration). **Not every target has a privesc** — if there isn't one, document that honestly.
- **Capture:** the privesc path (or "no privesc available — here's what we checked"), with evidence.

### Phase 5 — Document (Days 3–4)
- Transfer your journal into the **full report** using the Unit 17 template: executive summary, methodology, findings (evidence + justified severity + impact), remediation/recommendations, appendices. Restate scope/authorization.
- **Capture:** the complete report.

### Presentation prep (Day 4) & delivery (Day 5)
- Build a **3–5 slide** deck: (1) target & scope/authorization, (2) methodology/lifecycle, (3) top findings + severity, (4) remediation, (5) what we learned + ethics. Rehearse to time.
- **Deliver** a 3–5 minute team talk on Day 5; peers and instructor score with the **presentation rubric**.

---

## Capstone checklist
- [ ] Team formed; roles assigned; everyone documents
- [ ] Approved target confirmed (picoCTF / approved room — **ONLY**)
- [ ] Scope statement / RoE written at top of journal
- [ ] **Recon** complete + logged
- [ ] **Scan/enumerate** complete + commands & labeled screenshots captured
- [ ] **Exploit** attempted + foothold/flag documented with evidence
- [ ] **Privilege escalation** attempted or honestly documented as none available
- [ ] All evidence labeled (Figure 1, 2, 3…) and tied to exact commands
- [ ] **Full report** drafted: exec summary, methodology, findings (evidence/severity/impact), remediation, appendices
- [ ] Scope/authorization restated in the report
- [ ] Severities justified by likelihood × impact (no inflation)
- [ ] Report self-checked against the **report rubric**
- [ ] **Slides** built (3–5) and rehearsed to time
- [ ] Presentation explicitly frames **authorization and impact**
- [ ] Report + slides submitted; presentation delivered

## Deliverables
- Team **lab journal** covering all attempted phases with labeled evidence.
- A complete **penetration-test report** (graded with the **report rubric** in `instructor/grading-and-rubrics.md`).
- A **3–5 minute team presentation** (graded with the **presentation rubric**).
- (Individual) the **careers research mini-task** and **final course reflection** in `assessment.md`.

## Stretch goals (optional)
- Solve **additional** picoCTF challenges / a harder approved room and write up multiple findings with a **findings summary table**.
- Produce a **CVSS v3.1 base score** for your top finding (online calculator) and explain each metric in plain language.
- Add a one-page **remediation roadmap** prioritizing fixes by risk vs. effort.
- Record a short screen-capture demo of one finding to embed as evidence.
- Start a **portfolio**: publish a sanitized writeup (no real targets) and a home-lab plan.

## Answer key (instructor only)
*(picoCTF and TryHackMe rooms vary; treat this as calibration, not fixed answers.)*
- **Scope/RoE:** every team must name an **approved** target and state scope before touching anything. Any move toward a non-approved target = STOP and re-teach scope immediately; this is the course's central rule.
- **Phase evidence:** full credit = labeled screenshots tied to the exact commands that produced them, for each attempted phase. Re-teach trigger: results with no reproducible command, or "trust me, it worked."
- **Honest dead ends:** a team that documents what they tried and where they got stuck — accurately, with evidence — meets the learning goal. Do **not** penalize fewer flags if documentation and reasoning are strong. Reward accuracy over bravado.
- **Severity:** keep enforcing likelihood × impact justifications; deadline pressure brings back inflation.
- **Report:** grade with the report rubric. Common gaps under time pressure: a too-technical executive summary, vague remediation ("be more secure"), and missing scope restatement.
- **Presentation:** the ethics-framing row is required — the team must explicitly state authorization and the real-world impact of their findings. Keep talks to 3–5 minutes.
- **Resets:** allow snapshot/room resets without penalty; mastery and documentation matter more than first-try success.
- **picoCTF note:** flags follow the `picoCTF{...}` format and serve as proof-of-completion; the *report and presentation* — not the flag count — are the graded deliverables.
