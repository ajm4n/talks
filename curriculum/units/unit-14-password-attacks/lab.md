# Unit 14 Lab — Hydra (online) + John the Ripper (offline) on authorized targets

- **Platform:** Authorized TryHackMe password-attacks room (browser-based) and/or a local lab login service on the isolated network + Kali/AttackBox with Hydra, John, Hashcat, and rockyou.
- **Time:** ~120 min across Days 2–5
- **Difficulty:** beginner

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment. Doing this to any
system you do not own or have written permission to test is illegal.

This is one of the easiest skills to misuse, so the rule is bright: your **only**
legal targets are **lab accounts on lab systems** and **authorized TryHackMe rooms** —
**never** a real account, a classmate's account, a school login, or any service you
don't own or have written permission to test. Even one unauthorized login attempt
can be a crime under the CFAA and state law. The **rockyou** wordlist is real
passwords from a real breach; treat it as evidence of why people need better
defenses, not as a toy. **Cracked credentials from this lab are lab data only and
never leave the lab.** If you're unsure whether a target is in scope, stop and ask
the instructor.

## Objectives
- Show how a password becomes a **hash**, and that **salting** changes identical passwords.
- Locate and understand the **rockyou** wordlist.
- Use **Hydra** to recover a password from an **authorized lab** login service.
- Use **John the Ripper** (and optionally **Hashcat**) to crack **sample** hashes offline.
- Observe why **MD5/SHA** fall fast while **bcrypt** resists, and connect each attack to a defense.
- Record a **journal of cracked creds (lab)** and a **password-defense reflection**.

## Setup
1. Start the isolated lab. Confirm with the instructor that networking is **host-only/internal** before anything else.
2. Start your Kali/AttackBox and the **lab login service** (or open the authorized TryHackMe room). Note its IP, the service/port, and the **lab** username you'll target.
3. Get the **sample hashes** handout from the instructor (these were generated from harmless words — not real passwords).
4. Make sure rockyou is available and decompressed:
   ```
   ls -l /usr/share/wordlists/rockyou.txt
   gunzip /usr/share/wordlists/rockyou.txt.gz    # only if it's still .gz
   ```
5. Open your **lab journal**: record date, objective, target IP, and the lab username.

## Walkthrough

### Step 1 — See hashing and salting in action (Day 1)
Generate a hash of a sample word (use a throwaway word, never a real password):
```
echo -n "password1" | md5sum
echo -n "password1" | md5sum     # run again
echo -n "Password1" | md5sum     # change ONE character
```
Expected output: the first two are **identical** (same input → same hash); the third is **completely different** (one character changes everything). Note in your journal: hashing is one-way, and you can't reverse a hash back to the word — you can only guess words and compare. Write one sentence on why a **salt** (random per-password data) would make two users who both chose `password1` end up with **different** hashes.

### Step 2 — Inspect the wordlist (Day 2)
Look at the wordlist without cracking anything yet:
```
wc -l /usr/share/wordlists/rockyou.txt
head /usr/share/wordlists/rockyou.txt
```
Expected output: a very large line count (millions) and a list of extremely common passwords at the top. In your journal, note: these are real, leaked passwords — which is exactly why a dictionary attack beats brute force for human-chosen passwords.

### Step 3 — Online attack with Hydra (lab login ONLY) (Day 3)
Re-read the safety reminder. Target the **authorized lab** service only. Example for SSH (adjust service/port/username to your lab):
```
hydra -l <lab-username> -P /usr/share/wordlists/rockyou.txt ssh://<target-IP>
```
For an FTP service:
```
hydra -l <lab-username> -P /usr/share/wordlists/rockyou.txt ftp://<target-IP>
```
(For a web login form, the instructor will give you the exact `http-post-form` string.) Expected output: Hydra reports a **valid login** with the password it found, e.g., `[ssh] host: <ip>   login: <user>   password: <found>`. Record the recovered **lab** credential in your worksheet. In your journal, name **two defenses** that would have stopped this (account **lockout/rate-limiting**, **MFA**) and explain how each breaks the attack.

### Step 4 — Offline cracking with John the Ripper (Day 4)
Save the instructor's **sample hashes** to a file, one per line:
```
nano hashes.txt        # paste the sample hashes, save
```
Crack them with John using rockyou:
```
john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
```
(Use the matching `--format` for the hash type, e.g., `raw-sha1`, `bcrypt`. Ask if unsure.) View results:
```
john --show --format=raw-md5 hashes.txt
```
Expected output: John prints the cracked plaintext next to each hash it solved. Record which hashes **cracked** and which **did not**, and the plaintext for the ones that did (lab data only).

