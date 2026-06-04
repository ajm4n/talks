# Unit 12 — SQL Injection

- **Module:** Module 3 — Exploitation
- **Suggested week:** Week 12
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** SQL Injection

> Units 10 and 11 introduced web application attacks (how the web works, and injection-style bugs like XSS and command injection). Unit 12 zooms in on one of the most famous and damaging web bugs of all time: **SQL injection (SQLi)**. You'll see how a single quote in the wrong place can dump an entire database — and exactly how a developer stops it. This unit lands right before the Module 3 **web-vulnerability writeup project**, so what you find here becomes evidence for that report.

## Learning objectives
By the end of this unit, students can:
- **Define** what a database and SQL are, and **write** a simple `SELECT ... WHERE` query in plain terms.
- **Explain** how a web application turns user input into a database query, and **why** mixing untrusted input into a query is dangerous.
- **Describe** SQL injection in their own words as "untrusted input changing the meaning of a query."
- **Perform** a classic authentication bypass (`' OR '1'='1`) against an intentionally-vulnerable lab app and **explain** why it works.
- **Demonstrate** UNION-based data extraction at a conceptual level and extract sample data from a lab target.
- **Distinguish** error-based from blind SQL injection at an awareness level.
- **Use** `sqlmap` responsibly against a lab-only target and explain why automated tools must never be pointed at unauthorized systems.
- **Recommend** layered defenses — **parameterized queries / prepared statements**, input validation, and least privilege — and **show** that raising DVWA's security level stops the attack.

## Standards alignment
- **NICE Framework:** Knowledge of application vulnerabilities and secure coding (K0009, K0070, K0624); Tasks — assess application security, recommend mitigations (T0111, T0176). Work role exposure: Vulnerability Assessment Analyst, Secure Software Assessor.
- **CSTA / state CS standards:** 3A-IC-30 (evaluate impacts of computing/data), 3B-AP-18 (explain security risks of software), 3A-AP-21 (use data structures/queries).
- **Security+ domain(s):** 2.0 (Threats/vulnerabilities — injection), 3.0 (Secure application design — input validation, parameterized queries).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Database | An organized store of data, usually arranged in tables of rows and columns. |
| Table | A grid in a database; columns are fields (like `username`), rows are records. |
| SQL | Structured Query Language — the language used to ask a database questions. |
| Query | A request sent to a database, like "give me the user named Maya." |
| SELECT | The SQL command that reads/returns data. |
| WHERE | The part of a query that filters which rows you get. |
| SQL injection (SQLi) | A flaw where untrusted user input changes the *meaning* of a database query. |
| Untrusted input | Any data that came from a user/outside source and can't be assumed safe. |
| Authentication bypass | Tricking a login so it lets you in without valid credentials. |
| UNION-based SQLi | Using SQL's `UNION` to attach attacker-chosen data to the app's results, extracting other tables. |
| Error-based SQLi | Pulling data out through the database's error messages. |
| Blind SQLi | Extracting data with no visible output, by asking true/false questions and watching the app's behavior or timing. |
| sqlmap | An automated tool that finds and exploits SQL injection (lab-only in this class). |
| Parameterized query / prepared statement | A safe way to write queries where input is sent as *data*, never mixed into the SQL text. |
| Input validation | Checking that input matches what's expected (type, length, format) before using it. |
| Least privilege | Giving an account only the access it needs — so a breach does less damage. |
| DVWA | Damn Vulnerable Web Application — a practice app built to be safely attacked. |

## Materials & prep
- **DVWA** (Damn Vulnerable Web Application) running on the isolated lab — either the dedicated DVWA VM or DVWA inside Metasploitable 2. Free.
- **Kali Linux** VM (or the TryHackMe AttackBox) with a browser and `sqlmap` (pre-installed on Kali). Free.
- Optional: **TryHackMe** "SQL Injection" room (browser-based, free tier). Confirm access on the school network.
- Projector/whiteboard for diagramming a query and the "input becomes code" idea.
- Handouts: a one-page SQL primer (SELECT/WHERE), the SQLi observation sheet (in `lab.md`), the web-vuln writeup rubric from `instructor/grading-and-rubrics.md`.
- **Instructor prep notes:**
  - Confirm the lab is **fully isolated** (host-only/internal network) — DVWA is *deliberately broken* and must never touch a real network. See `instructor/lab-setup-guide.md`.
  - Pre-set DVWA's **DVWA Security** level to **Low** for Days 2–3, and confirm you can raise it to **High**/**Impossible** for the Day 4 defense demo. Log in with the default DVWA credentials and create snapshots so students can reset.
  - Walk the DVWA SQLi page yourself first; note the exact field, the data that comes back, and the source-code view DVWA exposes (the "View Source" button shows the vulnerable vs. fixed code — this is gold for the defense lesson).
  - Decide whether students run `sqlmap` (Day 3) or only watch a demo, based on time and machine performance.

