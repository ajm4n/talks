# Unit 11 — Common Web Attacks (XSS, Command Injection, File Inclusion)

- **Module:** Module 3 — Exploitation
- **Suggested week:** Week 11
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Common Web Application Attacks (Cross-Site Scripting, Command Injection, File Inclusion / directory traversal) + (awareness) Client-side Attacks

> In Unit 10 you learned how the web talks and how to read and modify a request. Now we ask the question every web attack comes down to: *what happens when an application trusts input it should not trust?* Almost every bug in this unit has the same root cause — **unvalidated input** — and the same kind of cure — **validate, encode, and isolate that input**. For every attack we study, we will study its **defense**, because the whole point of learning to break a web app is to learn how to build one that doesn't break.

## Learning objectives
By the end of this unit, students can:
- **Explain** why **unvalidated/untrusted input** is the common root cause behind XSS, command injection, and file inclusion.
- **Define and distinguish** the three main types of **Cross-Site Scripting (XSS)**: reflected, stored, and DOM-based.
- **Demonstrate** a reflected and a stored XSS in DVWA at low security and **explain** what the injected script does.
- **Describe** the defender fixes for XSS — **output encoding** and a **Content Security Policy (CSP)** — and explain *why* each works.
- **Demonstrate** a **command injection** in DVWA and **explain** how user input reached an operating-system command.
- **Describe** the defender fixes for command injection (avoid calling the shell, use safe APIs, allow-list/validate input).
- **Demonstrate** a **Local File Inclusion (LFI)** with **directory traversal** in DVWA and **distinguish** LFI from **Remote File Inclusion (RFI)**.
- **Describe** the defender fixes for file inclusion (validate file paths, allow-list, disable remote includes).
- **Observe and explain** how raising DVWA's **security level** (stronger input validation) blocks each attack.
- **Describe** at an awareness level what **client-side attacks** are and how they differ from server-side attacks.
- **Pair every attack with its defense** in writing, in the lab journal.

## Standards alignment
- **NICE Framework:** Knowledge of web application security risks (K0624); knowledge of software/application vulnerabilities and exploitation (K0070, K0624); Task — assess and recommend mitigations for web application vulnerabilities (T0549, T0250). Work role exposure: Vulnerability Assessment Analyst, Secure Software Assessor, Cyber Defense Analyst.
- **CSTA / state CS standards:** 3A-NI-05 (network/application security), 3A-IC-24 (security implications of computing), 3B-NI-04 (mitigation of security risks), 3B-AP-21 (develop and test secure programs).
- **Security+ domain(s):** 2.0 (Threats/vulnerabilities — injection, XSS), 3.0 (Secure architecture — input validation, CSP), 4.0 (Security operations — secure coding/mitigations).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Input validation | Checking that input is the expected type, length, and format before trusting it. |
| Untrusted input | Any data that came from the user or outside world; it must be checked before use. |
| Allow-list (whitelist) | Only permitting input that matches a list of known-good values; safer than blocking bad ones. |
| Sanitization | Cleaning input by removing or neutralizing dangerous characters. |
| Cross-Site Scripting (XSS) | A bug that lets an attacker run their **JavaScript** in another user's browser. |
| Reflected XSS | XSS where the malicious input bounces straight back in the response (often via a URL/parameter). |
| Stored XSS | XSS where the malicious input is **saved** by the app and runs for everyone who views it later. |
| DOM-based XSS | XSS that happens entirely in the browser when client-side JavaScript mishandles input. |
| Payload | The piece of input an attacker crafts to trigger a bug (e.g., a `<script>` tag). |
| Output encoding | Converting characters so the browser shows them as text instead of running them as code. |
| Content Security Policy (CSP) | A response header that tells the browser which scripts are allowed to run, limiting XSS. |
| Command injection | A bug where user input is passed into an operating-system command, letting an attacker run their own commands. |
| Shell | The program that runs operating-system commands (like Bash); the danger zone for injection. |
| Safe API / parameterization | Calling a function the safe way so input is treated as **data**, never as a command. |
| File Inclusion | A bug where the app loads a file chosen by user input. |
| Local File Inclusion (LFI) | File inclusion that loads a file already on the server (e.g., `/etc/passwd`). |
| Remote File Inclusion (RFI) | File inclusion that loads a file from a remote URL the attacker controls. |
| Directory traversal | Using `../` sequences to climb out of a folder and reach files you shouldn't. |
| Client-side attack | An attack aimed at the user's machine/browser (e.g., a malicious file or script), not the server. |
| Security level (DVWA) | A DVWA setting (low/medium/high) that turns input validation on stronger as it rises. |
| Defense-in-depth | Using several layers of protection so one failure doesn't break everything. |

