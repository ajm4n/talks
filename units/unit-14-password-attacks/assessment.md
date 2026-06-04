# Unit 14 Assessment — Password Attacks

## Formative checks
- **Exit tickets (Days 1–4):** why salting helps; one pro of offline and one of online attacks; two defenses against Hydra; why bcrypt resisted while MD5 fell.
- **Hashing check:** student shows that the same word always hashes the same, and a one-character change alters the whole hash.
- **Lab walk-around:** instructor confirms each student can *run and explain* both Hydra (online) and John (offline) — and can state the matching defense.
- **Attack → defense table:** checked for a correct defense paired with every attack performed.

## Quiz
1. Why is storing passwords in **plaintext** dangerous?
   - A) It uses too much disk space
   - B) If the database leaks, every real password is instantly exposed
   - C) It makes logins slower
   - D) It can't be searched

2. A **hash** is:
   - A) A reversible encryption of a password
   - B) A one-way scramble — same input gives the same hash, but you can't reverse it
   - C) A type of wordlist
   - D) A network port

3. What does a **salt** do?
   - A) Speeds up hashing
   - B) Adds random data per password so identical passwords get different hashes
   - C) Encrypts the network traffic
   - D) Locks the account after failures

4. Which is the **strongest** choice for storing passwords?
   - A) MD5
   - B) SHA-1
   - C) bcrypt (slow, salted)
   - D) Plaintext

5. An **offline** password attack:
   - A) Requires hammering the live login service
   - B) Works on captured hashes on the attacker's own machine, with no contact to the target
   - C) Always triggers account lockout
   - D) Only works on bcrypt

6. Why is a **dictionary/wordlist** attack usually better than pure brute force against human passwords?
   - A) Wordlists are encrypted
   - B) People pick predictable passwords, so a list of likely ones (like rockyou) hits fast
   - C) Brute force is illegal but wordlists aren't
   - D) Wordlists never fail

7. **Hydra** is used for:
   - A) Cracking captured hashes offline
   - B) Online attacks against a live login service
   - C) Generating salts
   - D) Scanning ports

8. **John the Ripper / Hashcat** are used for:
   - A) Online login guessing
   - B) Offline cracking of captured hashes
   - C) Patching software
   - D) Sending phishing emails

9. **Password spraying** means:
   - A) Trying many passwords against one account
   - B) Trying **one** common password against **many** accounts to dodge lockouts
   - C) Resetting everyone's password
   - D) Hashing a password many times

10. Which defense most directly defeats an **online** guessing attack like Hydra?
    - A) Using MD5 instead of SHA
    - B) Account lockout / rate-limiting (and MFA)
    - C) A shorter password
    - D) Disabling salts

11. Attacking a service or account you don't own or have written permission to test is:
    - A) Fine if it's "their own account" and they asked
    - B) Legal if you don't keep the password
    - C) A crime under the CFAA and state law
    - D) Allowed for educational curiosity

12. **Short answer:** Explain why a fast hash like **MD5** is a poor choice for storing passwords, and why **bcrypt** resists cracking. Use the word "salt" and the idea of speed.

13. **Short answer:** Match each attack to a defense and explain *how* the defense breaks it: (a) Hydra online guessing, (b) a rockyou wordlist attack, (c) John offline cracking of MD5 hashes.

## Project / performance task
**Prompt:** Submit your **journal of cracked credentials (lab)** plus a **password-defense reflection** that turns this week's attacks into defensive advice.
**Deliverable:** (1) A lab journal section with the exact commands, the recovered **lab** Hydra credential, the cracked **sample** hashes, and labeled screenshots; and (2) a ½–1 page reflection containing the completed **attack → defense** table and a recommendation of the single most important password defense for a typical person, with justification. All credentials are lab data and stay in the lab. Attacks must be paired with defenses.
**Rubric (lab-journal + report rubric, abbreviated — see `instructor/grading-and-rubrics.md`):**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| **Process documentation** | Every command/result recorded; reproducible | Most steps | Some missing | Sparse |
| **Findings (lab creds)** | Accurate; clearly labeled lab data | Mostly accurate | Gaps | Missing/incorrect |
| **Attack→defense reasoning** | Every attack mapped to a correct defense with *how* | Most mapped | Vague | Missing |
| **Reflection & ethics** | Thoughtful advice; authorization/lab-only stated | Solid | Rough | Unclear |

## Answer key
1. **B** — a leak exposes every real password instantly.
2. **B** — a one-way scramble; deterministic but not reversible.
3. **B** — random per-password data so identical passwords differ.
4. **C** — bcrypt (slow, salted).
5. **B** — offline = crack captured hashes locally, no target contact.
6. **B** — humans pick predictable passwords, so wordlists hit fast.
7. **B** — Hydra = online attacks on live login services.
8. **B** — John/Hashcat = offline hash cracking.
9. **B** — one common password against many accounts to dodge lockouts.
10. **B** — lockout/rate-limiting (and MFA) defeat online guessing.
11. **C** — a crime under the CFAA and state law; even "their own account" requests should go through account recovery, not cracking. Authorization = written permission and scope.
12. **Sample:** MD5 is **fast**, so an attacker can try billions of guesses per second against captured hashes, and without a unique salt, identical passwords share a hash (and precomputed tables apply) — so MD5 hashes crack quickly. **bcrypt** is **slow by design** and **salted**: each guess costs far more time and the salt makes every hash unique, so offline cracking becomes impractical. (Full credit: speed + salt for both.)
13. **Sample:**
    - (a) **Hydra online** → **account lockout/rate-limiting + MFA**: lockout/rate-limiting stops the flood of guesses; MFA means a guessed password still can't log in without the second factor.
    - (b) **rockyou wordlist** → **long unique passphrase (+ password manager)**: a long, non-predictable password isn't in the wordlist, so the dictionary attack never reaches it.
    - (c) **John offline (MD5)** → **strong salted hashing (bcrypt) + never store plaintext**: bcrypt's slowness and per-password salt make offline guessing far too expensive to succeed. (Full credit: correct defense + *how* for each.)