## ⚖️ Ethics & legal callout
SQL injection is not a gray area. Pointing it — or `sqlmap` — at any database you do not own or have **written permission** to test is a crime under the CFAA and state law, and it can destroy real data and real people's privacy. Some of the largest breaches in history started with a single injectable form field. In this unit you attack **DVWA and authorized TryHackMe rooms only** — apps that exist to be broken. The skill you're learning is *defense*: once you've seen how easily an unprotected query falls, you'll never write one again, and you'll know how to fix the ones you find.

**Discussion prompt:** A student finds that their part-time job's online order form returns extra data when they type a quote mark. They're curious whether it's "really vulnerable." What's the responsible next step — and what would crossing the line look like? Where exactly is the authorization boundary here?

## Lesson sequence

### Day 1 — Databases & SQL, and where the bug lives
- **Warm-up (5–10 min):** "When you log into a website, how does it *know* your password is right?" Collect guesses. (It looks you up in a database.)
- **Direct instruction (15–20 min):** Quick database primer — tables, rows, columns. Introduce `SELECT name FROM users WHERE name = 'Maya'`. Then show how a web login builds that query from a form: the app glues your typed username/password into a SQL string. Name the danger: the app can't tell *your data* from *SQL commands* if it just pastes input into the query.
- **Guided practice (15 min):** On the board, students help build a login query, then the instructor types `Maya' --` into the "username" and the class predicts what the query becomes. Define untrusted input, query, SELECT, WHERE.
- **Independent practice / lab:** Read the SQL primer handout; in journals, write one `SELECT ... WHERE` query in plain English and in SQL.
- **Closure / exit ticket (5 min):** "In one sentence: why is gluing user input directly into a SQL query dangerous?"

### Day 2 — Authentication bypass (`' OR '1'='1`)
- **Warm-up (5–10 min):** Show the login query from Day 1. "What if the WHERE condition could always be true?"
- **Direct instruction (15–20 min):** Walk through `' OR '1'='1` step by step: how it closes the string, adds an always-true condition, and comments out the rest. Show the *before* query and the *after* query side by side. Emphasize: the attacker didn't guess a password — they rewrote the question.
- **Guided practice (15 min):** As a class, "run" the bypass on paper against the sample query and identify which row(s) come back.
- **Independent practice / lab:** **Read the Safety & authorization reminder in `lab.md` aloud.** Begin the DVWA SQLi lab (Security = Low): perform the auth-bypass / `' OR '1'='1`-style injection in the DVWA SQL Injection page and record what comes back.
- **Closure / exit ticket (5 min):** "Explain in your own words why `' OR '1'='1` lets someone in without a password."

### Day 3 — Pulling data out: UNION, error-based, blind, and sqlmap
- **Warm-up (5–10 min):** "Getting in is one thing. How would an attacker *read the whole user table*?"
- **Direct instruction (15–20 min):** Introduce UNION-based extraction conceptually: `UNION SELECT` lets you append a second query's results. Briefly contrast **error-based** (data leaks through error messages) and **blind** (no output — ask yes/no questions, watch responses or timing) at an awareness level. Introduce `sqlmap` as an automated tool — and immediately frame it as lab-only, "loud," and dangerous if misused.
- **Guided practice (15 min):** Instructor demo (or paced student work): UNION-based extraction in DVWA to pull usernames/password hashes from the lab's user table.
- **Independent practice / lab:** Continue the DVWA lab — UNION extraction; then run `sqlmap` against the **DVWA target only** to see it automate what you did by hand. Save the output to the journal.
- **Closure / exit ticket (5 min):** "Name the three SQLi styles we mentioned and one difference between UNION-based and blind."

