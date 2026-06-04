# Unit 18 — Capstone CTF, Presentations & Careers/Certifications

- **Module:** Module 5 — Putting It Together
- **Suggested week:** Week 18
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Assembling the Pieces (challenge labs) + career & certification guidance

> This is the finale. Across the semester students learned each phase of the attack lifecycle in isolation; this week they **put it all together** on one authorized target. Working in teams, they run the full lifecycle — **recon → scan/enumerate → exploit → privilege-escalate → document** — against a **picoCTF** challenge set and/or an approved beginner TryHackMe room, then write the **full report** (using the report rubric and the template they practiced in Unit 17) and give a **short team presentation** (presentation rubric). The week closes the course out: a **careers & certifications wrap-up** so students leave knowing the real paths into this field — and the ethics thread becomes a lifelong commitment: **staying legal and ethical for life.** The single dividing line they learned in Unit 1 — *authorization and scope* — is the same line that will protect their careers.

## Learning objectives
By the end of this unit, students can:
- **Apply** the full attack lifecycle (recon → scan/enumerate → exploit → privilege-escalate → document) to an authorized capstone target.
- **Document** their work in a lab journal and a complete penetration-test report using the report rubric.
- **Present** their findings clearly to an audience, explicitly framing authorization and impact.
- **Describe** major cybersecurity career paths (pentester, SOC analyst, red/blue team, GRC, AppSec, and more) using CyberSeek and the NICE Framework.
- **Sequence** a realistic certification roadmap (Security+ → eJPT/PNPT → OSCP and beyond) and explain what each adds.
- **Identify** competitions (picoCTF, National Cyber League, CyberPatriot) and ways to build a portfolio and home lab.
- **Compare** college and self-study pathways and pick next steps that fit them.
- **Commit** to staying legal and ethical beyond the classroom, and explain why authorization protects their future.