## Materials & prep
- **DVWA (Damn Vulnerable Web Application)** — free, intentionally vulnerable practice app, run **only** in the isolated class lab (TryHackMe "Damn Vulnerable Web Application" / "DVWA" room, or a local Docker/VM image). Browser-based via TryHackMe AttackBox is simplest.
- **Burp Suite Community Edition** (from Unit 10) for intercepting/modifying requests, plus the browser's Developer Tools.
- A modern browser (Firefox/Chrome).
- Projector for live demos.
- Handouts: "Attack ↔ Defense" pairing chart (XSS / command injection / LFI-RFI); XSS-types comparison table; sample-payload reference (instructor copy); web-vuln observation sheet (in `lab.md`).
- **Instructor prep notes:**
  - **Isolation is mandatory.** DVWA is deliberately full of holes — never expose it to the internet or the school network. Use the TryHackMe AttackBox (sandboxed) **or** a host-only VM/Docker container. Confirm before students touch it.
  - Pre-stage DVWA: set the database up, log in (`admin` / `password` on most images), and verify you can change the **Security Level** (DVWA Security page) between **low** and **medium/high**.
  - Pre-test one example of each attack at **low** security AND confirm it is **blocked** at a higher level, so the "raise the security level → input validation blocks it" demo works live.
  - Decide how students switch security levels (each gets their own instance on the AttackBox is cleanest).
  - Keep the **sample-payload reference** as an instructor copy; release payloads to students gradually so the focus stays on *why*, not copy-paste.
  - Reconfirm Burp setup from Unit 10 still works on classroom machines.

## ⚖️ Ethics & legal callout
This unit teaches attacks that, used against a real site, can **steal other people's sessions** (XSS), **run commands on someone else's server** (command injection), or **read files that aren't yours** (file inclusion). Doing any of these to a system you don't own or lack **written permission** to test is a serious crime under laws like the CFAA — there is no "I was just curious" exception. Everything here runs against **DVWA, an app built on purpose to be broken**, inside an **isolated lab**. We pair every attack with its defense for a reason: the goal is to become the person who *fixes* these bugs. The dividing line never changes — **authorization and scope**.

**Discussion prompt:** A stored-XSS payload you plant lives in the database and runs in **every** future visitor's browser — including people who never consented and have no idea. Even in a lab this feels different from a one-off test. Why is *stored* XSS considered more dangerous than *reflected* XSS, and what makes attacks that affect other users an especially serious ethical line to respect?

## Lesson sequence

