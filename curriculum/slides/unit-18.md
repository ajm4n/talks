---
marp: true
theme: default
paginate: true
header: "Introduction to Offensive Security · Unit 18"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Capstone, Presentations & Careers
## Module 5 — Putting It Together · Unit 18

The finale. Everything you learned, on one authorized target — then out into the world.

<!-- teacher note: This is the last unit of the course. Bookend it with Day 1: the authorization rule is now a life rule. Celebrate — for many students this is their first complete, documented security project. -->

---

# Learning objectives

By the end of this unit, you can:

- **Apply** the full attack lifecycle to an authorized capstone target.
- **Document** your work in a lab journal and a complete pentest report.
- **Present** your findings clearly, framing authorization and impact.
- **Describe** major cybersecurity career paths using CyberSeek and NICE.
- **Sequence** a certification roadmap: Security+ → eJPT/PNPT → OSCP.
- **Identify** competitions, portfolios, and home labs to keep growing.
- **Commit** to staying legal and ethical for life.

<!-- teacher note: The graded deliverables are the report and the presentation — not the flag count. Time-box the hacking so teams have real time to write and rehearse. -->

---

# The capstone

Working in **teams of 2–3**, you run the full attack lifecycle on **one authorized target**, then **report** and **present**.

| Deliverable | Graded with |
|-------------|-------------|
| Team **lab journal** (all attempted phases) | Evidence quality |
| Full **pentest report** | Report rubric |
| **3–5 min** team presentation | Presentation rubric |
| Careers mini-task + course reflection | (Individual) |

> A team that captures fewer flags but documents and presents honestly can still earn top marks.

---

# The attack lifecycle

```
Recon  →  Scan / Enumerate  →  Exploit  →  Privilege-escalate  →  Document
```

| Phase | What you do | Capture |
|-------|-------------|---------|
| **Recon** | Read the brief, note in-scope hosts, find the goal | scope, target details |
| **Scan/Enum** | `nmap`, `gobuster`, manual enumeration | commands + labeled shots |
| **Exploit** | Use what you found to gain a foothold; get the flag | steps, payload, flag |
| **Privesc** | Escalate — or document *honestly* that there's none | the path or "none, here's why" |
| **Document** | Transfer notes into the full report | the complete report |

<!-- teacher note: You can only report what you wrote down. Capture labeled screenshots from minute one. Not every box has a privesc — that's fine, document it honestly. -->

---

# Capstone targets — approved list ONLY

- **picoCTF** — free, browser-based, year-round practice gym.
- And/or an **instructor-approved beginner TryHackMe room.**

These targets are **legal, isolated, and built to be attacked.**

> The approved list is the **entire universe** of legal targets this week. Not sure a target is approved? **Stop and ask.**

<!-- teacher note: Lock the target list. Verify accounts and resets work. Scope creep is the danger under deadline pressure — reinforce that the approved list is everything. -->

---

# CTFs and flags

- **CTF (Capture The Flag):** a legal, gamified security challenge where you solve tasks to find hidden **flags**.
- A **flag** is a token that proves you solved a challenge — often `picoCTF{...}` or `flag{...}`.
- Flags are **proof of completion** — but the **report and presentation** are what's graded.
- **Rules of engagement (RoE):** the agreed boundaries — what you may and may not do.

> Write your team scope statement first: *"We are authorized to test only [the approved target]. No other systems are in scope."*

---

# Honest documentation wins

- A team that got **stuck** but wrote up exactly what they tried — with evidence — demonstrates the **real skill.**
- Document **dead ends** and **partial results** truthfully.
- Every screenshot **labeled** (Figure 1, 2, 3…) and tied to the **exact command** that produced it.
- **Reward accuracy over bravado.** Resets from snapshot are free — no penalty.

> "Trust me, it worked" is not evidence. Reproducibility is.

<!-- teacher note: Severity inflation returns under time pressure — keep enforcing likelihood × impact. Allow VM/room resets without penalty. -->

---

# The presentation (3–5 min)

A short team talk — build **3–5 slides**:

1. **Target & scope/authorization**
2. **Methodology / lifecycle**
3. **Top findings + severity**
4. **Remediation**
5. **What we learned + ethics**

> The **ethics-framing** row is required: explicitly state your **authorization** and the real-world **impact** of your findings.

<!-- teacher note: Schedule Day 5 for the talks. Peers and instructor score with the presentation rubric. Rehearse to time. -->

---

# Cybersecurity career paths