## Standards alignment
- **NICE Framework:** Tasks — conduct authorized penetration testing and document findings (T0028, T0048, T0084); communicate results to stakeholders (T0152). Work-role awareness across the NICE categories (Protect & Defend, Analyze, Securely Provision, Oversee & Govern). Supports CLO 6 (communication) and CLO 7 (career awareness).
- **CSTA / state CS standards:** 3A-IC-24 (evaluate computing careers/impacts), 3A-IC-25 (communicate computing solutions), 3A-NI-05 / 3B-NI-04 (security); Common Core speaking & writing anchors (SL.9-12.4, W.9-12.2).
- **Security+ domain(s):** synthesis across all domains; explicit Security+ awareness as the recommended first certification.

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Capstone | The final project where you apply everything you learned to one authorized target, then report and present. |
| Attack lifecycle | The phases of a test: recon → scan/enumerate → exploit → privilege-escalate → document. |
| CTF (Capture The Flag) | A legal, gamified security challenge where you solve tasks to find hidden "flags." |
| Flag | A token (often `picoCTF{...}` or `flag{...}`) that proves you solved a challenge. |
| Rules of engagement (RoE) | The agreed rules and boundaries for a test — what you may and may not do. |
| SOC analyst | A defender who monitors alerts and responds to threats in a Security Operations Center. |
| Red team | Offensive security — simulates attackers to test defenses. |
| Blue team | Defensive security — detects, responds, and hardens systems. |
| Purple team | Red and blue working together to improve defenses. |
| GRC | Governance, Risk, and Compliance — the policy, risk, and rules side of security. |
| AppSec | Application security — finding and fixing flaws in software/code. |
| CyberSeek | A free tool that maps cybersecurity jobs, demand, and career pathways. |
| NICE Framework | A national catalog of cybersecurity work roles, tasks, and skills. |
| Certification | A credential proving you passed an exam in a skill area (e.g., Security+, OSCP). |
| Security+ | A widely-recognized entry-level security certification — a common first step. |
| OSCP | OffSec Certified Professional — a hands-on offensive certification (the pro version of this course's content). |
| eJPT / PNPT | Beginner-to-intermediate practical pentesting certifications. |
| Home lab | A safe, isolated practice environment you build yourself to keep learning legally. |
| Portfolio | A collection of your work (writeups, lab journals, projects) that shows employers what you can do. |

## Materials & prep
- **Capstone target (approved list ONLY):** **picoCTF** (free, browser-based, year-round practice gym) and/or an **authorized beginner TryHackMe room** your instructor selects. No real, third-party, or out-of-scope systems — ever.
- Student laptops/browsers; Kali/AttackBox or TryHackMe AttackBox as used all semester; **lab journals**; the **report template** from Unit 17; the **report rubric** and **presentation rubric** (`instructor/grading-and-rubrics.md`).
- **Capstone checklist** handout (in `lab.md`); presentation slide template (3–5 slides); careers research worksheet; CyberSeek and NICE links.
- **Instructor prep notes:**
  - **Lock the target list now.** Confirm every team's target is picoCTF or an instructor-approved room. Verify accounts work and you can reset/relaunch. Pick challenges/rooms that exercise multiple lifecycle phases at a beginner level.
  - **Form/confirm teams** (2–3) from Unit 17. Distribute the capstone checklist and the report template up front so teams know the finish line on Day 1.
  - **Time-box the hacking.** Reserve enough of the week for **writing and presenting** — the report and presentation are the graded deliverables, not just flag count. A team that captures fewer flags but documents and presents honestly can still earn top marks.
  - **Pre-load careers content:** open CyberSeek's career pathway and the NICE work-role categories; have certification-roadmap and competition links ready (picoCTF, National Cyber League, CyberPatriot).
  - **Plan presentations:** schedule Day 5 for short (3–5 min) team talks; print the presentation rubric for peer/instructor scoring.
  - Allow **VM/room resets from snapshots without penalty** — mastery and documentation matter more than first-try success.

## ⚖️ Ethics & legal callout
This is the ethics capstone too. The single most important idea of the whole course — **authorization and scope are the only line between a penetration tester and a criminal** — now becomes a *life* rule, not a class rule. Every capstone target is picoCTF or an approved challenge room: legal, isolated, built to be attacked. The same skills, pointed at a real system without **written permission**, are a crime under laws like the CFAA — and would end the very career students are aiming for. Professionals stay employable precisely because they stay in scope, get permission in writing, and disclose responsibly. The presentation rubric explicitly grades whether you frame authorization and impact.

**Discussion prompt:** Imagine it's five years from now and you have real skills. A friend asks you to "just check if my ex's account can be hacked — it'll take you five minutes." Walk through exactly what you say and why. What would saying yes cost you — legally, professionally, and ethically? How is this the same lesson as Day 1 of this course?

## Lesson sequence

### Day 1 — Capstone kickoff & plan; recon begins
- **Warm-up (5–10 min):** "Name the five phases of the attack lifecycle in order." Class recall.
- **Direct instruction (15 min):** Reveal/confirm the capstone. Walk the **capstone checklist** (in `lab.md`) and the deliverables: lab journal + full report + 3–5 min presentation. Restate the **authorization rule**: approved targets ONLY. Teams write their **scope statement / RoE** (target name, "we are authorized to test only this," what's in/out of bounds).
- **Guided practice (10 min):** Teams plan: who leads which phase, where notes live, how they'll capture evidence (labeled screenshots from minute one).
- **Independent practice / lab:** Begin **recon** on the approved target; log everything.
- **Closure / exit ticket (5 min):** Submit team scope statement + the first three things recon revealed.

### Day 2 — Scan/enumerate → exploit
- **Warm-up (5–10 min):** "What's the difference between scanning and enumeration? Give one tool for each."
- **Direct instruction (10 min):** Mini-refresher tying phases together: enumeration findings point to an exploit; capture evidence as you go because **you can only report what you wrote down.**
- **Independent practice / lab:** **Scan/enumerate**, then attempt the **exploit** path on the approved target. Capture labeled screenshots and exact commands in the lab journal.
- **Closure / exit ticket (5 min):** Submit one labeled screenshot + the command that produced it.

### Day 3 — Privilege escalation → finish documenting the test
- **Warm-up (5–10 min):** "Name one Linux privilege-escalation check you'd run first and why."
- **Direct instruction (10 min):** Privilege escalation refresher; reminder that not every box has a privesc — **document what you find honestly**, including dead ends.
- **Independent practice / lab:** Attempt **privilege escalation**; finish capturing all evidence. Begin transferring journal notes into the **report template**.
- **Closure / exit ticket (5 min):** Submit a one-line status: which phases are done, what evidence you have, what's left.

### Day 4 — Write the full report + careers/certifications wrap-up
- **Warm-up (5–10 min):** "Which report rubric row will your team focus on today?"
- **Direct instruction (20 min) — Careers & certifications:** Walk **career paths** (pentester, SOC analyst, red/blue/purple team, GRC, AppSec, incident response, threat intel) using **CyberSeek** and the **NICE Framework** categories. Present the **certification roadmap**: **Security+ → eJPT/PNPT → OSCP and beyond**, and what each proves. Cover **competitions** (picoCTF, National Cyber League, CyberPatriot), **portfolio + home lab** building, and **college vs self-study** (both work; consistency beats either). End on **staying legal & ethical for life.**
- **Independent practice / lab:** Teams **write the full report** (all five sections, evidence, justified severities, remediation) and build their **3–5 slide** presentation. Individuals begin the **careers research mini-task** (`assessment.md`).
- **Closure / exit ticket (5 min):** "Name one career path and one certification that interest you, and your honest next step after this class."

### Day 5 — Presentations + course reflection
- **Warm-up (5 min):** Quick presentation logistics + read the **presentation rubric** aloud (note the **ethics-framing** row).
- **Presentations (35 min):** Each team gives a **3–5 minute** talk: target & scope, methodology, top findings with severity, remediation, and an explicit **authorization/impact** statement. Peers and instructor score with the presentation rubric.
- **Closure / reflection (10 min):** Submit the **full report** and the **final course reflection** (`assessment.md`). Celebrate — and restate the life rule: permission in writing, always.
- **Assessment:** Capstone report (report rubric) + presentation (presentation rubric) + careers mini-task + course reflection. See `assessment.md`.

## Differentiation
- **Support:** Assign a **guided picoCTF set / a beginner room with a known path** and provide a phase-by-phase checklist with sentence frames for the report. Let students reuse the Unit 17 report template directly. Pair striving learners with a peer in their team and assign them a clearly-scoped role (e.g., evidence/screenshots + writing one finding). Allow extra time and snapshot resets without penalty. Provide a slide template with prompts.
- **Extension:** Assign a harder room/box or a larger picoCTF set; require **multiple findings with a summary table** and a **CVSS base score** for the top finding. Have advanced students mentor (without doing the work for) other teams, write a one-page **remediation roadmap**, or research a specialized career path (e.g., cloud security, ICS/OT, malware analysis) and report back.

## Homework / independent work
- Finish the **capstone report** and **slides** if not completed in class.
- Complete the **careers research mini-task** (`assessment.md`): pick one role on CyberSeek, note typical skills/salary/demand, map it to a NICE work role, and name a certification that supports it.
- Write the **final course reflection** (`assessment.md`).

## Assessment
- **Formative:** Daily exit tickets/status checks; capstone checklist milestones; instructor initials at each lifecycle phase.
- **Summative:** **Capstone penetration-test report** (report rubric), **team presentation** (presentation rubric), the **careers research mini-task**, and the **final course reflection**. See `assessment.md`.

## Instructor notes & common pitfalls
- **Don't let the hacking eat the week.** The deliverables are the report and presentation. Hard-stop the offensive work so teams have real time to write and rehearse. Grade documentation and communication, not flag count.
- **Honest documentation includes dead ends and partial results.** A team that got stuck but wrote up exactly what they tried, with evidence, demonstrates the real skill. Reward accuracy over bravado.
- **Severity inflation** returns under time pressure — keep enforcing likelihood × impact justifications.
- **Scope creep is the danger to watch.** Under deadline stress, a student may be tempted to "try something" outside the approved target. Reinforce that the approved list is the entire universe of legal targets this week, and that scope discipline is exactly what makes a professional employable.
- **Careers content should feel like real doors opening**, not a lecture. Use CyberSeek's live data and let students explore. Normalize multiple paths — many great practitioners are self-taught, many went to college; consistency and a portfolio matter most.
- **End on the ethics through-line.** Bookend the course: the Day-1 authorization rule is the Day-last career-protection rule. The skills they now hold are powerful; the permission-and-scope discipline is what keeps them on the right side of the line for life.
- Allow **resets without penalty**; celebrate the finish — for many students this is their first complete, documented security project.
