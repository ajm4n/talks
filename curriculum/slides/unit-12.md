---
marp: true
theme: bootstrap
paginate: true
header: "Introduction to Offensive Security · Unit 12"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# SQL Injection
## Unit 12 — How One Quote Can Dump a Database

A single quote in the wrong place can read an entire database — and one line of code can stop it. Let's see both sides.

<!-- teacher note: Module 3, lands right before the web-vuln writeup project. The big idea: SQLi changes the MEANING of a query. Attacks are always paired with their defense (prepared statements). -->

---

# Learning objectives

By the end of this unit you can:

- **Define** a database and SQL, and write a simple `SELECT ... WHERE` query in plain terms.
- **Explain** how a web app turns user input into a query — and why that's dangerous.
- **Describe** SQL injection as "untrusted input changing the meaning of a query."
- **Perform** an authentication bypass (`' OR '1'='1`) and **explain** why it works.
- **Demonstrate** UNION-based extraction and **distinguish** error-based from blind SQLi.
- **Use** `sqlmap` responsibly against a **lab-only** target.
- **Recommend** layered defenses — **prepared statements**, input validation, least privilege.

---

# Databases & SQL in 60 seconds

- A **database** stores data in **tables** — columns are fields, rows are records.
- **SQL** (Structured Query Language) is how you ask a database questions.

```sql
SELECT name FROM users WHERE name = 'Maya';
```

- **SELECT** = read data · **WHERE** = filter which rows come back.

<!-- teacher note: Warm-up — "When you log in, how does the site KNOW your password is right?" It looks you up in a database. -->

---

# Where the bug lives

A web login builds a query by **gluing your input into a SQL string**:

```sql
SELECT * FROM users
WHERE name = 'YOU_TYPE_THIS' AND pass = 'AND_THIS';
```

> The app can't tell **your data** from **SQL commands** if it just pastes input into the query.

That confusion *is* SQL injection: **untrusted input changes the meaning of the query.**

<!-- teacher note: Hammer this — SQLi is NOT "guessing passwords." The attacker rewrites the question. The before/after query is the key visual all unit. -->

---

# Authentication bypass: `' OR '1'='1`

```sql
-- Intended query:
... WHERE name = 'Maya' AND pass = 'secret';

-- Attacker types:  ' OR '1'='1' --
... WHERE name = '' OR '1'='1' -- ' AND pass = '...';
```
*(lab-only demonstration)*

- The leading `'` **closes** the app's string.
- `OR '1'='1'` is **always true** → the filter no longer filters.
- `--` **comments out** the rest (the password check).

> The attacker didn't guess a password. They **rewrote the question.**

<!-- teacher note: Slow WAY down on the quotes. Show the full resulting query explicitly. Exit ticket — "Why does ' OR '1'='1 let someone in without a password?" -->

---

# Pulling data out: UNION

A `UNION` attaches a **second query's results** to the app's results — both must return the **same number of columns**.

```sql
-- find the column count
1' ORDER BY 2 -- -          -- works
1' ORDER BY 3 -- -          -- errors → 2 columns

-- extract real data
1' UNION SELECT user, password FROM users -- -
```
*(lab-only demonstration)*

> Now the page displays **usernames and password hashes** — the whole credential store.

<!-- teacher note: Keep the space after --. The teaching payoff: they extracted the credential store. Hashes vs plaintext is Unit 14; here the EXTRACTION is the critical finding. -->

---

# Error-based vs blind SQLi (awareness)

| Style | How data comes out |
|-------|-------------------|
| **Error-based** | Data leaks through the database's **error messages** |
| **Blind** | **No visible output** — ask true/false questions, watch the **page or its timing** change |

- That `'` that triggered an error in the lab? That's the **error-based** idea.
- If there were no errors and no output, you'd go **blind**.

<!-- teacher note: Awareness depth only. Exit ticket — "Name the three SQLi styles and one difference between UNION-based and blind." Blind is a stretch-goal in the THM room. -->

---

# Automating with sqlmap (lab-only)

`sqlmap` finds and exploits SQLi automatically — it does by tool what you just did by hand.

```bash
sqlmap -u "http://<DVWA-IP>/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=<session>; security=low" --batch -D dvwa -T users --dump
```

> It is **loud, powerful, and dangerous if misused.** Point it **ONLY** at the approved lab target — never anything else.

<!-- teacher note: Pre-test the exact command and runtime; it can look like it "hangs." Frame it as a DEMONSTRATION of automation, not the point of the unit. Understanding + defense is the point. -->

---

# 🛡️ Defense: prepared statements stop it