### Day 4 — The defense: prepared statements stop it
- **Warm-up (5–10 min):** "If you were the developer, how would you make `' OR '1'='1` do nothing?"
- **Direct instruction (15–20 min):** Defense in depth: (1) **parameterized queries / prepared statements** — input is sent as data, never as code, so quotes lose their power; (2) **input validation** — reject input that isn't the expected type/format; (3) **least privilege** — the web app's DB account shouldn't be able to read every table. Use DVWA's "View Source" to compare the vulnerable Low code with the fixed High/Impossible code.
- **Guided practice (15 min):** Raise **DVWA Security to High/Impossible** and re-try the same injections from Days 2–3. They fail. Students record *why*, citing the source-code difference.
- **Independent practice / lab:** Complete the DVWA defense portion; annotate the before/after in the journal. (Optional: TryHackMe SQLi room for extra practice.)
- **Closure / exit ticket (5 min):** "Which single defense most directly stops SQL injection, and why?"

### Day 5 — Document it (feeds the web-vuln writeup project)
- **Warm-up (5–10 min):** "What would a developer need from you to fix this bug?" (Clear steps, evidence, a fix.)
- **Direct instruction (10 min):** Review the **penetration-test / web-vuln report rubric** (`instructor/grading-and-rubrics.md`): finding → evidence → severity/impact → remediation. SQLi is typically **High/Critical** severity.
- **Guided practice / independent lab:** Students turn their DVWA SQLi journal into a clean **finding writeup**: description, reproduction steps, evidence (screenshots), impact, and the prepared-statement fix. This becomes one finding in the Module 3 web-vuln writeup project.
- **Closure / exit ticket (5 min):** Submit the SQLi finding draft; one-sentence reflection: "biggest surprise about how easy/hard this was."
- **Assessment:** Unit quiz (`assessment.md`) at end of Day 5 or start of Week 13.

## Differentiation
- **Support:** Provide a pre-filled "query before / query after" template for the `' OR '1'='1` analysis. Pair students for the DVWA lab. Give sentence frames for the finding writeup ("The vulnerability is ___. To reproduce: ___. The impact is ___ because ___. The fix is ___."). Offer the browser-based TryHackMe room for students whose VMs struggle. Pre-load `sqlmap` command as a copy/paste line so syntax isn't a barrier.
- **Extension:** Have students extract data using **blind** techniques (boolean/time-based) in a TryHackMe room rather than UNION; explore `sqlmap`'s `--dump` and `--dbs` flags (lab-only) and explain each flag; write a short "how a prepared statement works under the hood" note; or research one real-world SQLi breach and summarize the root cause and fix (no attack instructions).

## Homework / independent work
- Finish the DVWA SQLi lab and/or the TryHackMe SQLi room if not done in class.
- Write the **plain-English explanation** of `' OR '1'='1` (5–6 sentences) in the journal.
- Complete the SQLi finding draft for the web-vuln writeup project.
- Short reflection (½ page): "Why does a prepared statement defeat injection, when input validation alone might not?"

## Assessment
- **Formative:** Daily exit tickets; the paper "run the bypass" check; instructor walk-around during DVWA labs verifying each student can perform and explain the bypass; the before/after security-level demo.
- **Summative:** Unit quiz + SQLi finding writeup (contributes to the web-vuln writeup project) — see `assessment.md`.

## Instructor notes & common pitfalls
- **Isolation is non-negotiable.** DVWA and Metasploitable are intentionally insecure. Confirm host-only/internal networking before Day 1 and re-state it every lab. Never run `sqlmap` against anything but the lab target.
- Students often think SQLi is "guessing passwords." Hammer the real idea: **they change the meaning of the query.** The before/after query comparison is the key visual.
- The `' OR '1'='1` syntax confuses students because of the quotes. Slow down: the leading quote *closes* the app's string; show the resulting full query explicitly.
- DVWA Security levels matter — make sure it's **Low** for the attack days and that you actually raise it for the defense day, or the "fix" won't be visible. Use "View Source" every time; the code diff is the best teaching tool in the unit.
- `sqlmap` can be slow and noisy and may look like it "hangs." Pre-test the exact command and expected runtime on the lab machines. Frame it as a *demonstration of automation*, not the point of the unit — the point is understanding and defense.
- Tie everything back to the writeup project: every injection they do is **evidence** for a finding, and every finding needs a **remediation** (prepared statements). Attacks are always paired with defenses.