| Role | What they do |
|------|--------------|
| **Pentester / Red team** | Simulate attackers to test defenses |
| **SOC analyst / Blue team** | Monitor alerts, detect, respond, harden |
| **Purple team** | Red + blue working together |
| **GRC** | Governance, risk, and compliance — the policy side |
| **AppSec** | Find and fix flaws in software/code |
| **IR / Threat intel** | Respond to incidents, track adversaries |

> Explore live demand with **CyberSeek**; map roles with the **NICE Framework**.

<!-- teacher note: Make careers feel like real doors opening, not a lecture. Use CyberSeek's live data. Normalize multiple paths. -->

---

# The certification roadmap

```
Security+   →   eJPT / PNPT   →   OSCP   →   and beyond
(entry-level)   (practical pentest)  (hands-on pro)
```

| Cert | What it proves |
|------|----------------|
| **Security+** | Broad security fundamentals — a common first step |
| **eJPT / PNPT** | Practical, hands-on pentesting at beginner→intermediate |
| **OSCP** | The pro version of this course's content — hands-on |

> Certs open doors, but **a portfolio of real work** proves you can do the job.

---

# Keep growing — for free

- **Competitions:** picoCTF, National Cyber League, CyberPatriot.
- **Home lab:** a safe, isolated practice environment you build yourself.
- **Portfolio:** publish sanitized writeups, lab journals, and projects.
- **College vs. self-study:** both work — **consistency beats either.**

> Many great practitioners are self-taught; many went to college. What they share is steady practice and a body of work to show.

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization — for life

## Authorization and scope are the only line between a penetration tester and a criminal.

The Day-1 class rule is now a **life rule.** The same skills, pointed at a real system without **written permission**, are a crime under laws like the **CFAA** — and would end the very career you're aiming for.

> Professionals stay employable precisely because they stay in scope, get permission in writing, and disclose responsibly.

<!-- teacher note: Discussion prompt — five years from now, a friend asks you to "just check if my ex's account can be hacked." Walk through what you say and why. What would yes cost you — legally, professionally, ethically? Same lesson as Day 1. -->

---

# Key vocabulary

| Term | Meaning |
|------|---------|
| Capstone | The final project — apply everything to one authorized target |
| Attack lifecycle | Recon → scan/enum → exploit → privesc → document |
| CTF / Flag | Gamified legal challenge / token proving you solved it |
| Rules of engagement | The agreed boundaries of a test |
| Red / Blue / Purple team | Offense / defense / both together |
| GRC / AppSec | Policy & risk / software security |
| CyberSeek / NICE | Career map / national catalog of work roles |
| Security+ / eJPT / PNPT / OSCP | The certification roadmap |
| Home lab / Portfolio | Where you keep practicing / proof of your work |

---

# 🧪 Lab launch — the capstone

- **Target:** your **picoCTF** set and/or **approved TryHackMe** room — *approved list ONLY.*
- **Read the Safety & authorization reminder aloud** as a team; write your **scope statement.**
- Run the lifecycle: **recon → scan/enum → exploit → privesc → document.**
- Capture **labeled evidence** from minute one; everyone documents.
- Write the **full report** (Unit 17 template) and build your **3–5 slide** deck.

> Under deadline pressure, the temptation to "try one more thing" outside scope is real. **Don't.** Scope discipline is what keeps a professional employable.

<!-- teacher note: Distribute the capstone checklist and report template on Day 1 so teams see the finish line. Initials at each lifecycle phase. Hard-stop the hacking so there's time to write and rehearse. -->

---

# Recap

- The **capstone** applies the full lifecycle to one **authorized** target.
- **Report + presentation** are the graded deliverables — not flag count.
- **Honest documentation** (including dead ends) is the real skill.
- Careers: **pentest, SOC, red/blue/purple, GRC, AppSec** — explore CyberSeek + NICE.
- Roadmap: **Security+ → eJPT/PNPT → OSCP**; build a **portfolio + home lab.**
- The Day-1 authorization rule is now a **life rule.**

---

<!-- _class: lead -->

# Exit ticket / discussion & farewell

1. Name the five phases of the attack lifecycle in order.
2. Name one career path and one certification that interest you.
3. What's your **honest next step** after this class?
4. Why does **authorization** protect your future, not just your grade?

> You hold powerful skills now. Permission and scope — **in writing, always** — are what keep you on the right side of the line for the rest of your life.

**Go build something. Stay curious. Stay legal. You've got this.**

*Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP*
github.com/ajm4n · linkedin.com/in/aj-hammond

<!-- teacher note: Submit the full report + final course reflection. Celebrate the finish. End on the ethics through-line: the skills are powerful; the permission-and-scope discipline keeps them right for life. -->