### Step 5 — Watch the algorithm matter (Day 4)
Notice that the **MD5/SHA** samples crack almost instantly, but the **bcrypt** sample is slow or doesn't crack in class time. In your journal, explain why: bcrypt is **slow by design and salted**, so each guess costs far more time, making offline cracking impractical. (Optional: re-run an MD5 sample with **Hashcat** to see GPU speed: `hashcat -m 0 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt`.)

### Step 6 — Map attacks to defenses (Day 5)
In your journal, fill the attack → defense table:
| Attack you performed | What it exploited | Defense that stops it | Why |
|----------------------|-------------------|------------------------|-----|
| Hydra online guessing | weak/common password, no rate limit | lockout/rate-limiting; MFA | … |
| Wordlist (rockyou) | predictable human passwords | long unique passphrases | … |
| John offline (MD5/SHA) | fast hashing | bcrypt (slow, salted) | … |
| (concept) password spraying | one common password, many accounts | unique passwords; MFA; spray-aware monitoring | … |

Then write a short **password-defense reflection** (½–1 page): based on what you saw, what advice would you give a normal person, and which single defense matters most and why?

## Deliverables
- **Journal of cracked creds (lab)**: the recovered Hydra credential and the cracked sample hashes, with the exact commands and labeled screenshots (hashing demo, rockyou inspection, Hydra success line, John `--show` output).
- The completed **attack → defense** table.
- A **password-defense reflection** (½–1 page).
- (All credentials are lab data and stay in the lab.)

## Stretch goals (optional)
- Use **Hashcat** with a **rule** (e.g., `best64.rule`) or a **mask** attack and explain how it expands guesses.
- Crack a **salted** sample hash and explain how the tool uses the salt.
- Build a tiny **custom wordlist** for a fictional target and discuss targeted guessing ethics.
- Estimate crack-time for an 8- vs. 14-character password and present the math.
- Research a real breach where **plaintext or weak hashing** made it worse; summarize the lesson (no attack steps).

## Answer key (instructor only)
- **Step 1:** `echo -n "password1" | md5sum` → `7c6a180b36896a0a8c02787eeafb0e4c` (deterministic; identical on repeat). `Password1` → a totally different digest, demonstrating the avalanche effect. Salt point: a random salt per user means two users with `password1` store different hashes, defeating precomputed/rainbow tables and hash-reuse spotting.
- **Step 2:** rockyou.txt ≈ **14 million** lines; top entries include `123456`, `password`, `iloveyou`, etc. Reinforces dictionary > brute force for human passwords.
- **Step 3 (Hydra):** Pre-create the lab account with a password that's in your trimmed wordlist (or near the top of rockyou) so it cracks in seconds. Success line format: `[22][ssh] host: <ip>  login: <user>  password: <pw>`. Defenses: **account lockout/rate-limiting** (blocks repeated guesses), **MFA** (a guessed password still fails without the second factor), strong unique passwords. Stress **lab target only**.
- **Step 4 (John):**
  - Provide sample hashes generated from rockyou words, e.g.:
    - MD5 of `password1` = `7c6a180b36896a0a8c02787eeafb0e4c`
    - MD5 of `letmein` = `0d107d09f5bbe40cade3de5c71e9e9b7`
    - SHA-1 of `summer2024` (generate fresh; `--format=raw-sha1`)
    - one **bcrypt** sample (`--format=bcrypt`) of a rockyou word
  - `john --format=raw-md5 --wordlist=rockyou hashes.txt` cracks the MD5s near-instantly; `john --show` displays plaintext. Keep your own plaintext→hash key to verify.
- **Step 5 (algorithm):** MD5/SHA are fast (millions–billions of guesses/sec) → fall immediately. bcrypt is intentionally slow + salted → orders of magnitude fewer guesses/sec → resists in class time. This is the bridge to the bcrypt defense. Hashcat MD5 mode is `-m 0`.
- **Step 6 (defenses):** Required mappings — Hydra → lockout/rate-limiting + MFA; wordlist → long unique passphrases (+ password manager); John offline → bcrypt (slow, salted) + don't store plaintext; spraying → unique passwords + MFA + monitoring for one-password-many-accounts patterns. No journal is complete without the defense column.
- **Ethics:** Confirm every Hydra target is a **lab account on a lab system** or an **authorized room**. If a student even jokes about a real/classmate account, address it immediately. Cracked creds never leave the lab.
- **Reset / pacing:** Use a trimmed wordlist and pre-set easy lab passwords for weak hardware; restore VMs from snapshots as needed (`instructor/lab-setup-guide.md`). Be explicit that real-world cracking can take days/years — these examples are intentionally crackable. Mastery over first-try success.
