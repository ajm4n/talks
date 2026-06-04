---
marp: true
theme: bootstrap
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

<!-- _class: lead -->

# Part 1
## Welcome & what this is

---

# What is "offensive security"?

- Testing systems by **attacking them — with permission** — to find weaknesses first.
- Also called **ethical hacking** or **penetration testing**.
- The goal is always to **help the owner get safer**.

> We learn how attackers think so we can become better **defenders**.

---

# Say it simply

- A locksmith who tests your locks **at your request** to show you which ones fail.
- They report what they found — they don't rob the house.
- That request and report are everything.

<!-- Anchor the whole course in this analogy; you'll return to it often. -->

---

# Offense serves defense

- **You can't protect what you don't understand.**
- Defenders who think like attackers spot problems sooner.
- Every finding becomes a fix.

---

# What this course IS

- A from-zero intro — no experience needed.
- Hands-on, in **safe practice environments**.
- A foundation for a real cybersecurity career.

---

# What this course is NOT

- ❌ A license to hack people, schools, or websites.
- ❌ A place to "get back at" anyone.
- ❌ About causing damage or showing off.

> Break things **in the lab**, to learn — never in the real world.

---

# Who you'll become

- Someone who can set up and use an attack workstation.
- Someone who can scan, find, and explain weaknesses.
- Someone who writes a clear, professional report.
- Someone employers and colleges take seriously.

---

# Check your understanding

> In one sentence: **what makes this "ethical" hacking** instead of just hacking?

<!-- Cold-call or think-pair-share. Listen for "permission" / "authorization." -->

---

# Answer

- **Permission.** You only test what you own or are **authorized** to test.
- Same tools, same skills — the difference is **consent and intent**.

---

<!-- _class: lead -->

# Part 2
## The hacker mindset

---

# The hacker mindset

- Relentless curiosity: *"How does this really work?"*
- Willingness to try, fail, and try again.
- Attention to small details others skip.

---

# Curiosity, channeled

- The same drive can **build** or **break**.
- This course points it at building safer systems.
- Curiosity is a strength — direction is a choice.

---

# "Try harder"

- Security work means getting stuck — a lot.
- Progress comes from patience and notes, not luck.
- Being stuck is normal; quitting is the only failure.

> Document what you tried. Then try one more thing.

---

# Two paths, same skills

| Path | Outcome |
|------|---------|
| Build | Better defenses, a career, respect |
| Break | Harm, charges, a closed future |

The skills are identical. **You** choose the path.

---

# Hats: who's who

| Hat | Who they are |
|-----|--------------|
| ⚪ **White hat** | Hacks legally, with permission, to help |
| ⚫ **Black hat** | Criminal — no permission, causes harm |
| 🔘 **Gray hat** | No clear permission, no malice — still risky |

---

# Red team vs blue team

- **Red team** = the attackers (us, in this course).
- **Blue team** = the defenders who detect and stop them.
- Great defenders study offense; great attackers respect defense.

---

# Check your understanding

> A "gray hat" hacks a company **without asking** but reports the bug and asks for nothing. Are they safe from the law?

---

# Answer

- **No.** No permission = still likely illegal.
- Good intentions don't replace **authorization**.
- The professional path is to ask first (or use a bug-bounty program).

---

<!-- _class: lead -->

# Part 3
## The law & ethics — the heart of this course

---

<!-- _class: lead -->

# ⚖️ The one rule

## Authorization is the ONLY line between a penetration tester and a criminal.

You may attack **only** systems you **own** or have **explicit written permission** to test.

---

# What is "scope"?

- **Scope** = exactly what you're allowed to test, in writing.
- It names the targets, the methods, and the time window.
- Outside the scope = **not allowed**, period.

---

# In this class, the scope is…

- ✅ The practice targets your teacher provides.
- ✅ Pre-authorized platforms (TryHackMe, picoCTF…).
- ❌ Everything else — always.

---

# The CFAA

