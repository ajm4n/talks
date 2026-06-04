# Unit 12 Lab — SQL Injection on DVWA (and optional TryHackMe SQLi room)

- **Platform:** DVWA (Damn Vulnerable Web Application) on the isolated lab + Kali/AttackBox browser. Optional: TryHackMe "SQL Injection" room (browser-based, free tier).
- **Time:** ~120 min across Days 2–4
- **Difficulty:** beginner

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment. Doing this to any
system you do not own or have written permission to test is illegal.

DVWA is **deliberately broken**. It must live on a fully **isolated** (host-only / internal) network and must **never** touch the real internet or a school system. SQL injection — and the `sqlmap` tool — pointed at any unauthorized database is a crime under the CFAA and state law and can destroy real data and real people's privacy. The **only** legal targets in this lab are **DVWA** and **authorized TryHackMe rooms**. If you are ever unsure whether something is in scope, stop and ask the instructor. The goal of this lab is to become a better defender: once you see how easily an unprotected query falls, you will know exactly how to fix it.

## Objectives
- Log into DVWA and set the security level to **Low**.
- Perform a classic authentication-bypass / `' OR '1'='1`-style injection and explain why it works.
- Use **UNION-based** injection to extract usernames and password hashes from the lab's user table.
- Run **`sqlmap`** against the **DVWA target only** and compare it to the manual attack.
- Raise DVWA security to **High/Impossible**, re-run the same injections, watch them fail, and use "View Source" to explain *why* (prepared statements).
- Record everything in the lab journal as evidence for the web-vuln writeup project.

## Setup
1. Start the isolated lab. Confirm with the instructor that networking is **host-only/internal** before doing anything else.
2. Start the DVWA VM (or Metasploitable 2 hosting DVWA) and your Kali/AttackBox.
3. From Kali's browser, go to DVWA (e.g., `http://<DVWA-IP>/`) and log in with the class-provided default credentials.
4. Click **DVWA Security** in the left menu and set the level to **Low**. Click **Submit**.
5. Open your **lab journal** and write the date, objective, and the DVWA IP. Take a baseline screenshot of the SQL Injection page.

## Walkthrough

### Step 1 — Read the target like a normal user (Security = Low)
Open the **SQL Injection** page. It asks for a **User ID**. Type a normal value:
```
1
```
Click **Submit**. Expected output: the app returns the first name and surname for user 1. This is the *intended* behavior — note in your journal what a normal, safe query returns.

### Step 2 — Confirm the input is injectable
In the **User ID** box, type a single quote:
```
'
```
Submit. Expected output: a **database error** (or odd/broken output). That error means your input reached the SQL query as **code**, not just data. Screenshot it — this is your proof the field is injectable.

### Step 3 — Authentication-bypass style injection (always-true condition)
Enter an always-true condition so the WHERE clause matches **every** row:
```
1' OR '1'='1
```
Submit. Expected output: the app returns **many rows / all users**, not just user 1. In your journal, write the query *before* and *after* in plain terms:
- Intended: `SELECT first_name, surname FROM users WHERE user_id = '1'`
- After injection: `SELECT first_name, surname FROM users WHERE user_id = '1' OR '1'='1'`

Explain in one sentence why this dumps every user: the `OR '1'='1'` is always true, so the filter no longer filters.

### Step 4 — Find the number of columns (prep for UNION)
A `UNION` only works when both queries return the **same number of columns**. Increase the count until the error disappears:
```
1' ORDER BY 1 -- -
1' ORDER BY 2 -- -
1' ORDER BY 3 -- -
```
Expected output: it works at 1 and 2, then **errors at 3**. That means the query returns **2 columns**. (`-- -` is a SQL comment that ignores the rest of the original query. Keep the space after `--`.)

### Step 5 — UNION-based extraction
Now attach your own query that returns 2 columns. First prove control:
```
1' UNION SELECT 1,2 -- -
```
Expected output: a row showing `1` and `2`, confirming your data is displayed. Now pull real data — usernames and password hashes from the `users` table:
```
1' UNION SELECT user, password FROM users -- -
```
Expected output: a list of **usernames and their (MD5) password hashes**. Screenshot it. In your journal, note: these are hashes, not plaintext — cracking them is Unit 14's topic, but here you have already *extracted the credential store*, which is a critical-severity finding.

### Step 6 — Awareness: error-based vs blind (no full lab, just observe)
You used the database's **error message** in Step 2 to confirm injection — that is the idea behind **error-based** SQLi. If the app showed **no output and no errors**, you would have to ask the database **true/false questions** and watch the page or its timing change — that is **blind** SQLi. Write one sentence in your journal contrasting the two. (Optional: the TryHackMe SQLi room has a dedicated blind section.)

