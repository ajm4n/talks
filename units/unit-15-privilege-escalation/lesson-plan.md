# Unit 15 — Privilege Escalation (Linux & Windows Basics)

- **Module:** Module 4 — Post-Exploitation
- **Suggested week:** Week 15
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Linux Privilege Escalation (in depth) + Windows Privilege Escalation (basics/awareness only)

> Up to now you've focused on *getting in* — recon, scanning, web bugs, public exploits, password attacks. But landing on a machine is usually just the beginning. Most of the time, your first foothold is a **low-privilege** account that can barely do anything. Unit 15 is about what happens *after* you get a shell: **post-exploitation**, and specifically **privilege escalation** — going from a regular user to **root** (Linux) or **Administrator/SYSTEM** (Windows). You'll learn that the secret weapon here is not a fancy exploit — it's **enumeration**: carefully looking around for misconfigurations the system owner left behind. And as always, every attack is paired with the defense that stops it.

## Learning objectives
By the end of this unit, students can:
- **Define** post-exploitation and privilege escalation, and **explain** the difference between a low-privilege user and root/administrator.
- **Explain** why thorough **enumeration** after gaining access is the single most important privilege-escalation skill.
- **Run** core Linux enumeration commands (`id`, `whoami`, `sudo -l`, `find` for SUID binaries) and **interpret** what each reveals.
- **Identify and exploit** common Linux privilege-escalation vectors in a lab: **sudo misconfigurations**, **SUID binaries**, **cron jobs**, and **weak/world-writable file permissions**; and **read** sensitive files left readable.
- **Describe** at an awareness level how **kernel exploits** can escalate privileges and why they are risky/last-resort.
- **Use** an enumeration helper such as **LinPEAS** responsibly and explain that it only *finds* issues — the human still decides what to do.
- **Describe** Windows privilege escalation at a basic level: common misconfigurations, **unquoted service paths**, and the role of **WinPEAS** (conceptual).
- **Recommend** layered defenses — **least privilege**, **patching/updates**, and **system hardening** — and connect each defense to the specific attack it stops.
- **Document** a complete privilege-escalation path clearly enough that another person could reproduce or fix it.

## Standards alignment
- **NICE Framework:** Knowledge of system/host security and vulnerabilities (K0005, K0177, K0624); Tasks — assess host configurations, identify and recommend mitigations (T0028, T0176). Work role exposure: Penetration Tester, Vulnerability Assessment Analyst, System Administrator.
- **CSTA / state CS standards:** 3A-IC-30 (impacts of computing/security), 3B-AP-18 (explain security risks of software systems), 3A-NI-05 (give examples of security measures and tradeoffs).
- **Security+ domain(s):** 1.0 (Attacks — privilege escalation), 2.0 (Architecture — hardening, least privilege), 4.0 (Operations — patch management, secure configuration).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Post-exploitation | Everything an attacker does *after* getting access: looking around, escalating, collecting info. |
| Privilege escalation (privesc) | Going from a limited account to a more powerful one (e.g., normal user → root/admin). |
| Low-privilege user | An account with limited rights — can't change system settings or read protected files. |
| Root | The all-powerful administrator account on Linux/Unix. |
| Administrator / SYSTEM | The most powerful accounts on Windows (`SYSTEM` is even higher than a normal admin). |
| Enumeration | Systematically gathering details about a system you're on to find weaknesses. |
| `sudo` | A Linux command that lets a user run specific commands as another user (often root). |
| `sudo -l` | Lists exactly what the current user is allowed to run with `sudo`. |
| sudo misconfiguration | When `sudo` is set up too loosely, letting a normal user run something that hands them root. |
| SUID binary | A program that runs with the *file owner's* privileges (often root), no matter who launches it. |
| Cron job | A task Linux runs automatically on a schedule; a misconfigured one can be hijacked for root. |
| File permissions | Rules for who can read/write/execute a file (the `rwx` you saw in Unit 04). |
| World-writable | A file/folder anyone can modify — dangerous if root later uses it. |
| Kernel exploit | An attack against the core of the OS itself; can grant root but may crash the system. |
| LinPEAS / WinPEAS | Scripts that automatically *scan* a Linux/Windows system and flag possible privesc paths. |
| Unquoted service path | A Windows misconfiguration where a service path with spaces lets an attacker slip in their own program. |
| Least privilege | Giving every account/process only the access it actually needs. |
| Hardening | Tightening a system's configuration to remove weaknesses before an attacker finds them. |
| Patching | Installing updates that fix known security holes. |