- **Computer Fraud and Abuse Act** — the main U.S. anti-hacking law.
- Bans accessing computers **without authorization**.
- Penalties range from fines to serious felonies.

---

# State laws too

- Every U.S. state has its own computer-crime laws.
- Many are as strict as — or stricter than — the CFAA.
- "I didn't know" is not a defense.

---

# Minors are NOT exempt

- Students can face **juvenile or criminal charges**.
- Plus school discipline and lasting consequences.
- Colleges and employers can see the fallout for years.

> This is real. Treat it that way.

---

# Even "just looking" can be illegal

- Unauthorized **scanning** can break the law.
- So can opening an account or file that isn't yours.
- Testing a friend's or the school's systems counts.

---

# Tools are dual-use

- The tools we use are used by pros **and** criminals.
- Owning them is generally fine; **unauthorized use** is not.
- The tool is neutral — your authorization is what matters.

---

# Discuss: where's the line?

> You notice the school website has an obvious flaw. You're "pretty sure" you could get in.

- Is testing it okay? Why or why not?
- What *should* you do instead?

<!-- Let students argue it out before the next two slides. -->

---

# Responsible disclosure

- Found a real flaw by accident? **Don't exploit or share it.**
- Report it **privately** to the owner (or your teacher).
- Let them fix it before anyone else learns of it.

---

# Bug bounties

- Many companies **pay** researchers to report flaws legally.
- It's a real career and a legal way to use these skills.
- Programs define a clear, written **scope** — just like a pentest.

---

# The habit that defines a pro

> Report, don't exploit.

- Reporting earns trust, money, and a reputation.
- Exploiting earns a record.

---

# Check your understanding

> You find a way into a stranger's account on a game you play. What's the right move?

---

# Answer

- **Do not log in.** That's unauthorized access.
- Report it to the game's security/contact page.
- If unsure, tell a trusted adult or your teacher.

---

<!-- _class: lead -->

# Part 4
## How the course works

---

# The big picture

- **6 modules → 18 units**, about one unit per week.
- We build from foundations up to a full capstone.
- Every unit pairs an idea with a **hands-on lab**.

---

# Your weekly rhythm

- Learn the concept.
- Practice it in a guided lab.
- Write it up in your **lab journal**.

---

# The lab journal

- Your running record of every lab.
- For each: goal, tools, commands, results, reflection.
- It models how real pentesters take notes — and it's graded.

> If it isn't written down, it didn't happen.

---

# Roadmap — Modules 0–1

- **0 · Foundations & ethics** → build a safe lab.
- **1 · Technical foundations** → networking, Linux, Bash, Python.

---

# Roadmap — Modules 2–3

- **2 · Reconnaissance** → find information, then scan.
- **3 · Exploitation** → web attacks, SQLi, exploits, passwords.

---

# Roadmap — Modules 4–5

- **4 · Post-exploitation** → privilege escalation, Metasploit.
- **5 · Putting it together** → reporting, capstone CTF, careers.

---

# Tools you'll meet

- **Kali Linux** — the attack workstation.
- **nmap, Wireshark** — scanning and traffic.
- **Burp Suite, Metasploit** — web and exploitation.

All used **only** against safe practice targets.

---

# Check your understanding

> What three things happen every week in this course?

---

# Answer

1. **Learn** the concept.
2. **Practice** it in a hands-on lab.
3. **Document** it in your lab journal.

---

<!-- _class: lead -->

# Part 5
## Your lab — safe and isolated

---

# Three ways to practice

| Platform | What it is |
|----------|------------|
| TryHackMe / HTB | Guided, browser-based rooms |
| picoCTF / OverTheWire | Free CTF & command-line games |
| Local VMs | Kali + targets on your machine |

---

# Browser platforms

- **TryHackMe / HTB Academy** — guided, low-setup.
- Run in a browser; great on most school hardware.
- The targets are built to be attacked — legally.

---

# CTF & wargames

- **picoCTF** — beginner capture-the-flag challenges.
- **OverTheWire** — Linux command-line wargames.
- Free, safe, and pre-authorized to practice on.

