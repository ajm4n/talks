# Offensive Security for High School

**An introductory offensive security (ethical hacking) course adapted from OffSec's PEN-200 (OSCP) for a high-school audience.**

> **Curriculum created by AJ Hammond** — PNPT, CRTO, OSCP, BSCP
> [GitHub](https://github.com/ajm4n) · [LinkedIn](https://linkedin.com/in/aj-hammond)

This is a one-semester (18-week) course that teaches students the fundamentals of how attackers think and operate — so they can become better defenders, smarter technologists, and ethical security professionals. It takes the structure and topic flow of the industry-standard PEN-200 / OSCP course and re-builds it from the ground up for students with **no prior experience**, with safe and legal hands-on labs and a strong ethical/legal backbone running through every unit.

> ⚠️ **Read this first:** This course teaches offensive techniques **only** in authorized, isolated lab environments. Every student, parent/guardian, and instructor must read and sign the [Acceptable Use & Ethics Agreement](instructor/safety-legal-ethics.md) before any hands-on work. Using these techniques against systems you do not own or have explicit written permission to test is **illegal** (see the U.S. Computer Fraud and Abuse Act and your local laws).

---

## Who this is for

- **Students:** Grades 9–12. No coding, networking, or Linux experience required — we start from zero.
- **Instructors:** CTE / computer science / cybersecurity teachers. You do **not** need to be a penetration tester to teach this; each unit includes background, talking points, command walkthroughs, and answer keys.

## What students will be able to do by the end

1. Explain the law and ethics of hacking and operate responsibly within them.
2. Set up and use a Linux attack workstation (Kali) and navigate the command line.
3. Read and write basic Bash and Python scripts to automate tasks.
4. Understand TCP/IP networking and how data moves across networks.
5. Perform the phases of an authorized penetration test: reconnaissance, scanning/enumeration, exploitation, and post-exploitation — in a lab.
6. Identify and safely demonstrate common web vulnerabilities (injection, XSS, etc.).
7. Find, evaluate, and responsibly use public exploits.
8. Conduct basic privilege escalation in lab machines.
9. Write a clear, professional penetration-test report.
10. Describe cybersecurity career paths and the certifications (Security+, OSCP, etc.) that lead to them.

---

## How the course is organized

The course is divided into **6 modules** spanning **18 units** (roughly one unit per week). See the [Pacing Guide](pacing-guide.md) for the week-by-week schedule.

| Module | Weeks | Theme |
|--------|-------|-------|
| 0 — Foundations, Ethics & Law | 1–2 | Why offensive security exists, the law, the hacker mindset, building a safe lab |
| 1 — Technical Foundations | 3–6 | Networking, Linux, Bash, Python |
| 2 — Reconnaissance | 7–9 | Passive & active info gathering, scanning, enumeration |
| 3 — Exploitation | 10–14 | Web attacks, SQL injection, public exploits, password attacks |
| 4 — Post-Exploitation | 15–16 | Privilege escalation, Metasploit & pivoting basics |
| 5 — Putting It Together | 17–18 | Reporting, capstone CTF, careers & certifications |

### Repository layout

```
curriculum/                       ← course root
├── README.md                     ← you are here
├── course-overview.md            ← philosophy, outcomes, assessment model
├── pacing-guide.md               ← week-by-week schedule
├── standards-alignment.md        ← NICE, CSTA, CAE, Security+ mapping
├── unit-template.md              ← the format every unit follows
├── instructor/
│   ├── lab-setup-guide.md        ← how to stand up the lab environment
│   ├── safety-legal-ethics.md    ← AUP, consent forms, legal briefing
│   └── grading-and-rubrics.md    ← grading model and reusable rubrics
├── resources/
│   ├── glossary.md               ← key terms
│   └── resource-links.md         ← curated free tools, platforms, reading
├── slides/                       ← Marp slide decks (course intro + per unit)
└── units/
    ├── unit-01-.../              ← each unit folder contains:
    │   ├── lesson-plan.md        ←   day-by-day teaching plan
    │   ├── lab.md                ←   hands-on lab activity
    │   └── assessment.md         ←   quiz / project / rubric
    └── ...
```

## How each unit works

Every unit folder contains three files:

- **`lesson-plan.md`** — learning objectives, vocabulary, a day-by-day teaching sequence (warm-up → instruction → guided practice → independent practice → closure), differentiation strategies, an ethics callout, and homework.
- **`lab.md`** — a guided, hands-on lab on a safe platform (TryHackMe/HTB Academy, a local VirtualBox VM, or picoCTF/OverTheWire), with objectives, step-by-step instructions, deliverables, and a safety reminder.
- **`assessment.md`** — formative checks, a quiz with answer key, and/or a project with a grading rubric.

## Lab platforms used

All labs run on **safe, legal, isolated** environments — never against real-world systems:

- **TryHackMe / HTB Academy** — browser-based guided rooms (lowest setup burden).
- **Local VirtualBox VMs** — Kali Linux + intentionally-vulnerable target VMs on an isolated host-only network.
- **picoCTF / OverTheWire** — free, beginner-friendly capture-the-flag and wargames.

See the [Lab Setup Guide](instructor/lab-setup-guide.md) to choose and stand up the option that fits your school's resources.

## Relationship to PEN-200 / OSCP

This course mirrors the **topic flow and mindset** of PEN-200 but is **not** OSCP exam prep. It deliberately:

- Starts from zero (PEN-200 assumes IT/networking background).
- Spends much more time on ethics, law, and foundations.
- **Defers or omits** the most advanced/inappropriate PEN-200 topics for a HS setting: antivirus evasion, exploit development/buffer overflows, and the deep Active Directory attack chain (covered only at a conceptual level).
- Uses only beginner-safe, free or low-cost lab platforms.

A topic-by-topic crosswalk lives in [`course-overview.md`](course-overview.md).

## A note on using AI (Claude, ChatGPT, etc.)

> **Use of Claude and ChatGPT is encouraged, but make sure you are understanding the content instead of blindly telling it to do things. AI is powerful in the world of cybersecurity and is certainly not going away, but it is important that you yourself understand these principals.**

AI tools are part of modern security work, and you should learn to use them well. Use them to explain a concept a different way, to help you debug a script, or to check your understanding. But the goal of this course is for *you* to understand how things work — if the AI does the thinking for you, you haven't learned the skill, and you won't be able to do it (or defend against it) on your own. Treat AI like a tutor and a teammate, not an autopilot.

---

*Curriculum created by **AJ Hammond** — PNPT, CRTO, OSCP, BSCP · [GitHub](https://github.com/ajm4n) · [LinkedIn](https://linkedin.com/in/aj-hammond)*

*Built as a teaching resource. Use responsibly.*