### Step 7 — Automate with sqlmap (DVWA target ONLY)
Re-read the safety reminder. `sqlmap` is loud and powerful; point it **only** at DVWA. You will need DVWA's session cookie (copy it from the browser's developer tools / DVWA login). Example:
```
sqlmap -u "http://<DVWA-IP>/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=<your-session>; security=low" --batch --dbs
```
Expected output: sqlmap confirms the parameter is injectable and lists the **databases**. To dump the same user table you got by hand:
```
sqlmap -u "http://<DVWA-IP>/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=<your-session>; security=low" --batch -D dvwa -T users --dump
```
Expected output: sqlmap dumps the `users` table (and may offer to crack the hashes). Save the output to your journal. Note in one line: sqlmap automated exactly what you did manually — that is *why* it is dangerous if misused.

### Step 8 — The defense: raise security and watch it fail
Go to **DVWA Security** and set the level to **High** (or **Impossible**). Re-run your Step 3 and Step 5 injections.
```
1' OR '1'='1
1' UNION SELECT user, password FROM users -- -
```
Expected output: the injections **no longer work** — no extra rows, no dump. Now click **View Source** on the SQL Injection page at both **Low** and **High/Impossible** and compare the code. Expected difference: the **Low** code glues your input straight into the SQL string; the **High/Impossible** code uses a **parameterized query / prepared statement** (input is bound as a parameter, e.g., `?`), so your quote is treated as harmless data, not code. Screenshot both source views side by side.

### Step 9 — Write it up
In your journal, record for the SQLi finding: description, exact reproduction steps (the payloads above), evidence (screenshots), impact (full credential-store disclosure → likely **High/Critical**), and the remediation (**use parameterized queries/prepared statements**, plus input validation and least-privilege DB accounts). This becomes one finding in the Module 3 web-vuln writeup project.

## Deliverables
- Lab journal entries for Steps 1–9 with labeled screenshots (normal query, the `'` error, the all-users dump, the UNION hash dump, sqlmap output, and the Low-vs-High **View Source** comparison).
- A plain-English explanation (5–6 sentences) of why `' OR '1'='1` works.
- A draft **SQLi finding writeup** (description → reproduction → evidence → impact → remediation) for the web-vuln writeup project (rubric in `instructor/grading-and-rubrics.md`).

## Stretch goals (optional)
- Complete the TryHackMe "SQL Injection" room and finish its **blind** (boolean/time-based) section; record one true/false question you asked the database.
- Explore `sqlmap` flags `--current-user`, `--current-db`, and `--passwords` (lab-only) and explain each in your own words.
- Write a short "how a prepared statement works under the hood" note based on the DVWA Impossible source.
- Research one real-world SQLi breach and summarize the root cause and the fix (no attack instructions).

## Answer key (instructor only)
- **Step 1:** `1` → returns `ID: 1 First name: admin Surname: admin` (exact names depend on DVWA seed data).
- **Step 2:** `'` → MySQL syntax error, e.g., *"You have an error in your SQL syntax..."*. Confirms input reaches the query unsanitized.
- **Step 3 (auth bypass / always-true):** `1' OR '1'='1` → returns **all rows** in `users`. Resulting query: `... WHERE user_id = '1' OR '1'='1'`. The `OR '1'='1'` is always true, so the filter is defeated. Equivalent classic login-form payload students should recognize: username `' OR '1'='1' -- -`.
- **Step 4 (column count):** `ORDER BY 3` errors → table returns **2 columns**.
- **Step 5 (UNION):**
  - Proof: `1' UNION SELECT 1,2 -- -` shows `1` / `2`.
  - Extraction: `1' UNION SELECT user, password FROM users -- -` → usernames + **MD5** hashes (DVWA default users include `admin`, `gordonb`, `1337`, `pablo`, `smithy`). Useful extras: `1' UNION SELECT user, password FROM users -- -`; database/version recon `1' UNION SELECT @@version, database() -- -`.
- **Step 6:** Error-based = data/confirmation leaks via DB error messages; blind = no visible output, infer data via true/false (boolean) or response timing (time-based).
- **Step 7 (sqlmap):** Must include the **session cookie** and `security=low`. `--dbs` lists databases (expect `dvwa`, `information_schema`, etc.); `-D dvwa -T users --dump` dumps the user table; `--batch` accepts defaults non-interactively. Emphasize lab-only and that sqlmap reproduces the manual attack.
- **Step 8 (defense):** At **High/Impossible** the same payloads fail. **View Source** shows the difference:
  - *Low:* `$query = "SELECT ... WHERE user_id = '$id';";` — input concatenated into SQL.
  - *Impossible:* uses **PDO prepared statement** with a bound parameter (`:id` / `?`), so input is never parsed as SQL. This is the single most direct fix.
- **Step 9 (finding):** Expected severity **High/Critical** (full credential disclosure, possible data tampering). Required remediation: **parameterized queries/prepared statements** (primary), input validation (defense in depth), least-privilege DB account (limits blast radius). Attacks are always paired with defenses — do not accept a finding without a remediation.
- **Reset:** If DVWA breaks or a student gets stuck, restore from the snapshot per `instructor/lab-setup-guide.md`. Mastery over first-try success.