---

# Local virtual machines

- A **virtual machine** is a computer running inside your computer.
- **Kali** is the attacker; a vulnerable VM is the target.
- If a VM breaks, you reset it — no harm done.

---

<!-- _class: lead -->

# 🔒 The isolation rule

## Lab VMs stay on an isolated network — never the school network or open internet while attacking.

---

# Why isolation matters

- **Technical:** keeps attacks from leaking out.
- **Ethical/legal:** guarantees you only touch in-scope targets.
- It's how we keep "lab only" actually true.

---

# How we prove it's isolated

- Use a **host-only** (or internal) network in VirtualBox.
- Test: you **can** reach the target…
- …but you **cannot** reach the real internet while attacking.

---

# Snapshots = undo button

- Take a **snapshot** of a clean VM.
- "Owned" or broke it? Restore in seconds.
- Experiment freely — you can always reset.

---

# Lab safety rules

- Attack **only** the provided targets.
- No malware on school machines outside the lab.
- Never use real personal data or real passwords.

---

# Check your understanding

> During an attack lab, your Kali VM **can** ping the internet. Is that okay?

---

# Answer

- **No.** That means it isn't isolated.
- Switch to **host-only** and re-test before continuing.
- Reaching the internet means you could hit out-of-scope targets.

---

<!-- _class: lead -->

# Part 6
## Working & learning well

---

# Learn like a pro

- Take notes you could follow again next week.
- Re-do labs you found hard until they feel easy.
- Teach a concept to a partner to test yourself.

---

# Getting unstuck

- Re-read the error message — slowly.
- Check the man page or `--help`.
- Change **one** thing at a time, and note results.

---

# A note on using AI

> Use of Claude and ChatGPT is **encouraged** — but make sure **you** understand the content instead of blindly telling it what to do.

---

# AI: tutor, not autopilot

- ✅ Explain a concept a new way; help debug; check your thinking.
- ❌ Do the learning for you.
- If AI does the work, **you** can't do it (or defend against it) later.

<!-- AI is huge in security and isn't going away — but understanding is the job. -->

---

# Help vs. cheating

- **Help:** pairing, hints, explaining ideas. ✅
- **Cheating:** copying a writeup as your own. ❌
- You keep your **own** journal and write your **own** reports.

---

<!-- _class: lead -->

# Part 7
## Expectations & getting started

---

# Before you touch a tool

- Read and **sign the Acceptable Use & Ethics Agreement**.
- Yes — a **parent/guardian** signs too.
- No signature, no lab. No exceptions.

---

# What I expect from you

- Stay in scope, every single time.
- Document your work honestly.
- Report problems instead of exploiting them.

---

# What you can expect from me

- Clear labs, real tools, and honest feedback.
- A safe place to be curious and make mistakes.
- Support when you're stuck — that's the job.

---

# How you're graded

| Part | Weight |
|------|:------:|
| Labs & lab journal | 30% |
| Quizzes & checks | 20% |
| Projects | 25% |
| Capstone | 20% |
| Professionalism & ethics | 5% |

---

# Where this can lead

- Pentester, SOC analyst, red/blue team, AppSec, GRC…
- A large, growing field with strong demand.
- Explore real roles and pay on **CyberSeek**.

---

# A certification roadmap

- **Security+** — solid entry-level cert.
- **eJPT / PNPT** — hands-on next steps.
- **OSCP** — the pro pentest cert (this course's "north star").

---

# Check your understanding

> Name the **one rule** that everything else in this course depends on.

---

# Answer

> **Authorization** — only test what you own or are given written permission to test.

Everything we do bends to that rule.

---

# Bring with you

- Curiosity — lots of it.
- Patience for getting stuck.
- Good judgment about right and wrong.

---

<!-- _class: lead -->

# Let's get started

**Unit 1:** What Is Offensive Security? Ethics, Law & the Hacker Mindset

*Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP*
github.com/ajm4n · linkedin.com/in/aj-hammond