**The single most direct fix:** input is sent as **data**, never mixed into the SQL text.

```php
// Vulnerable (Low): input glued straight in
$q = "SELECT ... WHERE user_id = '$id'";

// Fixed (Impossible): bound parameter
$stmt = $pdo->prepare("SELECT ... WHERE user_id = :id");
$stmt->execute([':id' => $id]);
```

> With a prepared statement, your quote is just a **harmless character** — it can't change the query's meaning.

<!-- teacher note: Use DVWA's "View Source" to compare Low vs Impossible — the code diff is the best teaching tool in the unit. -->

---

# Defense in depth

| Layer | What it does |
|-------|--------------|
| **Prepared statements** | Input is data, never code — **primary fix** |
| **Input validation** | Reject input that isn't the expected type/format |
| **Least privilege** | The app's DB account can't read every table — limits the damage |

> Prepared statements stop the injection; validation and least privilege limit the blast radius if anything slips through.

<!-- teacher note: Warm-up Day 4 — "If you were the developer, how would you make ' OR '1'='1 do nothing?" Then raise DVWA to High/Impossible and watch the same payloads fail. -->

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

## SQL injection is not a gray area.

Pointing SQLi — or `sqlmap` — at any database you don't own or have **written permission** to test is a crime under the **CFAA** and state law. It can destroy real data and real people's privacy.

Targets are **DVWA and authorized TryHackMe rooms ONLY** — apps built to be broken, in an **isolated lab**. Never a real site.

<!-- teacher note: Discussion — a student's part-time job's order form returns extra data when they type a quote. Responsible next step? Where exactly is the authorization boundary, and what would crossing it look like? -->

---

# Key vocabulary

| Term | Meaning |
|------|---------|
| Database / Table | Organized data store / a grid of rows & columns |
| SQL / Query | The language to ask a DB / one request to it |
| SELECT / WHERE | Read data / filter which rows return |
| SQL injection | Untrusted input changes a query's **meaning** |
| Authentication bypass | Tricking a login without valid credentials |
| UNION-based | Append attacker data to the results |
| Error-based / Blind | Leak via errors / infer via true-false & timing |
| sqlmap | Automated SQLi tool (lab-only) |
| Prepared statement | Input sent as **data**, never as code |
| Least privilege | Give an account only the access it needs |

---

# 🧪 Lab launch

**Platform: DVWA (Damn Vulnerable Web Application) + Kali / AttackBox**

- Confirm the lab is **isolated**, log in, set Security to **Low**.
- `'` to prove the field is **injectable** → `1' OR '1'='1` to **dump all users**.
- `ORDER BY` to count columns → `UNION SELECT user, password FROM users -- -`.
- Run **`sqlmap`** against the **DVWA target only** to see the automation.
- Raise Security to **High/Impossible**, watch it fail, and **View Source** to see the prepared statement.

> Scope statement first: *"I am authorized to test only DVWA inside the isolated class lab."*

<!-- teacher note: Isolation is non-negotiable — host-only/internal networking, confirmed before Day 1. Set Low for attack days; you MUST raise it for the defense day or the fix isn't visible. -->

---

# Document it: the finding writeup

Every injection you ran is **evidence** for a report. A good finding has:

1. **Description** — what the vulnerability is
2. **Reproduction steps** — the exact payloads
3. **Evidence** — screenshots (the `'` error, the user dump, the source diff)
4. **Impact** — full credential disclosure → **High / Critical**
5. **Remediation** — **use prepared statements** (+ validation, least privilege)

> A finding without a **remediation** is not finished.

<!-- teacher note: This becomes one finding in the Module 3 web-vuln writeup project. Review the report rubric in instructor/grading-and-rubrics.md. -->

---

# Recap

- SQLi = **untrusted input changes the meaning of a query.**
- `' OR '1'='1` works because it makes the `WHERE` filter **always true**.
- **UNION** extracts data; **error-based/blind** are other styles; **sqlmap** automates it.
- The one direct fix: **prepared statements** (input as data, not code).
- Defense in depth: + **input validation** + **least privilege**.

---

<!-- _class: lead -->

# Exit ticket & discussion

1. In your own words, why does `' OR '1'='1` let someone in without a password?
2. Which single defense most directly stops SQL injection, and **why**?
3. **Discuss:** Why does a prepared statement defeat injection when input validation **alone** might not?

**Next up — Module 3 web-vuln writeup project** (your SQLi finding feeds it!)

<!-- teacher note: Collect the SQLi finding draft. Quiz at end of Day 5 or start of Week 13. Reset DVWA from snapshot if anyone is stuck. -->