## Materials & prep
- **TryHackMe** account (free tier) and the **AttackBox** or a **Kali Linux** VM with a browser. Free.
- Approved beginner **Linux privilege-escalation room(s)** on TryHackMe (e.g., a "Linux PrivEsc" / "Privilege Escalation" room that covers sudo, SUID, and cron). Optionally one **basic Windows PrivEsc** room for awareness. Confirm exact rooms and that they load on the school network.
- A copy of **LinPEAS** available inside the lab environment (the rooms usually provide it; otherwise stage it on the isolated lab).
- Projector/whiteboard to diagram "low-priv user → root" and the GTFOBins idea.
- Handouts: the Linux enumeration cheat-sheet, the privesc lab journal template (in `lab.md`), the lab journal rubric from `instructor/grading-and-rubrics.md`.
- **Instructor prep notes:**
  - Complete the chosen room(s) yourself first and write down the **exact escalation path** (which vector, which command). Put it in the `lab.md` answer key.
  - Confirm everything runs in the **isolated/authorized environment only** — these target machines are deliberately broken. See `instructor/lab-setup-guide.md`.
  - Pre-stage **GTFOBins** as a reference (a site listing how common binaries can be abused) so students learn to look up a SUID/sudo binary rather than memorize.
  - Decide whether the Windows portion is a short instructor demo/discussion or an optional student room, based on time and machine performance — Windows is **awareness-level only** this unit.
  - Have a snapshot/reset plan so students who break a box can restart.

## ⚖️ Ethics & legal callout
Privilege escalation is the moment an attacker goes from "I'm in" to "I own everything." On a real system that is exactly the line between a minor incident and a catastrophic breach — full admin means access to *every* file, *every* user, *every* secret. Running these techniques against any machine you do not own or have **written permission** to test is a serious crime under the CFAA and state law, even if you "only looked." In this unit you escalate privileges **only** on authorized TryHackMe rooms or the isolated class lab — machines built to be conquered. The reason we learn it: the same enumeration that finds a sudo misconfig is exactly what a **defender** runs to *remove* it before an attacker arrives.

**Discussion prompt:** A penetration tester is hired to test a company's web server. During the test they find that, with one command, they could escalate to root on a *different* server that was not in the agreed scope. They're confident it would work. What should they do — and why does "but I could have" not make it okay? Where is the authorization boundary here?

## Lesson sequence

### Day 1 — Post-exploitation & why enumeration is everything
- **Warm-up (5–10 min):** "You just got a shell on a machine as user `bob`. `bob` can't read the password file or install software. Now what?" Collect ideas.
- **Direct instruction (15–20 min):** Define **post-exploitation** and **privilege escalation**. Contrast a **low-privilege user** with **root** / **Administrator/SYSTEM**. Make the big point: privesc is usually won by *enumeration*, not by a magic exploit — the system owner almost always left a misconfiguration behind. Introduce the core questions: Who am I? What can I run? What's unusual here?
- **Guided practice (15 min):** As a class, run/predict the output of `whoami`, `id`, and `sudo -l` on a sample box. Define the vocabulary as it comes up.
- **Independent practice / lab:** Read the Linux enumeration cheat-sheet; in journals, write the three "first questions" you ask after landing on a machine, and the command that answers each.
- **Closure / exit ticket (5 min):** "In one sentence: why is enumeration more important than any single exploit for privilege escalation?"

### Day 2 — Linux vector 1 & 2: sudo misconfigurations and SUID binaries
- **Warm-up (5–10 min):** Show the output of `sudo -l` listing `(root) NOPASSWD: /usr/bin/find`. "Why might that be dangerous?"
- **Direct instruction (15–20 min):** Walk through **sudo misconfigurations**: if you can run even a harmless-looking program as root, that program might let you "break out" to a root shell. Introduce **GTFOBins** as the lookup site that shows how. Then introduce **SUID binaries**: programs that run as their *owner* (often root) no matter who launches them — `find / -perm -4000 2>/dev/null` lists them, and GTFOBins shows which are abusable.
- **Guided practice (15 min):** Look up one example on GTFOBins as a class (e.g., how `find` or `vim` can spawn a root shell when run via sudo/SUID). Trace *why* it works.
- **Independent practice / lab:** **Read the Safety & authorization reminder in `lab.md` aloud.** Begin the TryHackMe Linux PrivEsc lab: get the low-priv shell, run `sudo -l` and the SUID `find`, and attempt the **sudo** and/or **SUID** escalation. Record every command and result in the journal.
- **Closure / exit ticket (5 min):** "Explain in your own words what a SUID binary is and why it matters for privesc."

### Day 3 — Linux vector 3 & 4: cron jobs and weak file permissions (+ kernel awareness)
- **Warm-up (5–10 min):** "If root runs a script every minute and *you* can edit that script… what happens?"
- **Direct instruction (15–20 min):** **Cron jobs** — scheduled tasks; if one runs as root and calls a file you can write to (or is world-writable), you can make root run *your* code. **Weak/world-writable permissions** and **readable sensitive files** — find files you shouldn't be able to write (or that leak passwords/keys). Then **kernel exploits** at *awareness level only*: attacking the OS core can give instant root but can crash the box, so it's usually a last resort — and it's why **patching** matters.
- **Guided practice (15 min):** Inspect a sample crontab and file listing as a class; identify the world-writable script root runs, and the plan to abuse it.
- **Independent practice / lab:** Continue the lab — find and exploit the **cron** and/or **weak-permissions** vector to reach root; capture the proof (e.g., `id` showing `uid=0`, the root flag). Save output to the journal.
- **Closure / exit ticket (5 min):** "Name the four Linux vectors we've covered and one tell-tale sign of each."

