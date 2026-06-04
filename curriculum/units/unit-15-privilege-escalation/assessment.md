# Unit 15 Assessment — Privilege Escalation (Linux & Windows Basics)

## Formative checks
- **Exit tickets (Days 1–5):** collect and scan for misconceptions before the next class.
- **Walk-around check:** every student can run `whoami`, `id`, `sudo -l`, and the SUID `find` and explain what each output means.
- **Paper analysis:** given a sample `sudo -l` output and a crontab, students point to the privesc lead.
- **LinPEAS-vs-manual match:** student names at least one LinPEAS finding that corresponds to a vector they exploited by hand.

## Quiz

**Part A — Multiple choice** (2 points each)

1. What is **privilege escalation**?
   - A) Getting your very first shell on a target
   - B) Going from a limited account to a more powerful one, such as a normal user to root/admin
   - C) Scanning a network for open ports
   - D) Deleting log files to hide your tracks

2. According to this unit, the **single most important** privilege-escalation skill is:
   - A) Memorizing kernel exploits
   - B) Having the fastest internet connection
   - C) Thorough enumeration of the system you already have access to
   - D) Guessing the root password

3. The command `sudo -l` is used to:
   - A) List all users on the system
   - B) Show exactly what the current user is allowed to run with `sudo`
   - C) Log in as root
   - D) Delete the sudo configuration

4. A **SUID binary** is a program that:
   - A) Can only be run by root
   - B) Runs with the privileges of its **owner** (often root), no matter who launches it
   - C) Is automatically deleted after running
   - D) Cannot be found by normal users

5. Which command lists SUID binaries on a Linux system?
   - A) `sudo -l`
   - B) `cat /etc/passwd`
   - C) `find / -perm -4000 -type f 2>/dev/null`
   - D) `whoami`

6. A **cron job** becomes a privilege-escalation risk when:
   - A) It runs as root and calls a script that a low-privilege user can write to
   - B) It runs once a year
   - C) It is owned by a normal user and does nothing important
   - D) It prints the date to the screen

7. **GTFOBins** is best described as:
   - A) A malware download site
   - B) A reference site that shows how common binaries can be abused (e.g., via sudo or SUID)
   - C) A password-cracking tool
   - D) A Windows-only service

8. **LinPEAS** (and **WinPEAS**) primarily:
   - A) Automatically exploit the box and give you root with no thinking required
   - B) Automatically *scan* a system and flag possible privilege-escalation paths for a human to verify
   - C) Patch the system to remove vulnerabilities
   - D) Encrypt the attacker's traffic

9. An **unquoted service path** is a privilege-escalation issue found on:
   - A) Linux only
   - B) Windows
   - C) Routers only
   - D) Web browsers

10. Which defense most directly stops a **sudo misconfiguration** and an unnecessary **SUID** bit?
    - A) Buying a faster server
    - B) Least privilege (only grant the access actually needed)
    - C) Changing the desktop wallpaper
    - D) Turning the machine off at night

11. **Kernel exploits** are usually treated as a last resort because:
    - A) They never work
    - B) They can crash the system, and they are prevented by patching/updates
    - C) They are illegal even on authorized lab targets
    - D) They only work on Windows

12. On the most powerful Windows account, you would aim to become:
    - A) Guest
    - B) A normal user
    - C) Administrator / SYSTEM
    - D) `bob`

**Part B — Short answer** (4 points each)

13. In one or two sentences, explain the difference between **getting a shell (a foothold)** and **owning the box**.

14. List the **four Linux privilege-escalation vectors** taught this unit, and give **one tell-tale sign** of each.

15. A pentester says, "I'll just run LinPEAS and copy whatever it tells me." Give **two reasons** that is not enough, and what they should do instead.

**Part C — Attack-to-defense matching** (2 points each)

Match each attack vector to the defense that best stops it.

| Attack vector | Defense |
|---------------|---------|
| 16. Sudo misconfiguration | A) Patching / keeping the kernel updated |
| 17. World-writable script run by root's cron | B) Least privilege (remove the broad sudo grant) |
| 18. Out-of-date vulnerable kernel | C) Hardening (fix file permissions; remove SUID bit) |
| 19. Unnecessary SUID binary | D) Hardening (correct the cron script's permissions) |

## Project / performance task

**Prompt:** Document a complete **privilege-escalation path** from the lab. Starting as a low-privilege user, show every enumeration step, the vector you exploited (with the exact commands), and your proof of reaching root. Then write the **remediation** for that exact vector, as if reporting it to the system owner.

**Deliverable:** The completed lab journal (privesc-path writeup) plus a 5–6 sentence plain-English explanation of how one vector escalated you to root.

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Reproducible path | Another person could follow it start → root with no gaps | Mostly complete; a small gap | Major steps missing | Unclear / not reproducible |
| Manual enumeration | Clear manual checks shown and interpreted | Manual checks shown, light interpretation | Mostly LinPEAS dump | No real enumeration shown |
| Proof of root | Clear proof (`id` uid=0 + flag) | Proof present | Weak/ambiguous proof | No proof |
| Defense / remediation | Specific, correct fix per vector | Correct fix, general | Vague fix | Missing or wrong |
| Ethics & scope | Explicitly notes authorized-target-only; professional tone | Notes scope | Mentions scope weakly | Ignores scope |

## Answer key

**Part A:** 1‑B, 2‑C, 3‑B, 4‑B, 5‑C, 6‑A, 7‑B, 8‑B, 9‑B, 10‑B, 11‑B, 12‑C

**Part B:**
13. A **foothold/shell** means you have *some* access, usually as a **low-privilege** user who can't change the system or read protected files. **Owning the box** means you've escalated to **root/Administrator (SYSTEM)** and control everything. Privesc is the separate second fight between the two.

14. (Any four, with a reasonable tell-tale sign)
- **Sudo misconfiguration** — `sudo -l` lists a command (especially `NOPASSWD`) you can run as root.
- **SUID binary** — `find / -perm -4000` lists an abusable program owned by root with the SUID bit set.
- **Cron job** — `/etc/crontab` shows a root-run task that calls a script you can write to.
- **Weak/world-writable permissions or readable sensitive files** — a file root uses that you can write, or a readable file leaking passwords/keys.

15. **Reasons (any two):** LinPEAS only *finds* candidates, it doesn't decide what's real; some findings are false positives or dead ends; relying on it makes you a "just a tool runner" who can't work when the tool fails or isn't available; you won't understand or be able to explain the actual vulnerability. **Instead:** verify findings manually (run `sudo -l`, `find` SUID, inspect cron/permissions), confirm the path by hand, and understand *why* it works.

**Part C:** 16‑B, 17‑D, 18‑A, 19‑C

**Scoring:** Part A = 24 pts, Part B = 12 pts, Part C = 8 pts. Quiz total = 44 pts. Performance task graded separately on the rubric (20 pts) and feeds the lab-journal grade.
