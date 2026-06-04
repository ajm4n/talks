# Course Overview

## Course title
**Introduction to Offensive Security (Ethical Hacking)**

## Description
A one-semester, project-based introduction to offensive security for high-school students. Adapted from OffSec's industry-standard PEN-200 course, it teaches students to think like an attacker — reconnaissance, scanning, exploitation, and post-exploitation — entirely within safe, legal, isolated lab environments, so they can become stronger defenders and ethical security professionals. No prior programming, networking, or Linux experience is required.

## Course philosophy

1. **Ethics first, always.** Students learn *why* before *how*. The legal and ethical framing is not a single lesson — it is revisited in every unit. We frame offensive skills as a means to defense ("you can't protect what you don't understand").
2. **Start from zero.** We assume no background. Networking, Linux, and scripting are taught before any offensive content.
3. **Hands-on over lecture.** Every concept is paired with a safe, guided lab. Students learn by doing in environments designed to be attacked.
4. **Authorization is the dividing line.** The single most important idea in the course: the *only* difference between a penetration tester and a criminal is **written permission and scope**. We hammer this home.
5. **Real tools, real workflows, safe targets.** Students use the same tools professionals use (Kali, nmap, Burp, Metasploit) — but only against intentionally-vulnerable lab targets.
6. **AI is a tutor, not an autopilot.** Use of Claude and ChatGPT is encouraged, but make sure you are understanding the content instead of blindly telling it to do things. AI is powerful in the world of cybersecurity and is certainly not going away, but it is important that you yourself understand these principals. Use AI to explain concepts, debug scripts, and check understanding — never to skip the learning.

## Course learning outcomes (CLOs)

By the end of the course, students will be able to:

- **CLO 1 — Ethics & Law:** Explain relevant computer-crime law (e.g., CFAA), the role of authorization and scope, and responsible disclosure; and consistently apply ethical decision-making.
- **CLO 2 — Foundations:** Demonstrate working knowledge of TCP/IP networking, the Linux command line, and basic scripting (Bash and Python).
- **CLO 3 — Reconnaissance:** Perform passive and active information gathering and interpret scan/enumeration results.
- **CLO 4 — Exploitation:** Identify and safely demonstrate common vulnerabilities (web injection, XSS, weak credentials) and use public exploits responsibly.
- **CLO 5 — Post-Exploitation:** Perform basic privilege escalation and explain lateral movement/pivoting concepts.
- **CLO 6 — Communication:** Produce a clear, professional penetration-test report and present findings.
- **CLO 7 — Career awareness:** Describe cybersecurity career pathways and the certifications and education that support them.

## Assessment model

| Component | Weight | Notes |
|-----------|--------|-------|
| Lab completion & lab notebooks | 30% | Each unit's hands-on lab + a maintained lab journal |
| Unit quizzes & checks for understanding | 20% | Short formative + summative quizzes |
| Projects (recon report, web-vuln writeup, etc.) | 25% | 2–3 graded mini-projects across the semester |
| Capstone (CTF + report + presentation) | 20% | Module 5 |
| Professionalism & ethics (citizenship) | 5% | AUP adherence, collaboration, conduct |

See [`instructor/grading-and-rubrics.md`](instructor/grading-and-rubrics.md) for rubrics.

## PEN-200 → high-school crosswalk

This shows how PEN-200's modules map onto this course. ✅ = covered in depth, 🟡 = covered at a conceptual/awareness level, ❌ = intentionally omitted for a HS audience.

| PEN-200 topic | This course | Where |
|---------------|:----------:|-------|
| Intro to cybersecurity / report writing | ✅ | Units 1, 17 |
| Effective learning strategies | ✅ | Unit 1 + woven throughout |
| Linux basics & command line | ✅ | Unit 4 |
| Bash scripting | ✅ | Unit 5 |
| Practical tools (netcat, wireshark, tcpdump) | ✅ | Units 3, 8 |
| Passive information gathering (OSINT) | ✅ | Unit 7 |
| Active information gathering | ✅ | Unit 8 |
| Vulnerability scanning | ✅ | Unit 9 |
| Introduction to web application attacks | ✅ | Unit 10 |
| Common web application attacks (XSS, LFI/RFI, cmd injection) | ✅ | Unit 11 |
| SQL injection | ✅ | Unit 12 |
| Client-side attacks | 🟡 | Unit 11 (awareness) |
| Locating public exploits | ✅ | Unit 13 |
| Fixing exploits | 🟡 | Unit 13 (light) |
| Antivirus evasion | ❌ | Out of scope for HS |
| Password attacks | ✅ | Unit 14 |
| Windows privilege escalation | 🟡 | Unit 15 (basics) |
| Linux privilege escalation | ✅ | Unit 15 |
| Port redirection & SSH tunneling | 🟡 | Unit 16 (concept + simple lab) |
| Tunneling through deep packet inspection | ❌ | Out of scope |
| The Metasploit Framework | ✅ | Unit 16 |
| Active Directory intro & enumeration | 🟡 | Unit 16 (concept only) |
| Attacking AD authentication | ❌ | Out of scope |
| Lateral movement in AD | ❌ | Out of scope |
| Assembling the pieces (challenge labs) | ✅ | Units 17–18 (capstone) |

### What we add that PEN-200 assumes you already know
- Networking fundamentals from scratch (Unit 3)
- Python basics (Unit 6)
- An extended, recurring ethics & law strand
- Career and certification guidance (Unit 18)

## Differentiation & accessibility
Each unit's lesson plan includes supports for striving learners (more scaffolding, checkpoint labs) and extensions for advanced learners (bonus rooms/boxes, "go further" challenges). Browser-based labs (TryHackMe, picoCTF) require only a web browser, lowering the hardware barrier for students who lack a capable home machine.

## Prerequisites
None. Recommended (not required): keyboarding fluency and general computer literacy.
