---
marp: true
theme: default
paginate: true
header: "Introduction to Offensive Security"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Introduction to Offensive Security
## Ethical Hacking — Course Orientation

Welcome! Let's talk about what this course is, what it isn't, and the one rule that matters most.

<!-- Day 1. Goal: set the tone — curiosity + responsibility. Don't rush the ethics framing. -->

---

# What is "offensive security"?

- Testing systems by **attacking them — with permission** — to find weaknesses before criminals do.
- Also called **ethical hacking** or **penetration testing**.
- Core idea: **You can't protect what you don't understand.**

> We learn how attackers think so we can become better **defenders**.

---

# Why learn to attack?

- Every defender, developer, and IT pro is stronger if they understand offense.
- Huge, growing career field: pentester, SOC analyst, red/blue team, AppSec, GRC…
- It's genuinely fun: puzzles, problem-solving, "how does this *really* work?"

<!-- Show CyberSeek heat map here if projector available. -->

---

# Hats: who's who

| Hat | Who they are |
|-----|--------------|
| ⚪ **White hat** | Hacks legally, with permission, to help |
| ⚫ **Black hat** | Criminal — no permission, causes harm |
| 🔘 **Gray hat** | No clear permission, no malice — still legally risky |

**Red team** = attackers · **Blue team** = defenders

---

<!-- _class: lead -->

# ⚖️ The one rule

## Authorization is the ONLY line between a penetration tester and a criminal.

You may attack **only** systems you **own** or have **explicit written permission** to test, within a defined **scope**.

---

# What that means here

- Everything we do happens in **safe, isolated lab environments** built to be attacked.
- ❌ Never the school's systems. ❌ Never classmates' devices. ❌ Never a real website.
- Unauthorized access is **illegal** — Computer Fraud and Abuse Act (CFAA) + state law.
- **Minors are not exempt.** Real consequences: charges, discipline, lasting impact.

<!-- This is the slide to slow down on. Make it concrete and real. -->

---

# If you find a real vulnerability…

**Do NOT** exploit it, share it, or post it.

**DO** report it privately to the owner (or your teacher). That's called **responsible disclosure** — and companies even pay for it through **bug bounty** programs.

> Report, don't exploit. That habit defines a professional.

---

# How the course works

- **6 modules → 18 units**, roughly one unit per week.
- Each week: learn the concept → do a **hands-on lab** → document it in your **lab journal**.
- Tools the pros use (Kali, nmap, Burp, Metasploit) against **safe practice targets**.
- Platforms: **TryHackMe / HTB Academy**, **local VirtualBox VMs**, **picoCTF / OverTheWire**.

---

# The roadmap

1. **Foundations & ethics** → build a safe lab
2. **Technical foundations** → networking, Linux, Bash, Python
3. **Reconnaissance** → find information & scan
4. **Exploitation** → web attacks, SQLi, exploits, passwords
5. **Post-exploitation** → privilege escalation, Metasploit
6. **Putting it together** → reporting + capstone CTF + careers

---

# A note on using AI

> Use of Claude and ChatGPT is **encouraged** — but make sure **you** understand the content instead of blindly telling it what to do.

AI is powerful in cybersecurity and isn't going away. Use it as a **tutor** (explain a concept, debug a script, check your thinking) — never as an **autopilot** that does the learning for you.

---

# Before we touch a single tool

- Read and **sign the Acceptable Use & Ethics Agreement** (you *and* a parent/guardian).
- We'll set up your lab next unit and verify it's **isolated** from the real internet.
- Bring your curiosity — and your judgment.

<!-- Hand out the AUP now; collect signatures before Unit 2. -->

---

<!-- _class: lead -->

# Let's get started

**Unit 1:** What Is Offensive Security? Ethics, Law & the Hacker Mindset

*Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP*
github.com/ajm4n · linkedin.com/in/aj-hammond