### Day 4 — Enumeration helpers (LinPEAS) + Windows privesc basics (awareness)
- **Warm-up (5–10 min):** "We found these issues by hand. What if a script could flag them all in 30 seconds — does that make the human unnecessary?"
- **Direct instruction (15–20 min):** Introduce **LinPEAS**: it auto-scans and color-codes likely privesc paths. Frame it honestly — it *finds* candidates, it doesn't *think*; you still verify and decide, and you still need to understand the manual checks (so you're not "just a tool runner"). Then **Windows privesc — basics/awareness only**: same idea (normal user → Administrator/SYSTEM), driven by misconfigurations; introduce **unquoted service paths** conceptually, and **WinPEAS** as the Windows equivalent of LinPEAS. Note that deep Windows/AD attacks are beyond this course.
- **Guided practice (15 min):** Run **LinPEAS** on the lab box and read its highlighted output together; match its findings to the vectors you exploited by hand on Days 2–3.
- **Independent practice / lab:** Run LinPEAS in the lab and annotate which of its findings led (or could lead) to root. (Optional/awareness: a short Windows room or instructor demo showing an unquoted-service-path or WinPEAS output.)
- **Closure / exit ticket (5 min):** "Why shouldn't a pentester rely on LinPEAS/WinPEAS alone? Give one reason."

### Day 5 — The defense + document the path
- **Warm-up (5–10 min):** "You're now the sysadmin. Pick one vector from this week and stop it."
- **Direct instruction (15 min):** Defense in depth, attack-by-attack: **least privilege** (don't give sudo/SUID/admin rights that aren't needed — kills most sudo/SUID paths); **hardening** (fix file permissions, no world-writable files, quote service paths, remove unnecessary SUID bits); **patching/updates** (closes kernel and software exploits). Map each defense to the exact attack it blocks.
- **Guided practice / independent lab:** Students finish the lab and write the **privesc path writeup**: the low-priv start, each enumeration step, the vector used, the proof of root — and a **remediation** for that exact vector.
- **Closure / exit ticket (5 min):** Submit the privesc-path journal; one-sentence reflection: "the misconfig that surprised me most was ___ because ___."
- **Assessment:** Unit quiz (`assessment.md`) at end of Day 5 or start of Week 16.

## Differentiation
- **Support:** Provide the enumeration cheat-sheet as a copy/paste command list so syntax isn't a barrier. Pair students for the rooms. Give a "fill-in-the-path" journal template (Start as: ___ → Found: ___ → Abused: ___ → Now I am: ___). Pre-bookmark the relevant GTFOBins pages. Offer the browser-based AttackBox for students whose VMs struggle. For the trickiest vector, give a hint card rather than the full answer.
- **Extension:** Have students complete the optional Windows room and write a comparison of Linux vs Windows privesc. Ask them to find a *second* path to root on the same box. Have them write a short "how a SUID bit actually works" explainer, or research one real CVE-based kernel-privesc story and summarize the root cause and the patch that fixed it (no attack instructions). Challenge: reproduce a LinPEAS finding entirely by hand and explain what LinPEAS checked.

## Homework / independent work
- Finish the TryHackMe Linux PrivEsc room if not completed in class; paste the journal evidence.
- Write a **plain-English explanation** (5–6 sentences) of how *one* vector you used escalated you to root.
- For each of the four Linux vectors, write the **matching defense** in one line.
- Short reflection (½ page): "Why is enumeration, not exploitation, the heart of privilege escalation?"

## Assessment
- **Formative:** Daily exit tickets; instructor walk-around verifying each student can run `sudo -l` / SUID `find` and explain the output; the paper crontab/permissions analysis; the LinPEAS-vs-manual matching.
- **Summative:** Unit quiz + the documented **privesc path** (contributes to the lab journal grade) — see `assessment.md`.

## Instructor notes & common pitfalls
- **Isolation is non-negotiable.** These boxes are intentionally vulnerable and must live in the isolated/authorized lab only. Re-state it every lab day. Never point LinPEAS or any technique at a machine outside scope.
- Students conflate "got a shell" with "owned the box." Keep hammering the difference: **a foothold is a low-priv user; privesc is the second, separate fight.**
- The biggest mindset win is **enumeration over exploitation.** When a student is stuck, the fix is almost always "you skipped an enumeration step," not "you need a better exploit."
- Teach **GTFOBins as a skill**, not a cheat — the point is "look up how this binary can be abused," which is exactly how professionals work.
- `sudo -l` and the SUID `find` command are the two most valuable muscle-memory commands of the unit; have everyone run them on every box.
- Don't let LinPEAS become a crutch. Make students reproduce at least one finding by hand so they don't graduate as "just a tool runner."
- Keep Windows **truly awareness-level.** It's easy to rabbit-hole into AD; resist it — that's flagged out-of-scope in the crosswalk.
- Always close the loop with the **defense.** Every vector they exploit must be paired with the least-privilege / hardening / patching fix that removes it.