### Day 1 — Root cause: input validation, and intro to XSS
- **Warm-up (5–10 min):** "If a website shows your comment back to you exactly as you typed it, what could go wrong if you typed something other than words?" Students brainstorm.
- **Direct instruction (15–20 min):** The unifying theme — **untrusted input** is the root cause of this whole unit. Introduce **XSS**: it lets an attacker's **JavaScript run in someone else's browser**. The three types: **reflected** (bounces back in the response), **stored** (saved and served to others), **DOM-based** (happens in the browser's JS). Why it matters: stealing cookies/sessions, defacing pages, keylogging.
- **Guided practice (15 min):** Using the XSS-types comparison table, students match scenarios to reflected/stored/DOM and predict who is affected.
- **Independent practice / lab:** Set up DVWA (Unit 11 lab, Setup + Step 1); confirm security level = **low**. Read the Safety reminder aloud.
- **Closure / exit ticket (5 min):** "In one sentence, what is the difference between reflected and stored XSS?"

### Day 2 — XSS hands-on + the XSS defenses
- **Warm-up (5–10 min):** "Where does the browser decide whether `<script>` is text to display or code to run?"
- **Direct instruction (15–20 min):** Walk the reflected and stored XSS demo conceptually. Then the **defenses**: **output encoding** (turn `<` into `&lt;` so it shows as text, not code) and **Content Security Policy (CSP)** (a header that restricts which scripts the browser will run). *Why* each works.
- **Guided practice / lab:** DVWA lab Steps 2–3 — trigger a **reflected** and a **stored** XSS at low security; record the payload and what it did.
- **Independent practice:** Add the matching **defense** for XSS to the Attack↔Defense chart in the journal.
- **Closure / exit ticket (5 min):** "How does output encoding stop XSS? Answer in one sentence."

### Day 3 — Command injection + its defenses
- **Warm-up (5–10 min):** "A web tool pings an address you type in. What if you typed more than an address?"
- **Direct instruction (15–20 min):** **Command injection** — when user input is handed to the operating-system **shell**, an attacker can chain extra commands (e.g., `; whoami`). How input reaches a command. **Defenses:** don't call the shell at all; use **safe APIs / parameterization**; **validate and allow-list** input; run with least privilege.
- **Guided practice / lab:** DVWA lab Step 4 — perform a command injection at low security on the "ping" page; record what command ran and its output.
- **Independent practice:** Add the command-injection row to the Attack↔Defense chart.
- **Closure / exit ticket (5 min):** "Name one defense against command injection and say why it works."

### Day 4 — File inclusion (LFI/RFI) + directory traversal + defenses
- **Warm-up (5–10 min):** "If a page loads a file based on `?page=home`, what happens if you ask it for `?page=../../something-secret`?"
- **Direct instruction (15–20 min):** **File Inclusion** — the app loads a file chosen by input. **LFI** (a file already on the server, e.g., `/etc/passwd`) vs **RFI** (a file from a remote attacker URL). **Directory traversal** with `../` to escape a folder. **Defenses:** validate/allow-list the requested file, never build paths straight from input, disable remote includes (`allow_url_include=Off`).
- **Guided practice / lab:** DVWA lab Step 5 — perform an **LFI** with directory traversal at low security; record the path and what you could read. Discuss why RFI is even more dangerous (remote code).
- **Independent practice:** Add the file-inclusion row to the Attack↔Defense chart.
- **Closure / exit ticket (5 min):** "What does `../` do in a file path, and what is it called?"

### Day 5 — Raise the security level + client-side awareness + lab finish
- **Warm-up (5–10 min):** "If the same attack worked yesterday but is blocked today, what probably changed in the code?"
- **Direct instruction (10–15 min):** Live demo — re-run one attack at DVWA **medium/high** security and watch it get **blocked**; tie this directly back to **input validation** as the cure. Brief **client-side attacks** awareness: attacks aimed at the user's machine/browser (malicious documents, drive-by scripts, social engineering) vs the server-side bugs we attacked. (Full client-side exploitation is out of scope for HS.)
- **Guided practice / independent lab:** DVWA lab Step 6 — re-run each attack at a higher security level and record whether/how it was blocked, completing the Attack↔Defense chart.
- **Closure / exit ticket (5 min):** Submit the completed Attack↔Defense chart; one sentence on "the common root cause behind all three attacks."
- **Assessment:** Unit quiz (`assessment.md`) at end of Day 5 or start of Week 12. Lab journal feeds the **Module 3 web-vuln writeup project**.

## Differentiation
- **Support:** Provide the partially completed Attack↔Defense chart and the XSS-types table to reference. Release sample payloads one at a time with the exact field to paste them into pre-marked. Use the TryHackMe AttackBox so there is no install. Pair students. Give sentence frames for journal entries ("I tested ___ on the ___ page. My payload was ___. It worked/was blocked because ___. The defense for this is ___ because ___."). Keep the security-level switch instructions on the board.
- **Extension:** Try a **DOM-based** XSS and explain why output encoding alone may not fix it. Capture a fake "stolen cookie" using your **own** test endpoint to see why XSS is dangerous (lab only). Read DVWA's **source for two security levels** (low vs high) and write what changed in the code to add validation. Research one real CVE for each attack class and summarize the fix. Explore how a **CSP** header is written and test what it blocks.

## Homework / independent work
- Complete the Attack↔Defense chart for all three attack classes if not finished in class.
- ½-page write-up: "Why is *unvalidated input* the root cause of XSS, command injection, and file inclusion? Use one example of each."
- For each attack, write the **one defensive fix you think is most important** and defend your choice in 2–3 sentences.
- Read the OWASP page (linked by instructor) for **Injection** and **XSS** and list one new fact about each.

## Assessment
- **Formative:** Daily exit tickets; XSS-types matching; the running Attack↔Defense chart checked each day; instructor verification that each student can trigger at least one attack at low security **and** observe it blocked at a higher level.
- **Summative:** Unit quiz + lab-journal **web-vuln observations** deliverable — see `assessment.md`. These observations feed forward into the Module 3 web-vuln writeup project.

## Instructor notes & common pitfalls
- **Isolation first, always.** DVWA must never be reachable from the internet or the school network. Re-state this and verify the sandbox before any student opens DVWA.
- The single most important conceptual win: **every attack here shares one root cause (untrusted input) and one cure (validate/encode/isolate it).** Keep returning to that frame so students don't memorize three unrelated tricks.
- **Always pair attack with defense** — never demo an exploit without immediately doing/charting its fix. This is the curriculum's "break it to defend it" promise.
- Students confuse the **three XSS types**: reflected = bounces back now; stored = saved and hits *other* users later (most dangerous); DOM = happens in the browser's JavaScript. Use the comparison table every day.
- Command injection: students forget the input goes to a **shell**; show the actual injected command (`; whoami`, `; ls`) and the OS output so the danger is concrete.
- File inclusion: clarify **LFI** (file on the server) vs **RFI** (remote attacker file → can run attacker code, worse). Make sure students see `../` directory traversal explicitly.
- The **raise-the-security-level** demo is the payoff — if a student's attack "stops working," that is the **lesson**, not a bug. Have them read what validation was added.
- Manage payloads: keep the instructor sample-payload list private and release gradually; emphasize *understanding* over copy-paste.
- Reinforce ethics hard: stored XSS and command injection affect **other people/other systems** — name why that raises the stakes beyond a personal "test."
