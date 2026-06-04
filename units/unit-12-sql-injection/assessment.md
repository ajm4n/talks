# Unit 12 Assessment — SQL Injection

## Formative checks
- **Exit tickets (Days 1–4):** one-sentence answers — why gluing input into a query is dangerous; why `' OR '1'='1` lets you in; the three SQLi styles; the single best defense.
- **Paper "run the bypass" check:** student rewrites a login query after injecting `' OR '1'='1 -- -` and circles which rows return.
- **Lab walk-around:** instructor verifies each student can both *perform* the DVWA auth bypass and *explain it in their own words*.
- **Before/after demo check:** student points to the exact line in DVWA's "View Source" that changes between Low and Impossible.

## Quiz
1. What is SQL?
   - A) A type of firewall
   - B) The language used to ask a database for or change data
   - C) A password-cracking tool
   - D) A web browser

2. In `SELECT name FROM users WHERE name = 'Maya'`, what does the `WHERE` clause do?
   - A) Picks which columns to return
   - B) Deletes the row
   - C) Filters which rows are returned
   - D) Connects two databases

3. SQL injection happens when:
   - A) A database server runs out of memory
   - B) Untrusted user input changes the *meaning* of a query
   - C) A user forgets their password
   - D) Two users log in at once

4. Why does typing `' OR '1'='1` into a vulnerable login let an attacker in?
   - A) It guesses the admin password
   - B) It adds an always-true condition so the filter matches every row
   - C) It crashes the database so login is skipped
   - D) It encrypts the password field

5. A `UNION SELECT` injection is mainly used to:
   - A) Delete the database
   - B) Attach attacker-chosen results (like other tables) to the app's output to extract data
   - C) Speed up the website
   - D) Reset the security level

6. You inject `'` and see a database error message. This is closest to which SQLi style?
   - A) Blind
   - B) Error-based
   - C) Parameterized
   - D) Least privilege

7. **Blind** SQL injection is used when:
   - A) The attacker is not logged in
   - B) There is no visible output, so the attacker asks true/false questions and watches behavior or timing
   - C) The database has no tables
   - D) The website uses HTTPS

8. Which single defense most directly stops SQL injection?
   - A) A longer password
   - B) Parameterized queries / prepared statements (input is sent as data, never as code)
   - C) Hiding the login button
   - D) Turning off error messages only

9. "Least privilege" helps against SQLi by:
   - A) Making queries run faster
   - B) Limiting what the web app's database account can read, so a breach does less damage
   - C) Encrypting the network
   - D) Blocking the single-quote character

10. Pointing `sqlmap` at a website you do not own or have written permission to test is:
    - A) Fine if you are just curious
    - B) Legal as long as you do not save the data
    - C) A crime under the CFAA and state law
    - D) Allowed if the site has a login page

11. **Short answer:** Write the login query *before* and *after* an attacker submits `' OR '1'='1 -- -` as the username, and explain in one sentence why it bypasses the password check.

12. **Short answer:** A classmate says "input validation alone is enough to stop SQL injection." Give one reason a prepared statement is a stronger primary defense, and name one situation where validation might miss an attack.

## Project / performance task
**Prompt:** Turn your DVWA SQL Injection lab work into one professional **finding** for the Module 3 **web-vulnerability writeup project**. Document the vulnerability so a developer could both reproduce and fix it.
**Deliverable:** A one-page finding containing: a plain-language **description**, exact **reproduction steps** (the payloads you used), **evidence** (labeled screenshots: the `'` error, the all-users dump, the UNION hash dump, and the Low-vs-High "View Source" comparison), **impact** and a **severity** rating with justification, and a specific **remediation**. Attacks must be paired with defenses.
**Rubric (penetration-test report rubric, abbreviated — see `instructor/grading-and-rubrics.md`):**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| **Description & methodology** | Clear, accurate, non-technical-friendly | Mostly clear | Vague/too technical | Missing |
| **Reproduction & evidence** | Steps reproducible; screenshots labeled | Minor gaps | Hard to reproduce | Missing |
| **Impact & severity** | Justified (High/Critical) with reasoning | Stated with light reasoning | Unjustified | Missing |
| **Remediation** | Specific (prepared statements + validation + least privilege) | General fix | Vague | Missing |
| **Communication & ethics** | Polished; authorization noted | Solid | Rough | Unclear |

## Answer key
1. **B** — SQL is the language used to query/modify a database.
2. **C** — `WHERE` filters which rows are returned.
3. **B** — untrusted input changes the meaning of the query.
4. **B** — an always-true condition (`'1'='1'`) makes the filter match every row.
5. **B** — UNION attaches attacker-chosen results to extract data.
6. **B** — a visible DB error is error-based SQLi.
7. **B** — blind = no visible output; infer via true/false or timing.
8. **B** — parameterized queries / prepared statements send input as data, not code.
9. **B** — least privilege limits the app's DB account, reducing breach damage.
10. **C** — it is a crime under the CFAA and state law. The dividing line is **written authorization and scope**.
11. **Sample:**
    - *Before:* `SELECT * FROM users WHERE username = '<input>' AND password = '<input>'`
    - *After:* `SELECT * FROM users WHERE username = '' OR '1'='1' -- -' AND password = '...'`
    - The `OR '1'='1'` is always true and `-- -` comments out the password check, so the query returns a user row without a valid password. (Full credit: correct before/after + the one-sentence reason.)
12. **Sample:** Prepared statements treat all input as data and bind it as a parameter, so a quote can never change the query's structure — protection that does not depend on a developer anticipating every malicious string. Input validation can miss attacks when a value legitimately must allow characters like quotes or apostrophes (e.g., the name "O'Brien"), or when a developer's allow-list/blocklist is incomplete. Best practice: parameterized queries as the primary fix, validation as defense in depth.
