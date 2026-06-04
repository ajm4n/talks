# Unit 16 — Metasploit & Pivoting Concepts

- **Module:** Module 4 — Post-Exploitation
- **Suggested week:** Week 16
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** The Metasploit Framework (in depth) + Port Redirection & SSH Tunneling (concept + simple demo) + Active Directory intro (concept/awareness only)

> Last unit you escalated to root by hand. This unit you meet the most famous tool in offensive security: **Metasploit**, a framework that bundles thousands of exploits, payloads, and post-exploitation tools behind one console. It can feel like magic — type a few commands and get a shell. But the big lesson of this unit is a warning as much as a skill: **don't become "just a tool runner."** Professionals use Metasploit *and* know what it's doing under the hood, so they can adapt when the easy button fails. You'll also meet two important *ideas* (no deep lab): **pivoting / tunneling** — using one compromised machine as a stepping stone to reach others — and **Active Directory**, the system most companies use to manage all their Windows computers and accounts. As always: every attack is paired with the defense that detects or stops it.

## Learning objectives
By the end of this unit, students can:
- **Explain** what the **Metasploit Framework** is and **why** security frameworks exist (they collect and standardize tools so you don't reinvent them each time).
- **Navigate** `msfconsole` using the core workflow: `search`, `use`, `show options`, `set`, and `exploit`/`run`.
- **Distinguish** the four main Metasploit module types — **exploit**, **payload**, **auxiliary**, and **post** — and give an example of each.
- **Obtain** a **Meterpreter** session against an authorized lab target and **run** basic post-exploitation modules/commands (e.g., `sysinfo`, `getuid`, `hashdump`-style info gathering as the room allows).
- **Describe** at an awareness level what **msfvenom** does (generates standalone payloads) without weaponizing anything outside the lab.
- **Justify** why professionals also work **manually** and what's lost by being "just a tool runner."
- **Explain conceptually** what **pivoting**, **port forwarding**, and **SSH tunneling** are and *why* attackers (and defenders) care — and demonstrate a simple **SSH local port-forward** in the isolated lab to make it concrete.
- **Describe** at an awareness level what **Active Directory** is and why enterprises use it, noting that deep AD attacks are beyond this course.
- **Recommend** defenses against framework-driven attacks: **detection/logging**, **EDR**, **network segmentation**, and **patching** — connecting each to what it stops.
- **Document** a Metasploit session and **explain pivoting in their own words**.

## Standards alignment
- **NICE Framework:** Knowledge of penetration testing principles, tools, and techniques (K0342, K0362); network architecture and segmentation (K0179, K0058); Tasks — conduct authorized testing and recommend mitigations (T0028, T0266). Work role exposure: Penetration Tester, Cyber Defense Analyst, Network Defense Analyst.
- **CSTA / state CS standards:** 3A-IC-30 (impacts of computing/security), 3B-AP-18 (security risks of software systems), 3A-NI-04/05 (network organization, security measures and tradeoffs).
- **Security+ domain(s):** 1.0 (Attacks/tools), 2.0 (Architecture — segmentation, EDR), 4.0 (Operations — detection, logging, patch management).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Framework | A toolkit that bundles many ready-made tools and a common way to use them, so you don't build each from scratch. |
| Metasploit | The most popular offensive-security framework; collects exploits, payloads, and post tools under one console. |
| `msfconsole` | The main command-line interface for driving Metasploit. |
| Module | A single tool inside Metasploit (an exploit, a payload, etc.). |
| Exploit (module) | Code that takes advantage of a specific vulnerability to get access. |
| Payload | The code that runs *after* an exploit succeeds — e.g., it opens a shell back to you. |
| Auxiliary (module) | A helper tool that isn't an exploit — scanners, fuzzers, login checkers. |
| Post (module) | A post-exploitation tool you run *after* you have a session (gather info, escalate, etc.). |
| Meterpreter | A powerful, in-memory payload/shell that gives lots of post-exploitation commands. |
| Session | An active connection to a machine you've compromised. |
| `search` / `use` / `show options` / `set` / `exploit` | The core msfconsole workflow: find a module, select it, see its settings, configure them, run it. |
| RHOSTS / LHOST | The **remote** target address (RHOSTS) and your **local** listener address (LHOST). |
| msfvenom | A Metasploit tool that generates standalone payload files (awareness level only here). |
| "Just a tool runner" | Someone who can click the button but can't explain or adapt when the tool fails — what we don't want to become. |
| Pivoting | Using one compromised machine as a stepping stone to reach other machines you couldn't reach directly. |
| Port forwarding | Redirecting traffic from one port/host to another so you can reach something otherwise blocked. |
| SSH tunnel | Using an encrypted SSH connection to carry other traffic, often to reach an internal service. |
| Local port forward | An SSH option (`-L`) that maps a local port to a remote service through the SSH server. |
| Active Directory (AD) | Microsoft's system for managing many Windows computers, users, and permissions from one central place. |
| Domain Controller | The central server that runs Active Directory for a network. |
| Network segmentation | Splitting a network into isolated zones so a breach in one can't easily spread. |
| EDR | Endpoint Detection and Response — security software that watches a machine for malicious behavior. |

## Materials & prep
- **TryHackMe** account (free tier) and the **AttackBox** or a **Kali Linux** VM (Metasploit is preinstalled on Kali). Free.
- An approved beginner **Metasploit room** on TryHackMe (one that walks through `msfconsole`, getting a Meterpreter session, and basic post modules). Confirm the exact room and that it loads on the school network.
- For the SSH tunneling demo: two machines in the **isolated lab** (or the room's setup) so students can run a simple `ssh -L` local port-forward to reach a service that isn't directly reachable.
- Projector/whiteboard to diagram: the msfconsole workflow; the four module types; and a pivot diagram (attacker → foothold box → hidden internal box).
- Handouts: the msfconsole cheat-sheet, the Metasploit lab journal template (in `lab.md`), the "explain pivoting in your own words" prompt, the lab-journal rubric from `instructor/grading-and-rubrics.md`.
- **Instructor prep notes:**
  - Complete the chosen room yourself first and record the **exact** module names, options, and the working session steps. Put them in the `lab.md` answer key.
  - Verify everything runs in the **isolated/authorized environment only**. See `instructor/lab-setup-guide.md`.
  - Decide how to handle **msfvenom**: keep it **awareness-level** — describe what it generates and why defenders care; do **not** have students build/deploy real malware. A read-only demo of one command's output is enough.
  - Pre-build the **pivot diagram** and a tiny working `ssh -L` example on the isolated lab so the demo is reliable.
  - Keep **Active Directory** strictly conceptual; have a simple "why enterprises use AD" slide and resist going deeper (AD attacks are out of scope per the crosswalk).
  - Snapshot/reset plan for the lab boxes.

## ⚖️ Ethics & legal callout
Metasploit lowers the skill needed to attack a machine to a few typed commands — which is exactly why the **authorization** rule matters more here, not less. The framework doesn't ask whether you have permission; *you* are responsible for that. The same `msfconsole` that you'll use on an authorized TryHackMe box would be a felony pointed at a stranger's server. **msfvenom** generating a payload, or **pivoting** from one machine to another, are the kinds of capabilities that turn a small incident into a full network compromise — so we keep every bit of it inside the isolated/authorized lab. And the professional reason we learn the tool deeply rather than just clicking it: defenders need to know *exactly* what Metasploit looks like on the wire and on a host so they can **detect** and **stop** it.

**Discussion prompt:** A new student says, "Metasploit does everything — why do I need to understand exploits, networking, or privilege escalation by hand?" Give at least two concrete situations where the "just a tool runner" approach fails, and explain how understanding the manual version makes someone both a better attacker (on authorized tests) and a better defender.

## Lesson sequence

### Day 1 — What Metasploit is & the msfconsole workflow
- **Warm-up (5–10 min):** "Imagine a giant toolbox where every tool already fits together and shares settings. What are the upsides — and the hidden downside?" Collect ideas.
- **Direct instruction (15–20 min):** Define **framework** and **Metasploit**; explain *why* frameworks exist (standardize and reuse tools). Introduce the core **msfconsole workflow**: `search` (find a module) → `use` (select it) → `show options` (see settings) → `set` (configure, e.g., `RHOSTS`, `LHOST`) → `exploit`/`run`. Define **RHOSTS** vs **LHOST**.
- **Guided practice (15 min):** Open `msfconsole` together; `search` for a sample module, `use` it, `show options`, and read what each option means (don't run yet).
- **Independent practice / lab:** In journals, write the five workflow commands in order and what each does. Start the assigned room's intro section.
- **Closure / exit ticket (5 min):** "Put the msfconsole workflow in order and say what `RHOSTS` and `LHOST` mean."

### Day 2 — Module types & getting a Meterpreter session
- **Warm-up (5–10 min):** "An *exploit* gets you in the door. What runs *after* you're inside?" Tease **payload**.
- **Direct instruction (15–20 min):** The four module types — **exploit**, **payload**, **auxiliary**, **post** — with an example of each. Introduce **Meterpreter** as a powerful payload that gives a rich post-exploitation shell, and the idea of a **session**.
- **Guided practice (15 min):** As a class, walk the room's exploit: select the exploit, set a Meterpreter payload, set `RHOSTS`/`LHOST`, `show options` to double-check, then `exploit`.
- **Independent practice / lab:** **Read the Safety & authorization reminder in `lab.md` aloud.** Students run the room to get their own **Meterpreter session** on the authorized target. Record each command and the session opening in the journal.
- **Closure / exit ticket (5 min):** "Name the four module types and give one example of each."

### Day 3 — Meterpreter post-exploitation + msfvenom (awareness) + why work manually
- **Warm-up (5–10 min):** "You've got a Meterpreter session. What's the first thing you want to know about the machine?"
- **Direct instruction (15–20 min):** Basic **Meterpreter / post** commands: `sysinfo`, `getuid`, navigating files, and running a **post module** (e.g., enumeration). Then **msfvenom** at **awareness level**: it *generates* standalone payload files (e.g., a malicious executable) — explain what that means and why defenders care, without building/deploying anything. Then the central lesson: **why professionals also work manually** — tools fail, get detected, or don't fit; understanding the manual version is what separates a professional from a "just a tool runner."
- **Guided practice (15 min):** Run `sysinfo` and `getuid` in the live session together; run one basic post module the room provides and read the output.
- **Independent practice / lab:** Students run basic post modules/commands in their Meterpreter session and capture output to the journal.
- **Closure / exit ticket (5 min):** "Give one concrete situation where relying only on Metasploit would fail, and what manual knowledge saves you."

### Day 4 — Pivoting, port forwarding & SSH tunneling (concept + simple demo)
- **Warm-up (5–10 min):** "You compromised a public web server, but the juicy database is on a hidden internal network you can't reach directly. Now what?"
- **Direct instruction (15–20 min):** Concepts only (no deep lab): **pivoting** — using a compromised machine as a stepping stone to reach machines you couldn't reach directly; **port forwarding** and **SSH tunneling** — redirecting/encapsulating traffic to reach blocked services. Diagram attacker → foothold box → hidden internal box. Introduce the **local port forward** (`ssh -L`) idea.
- **Guided practice / demo (15 min):** Instructor runs a simple `ssh -L` **local port-forward** on the **isolated lab** to reach a service that wasn't directly reachable. Students follow the optional simple demo in `lab.md` if the lab supports it.
- **Independent practice / lab:** Students write, **in their own words**, what pivoting is and why both attackers and defenders care; sketch the pivot diagram in the journal.
- **Closure / exit ticket (5 min):** "Explain pivoting to a friend who's never heard the term, in two sentences."

### Day 5 — Active Directory awareness + the defense + wrap-up
- **Warm-up (5–10 min):** "How does a company manage 5,000 Windows computers and accounts without setting each one up by hand?" → AD.
- **Direct instruction (15 min):** **Active Directory** at **awareness level**: what it is (central management of Windows computers, users, permissions), the **Domain Controller**, and why enterprises use it — note clearly that deep AD attacks are **out of scope** here. Then the **defense** for everything this unit: **detection/logging** (Metasploit and pivots leave signatures), **EDR** (catches Meterpreter-style behavior on hosts), **network segmentation** (limits pivoting), and **patching** (closes the exploits frameworks rely on). Map each defense to what it stops.
- **Guided practice / independent lab:** Students finish the Metasploit room, complete their **session journal**, and write the short **pivoting explanation** in their own words. Add the matching **defense** for the exploit they used.
- **Closure / exit ticket (5 min):** Submit the Metasploit journal + pivoting writeup; one-sentence reflection: "the most important reason not to be 'just a tool runner' is ___."
- **Assessment:** Unit quiz (`assessment.md`) at end of Day 5 or start of Week 17.

## Differentiation
- **Support:** Provide the msfconsole cheat-sheet as a copy/paste command list. Pair students for the room. Give a fill-in workflow card (`search ___ → use ___ → set RHOSTS ___ → set LHOST ___ → exploit`). Pre-fill the pivot diagram so students annotate rather than draw from scratch. Use the browser-based AttackBox for students whose VMs struggle. Offer sentence starters for the "pivoting in your own words" task.
- **Extension:** Have students compare doing the room's exploit **with Metasploit** vs. researching how the **manual** exploit works (no need to run it). Ask them to write a short "how would a defender detect this Meterpreter session?" analysis. Research and summarize one real reason **network segmentation** stopped or limited a breach (root cause, no attack steps). Challenge: explain the difference between local, remote, and dynamic port forwarding in plain language.

## Homework / independent work
- Finish the TryHackMe Metasploit room if not completed in class; paste journal evidence (commands + session proof).
- Write a **plain-English explanation** (5–6 sentences) of **pivoting** and why it matters to attackers *and* defenders.
- Write one line each: how would **detection/logging**, **EDR**, **segmentation**, and **patching** each blunt a Metasploit-driven attack?
- Short reflection (½ page): "Why is it dangerous to be 'just a tool runner,' and how does understanding the manual approach make you a better defender?"

## Assessment
- **Formative:** Daily exit tickets; instructor walk-around verifying each student can run the msfconsole workflow and open a Meterpreter session; the module-types check; the pivot diagram.
- **Summative:** Unit quiz + the **Metasploit session journal** and **pivoting writeup** (contributes to the lab-journal grade) — see `assessment.md`.

## Instructor notes & common pitfalls
- **Isolation is non-negotiable.** Metasploit and tunneling only ever touch the isolated/authorized lab. Re-state it every lab day. The ease of the tool makes the authorization rule *more* important, not less.
- **The headline lesson is "don't be a tool runner."** Keep returning to it: tools fail, get detected, or don't fit — the professional understands the manual version underneath.
- Students mix up **RHOSTS** (the target) and **LHOST** (their own listener). Drill this; most "it won't connect" problems are a wrong LHOST.
- They also confuse **exploit** vs **payload**. Anchor it: exploit = gets you in; payload = what runs once you're in (Meterpreter is a payload).
- Keep **msfvenom** awareness-level: explain and maybe show one command's *output description* — do not build or deploy real payloads.
- Keep **pivoting/tunneling conceptual** with one simple `ssh -L` demo. Don't rabbit-hole into proxychains/dynamic tunnels — concept + one demo is the target.
- Keep **Active Directory** strictly awareness-level; AD attacks are flagged out-of-scope in the crosswalk.
- Always close the loop with the **defense.** Every capability shown (exploit, Meterpreter, pivot) gets paired with detection/EDR/segmentation/patching.
