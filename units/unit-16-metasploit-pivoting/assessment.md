# Unit 16 Assessment — Metasploit & Pivoting Concepts

## Formative checks
- **Exit tickets (Days 1–5):** collect and scan for misconceptions before the next class.
- **Walk-around check:** every student can run the msfconsole workflow (`search` → `use` → `show options` → `set` → `exploit`) and open a Meterpreter session.
- **RHOSTS/LHOST check:** student can state which is the target and which is their own listener.
- **Module-types check:** student names the four module types with an example of each.
- **Pivot diagram:** student draws attacker → foothold → internal target and explains it.

## Quiz

**Part A — Multiple choice** (2 points each)

1. A **framework** like Metasploit is best described as:
   - A) A single exploit for one vulnerability
   - B) A toolkit that bundles many ready-made tools with a common way to use them
   - C) A type of firewall
   - D) A programming language

2. The main command-line interface for Metasploit is:
   - A) `meterpreter`
   - B) `msfvenom`
   - C) `msfconsole`
   - D) `nmap`

3. Put the core msfconsole workflow in the correct order:
   - A) `exploit` → `set` → `use` → `search` → `show options`
   - B) `search` → `use` → `show options` → `set` → `exploit`
   - C) `use` → `search` → `exploit` → `set` → `show options`
   - D) `set` → `exploit` → `search` → `use` → `show options`

4. In Metasploit, **RHOSTS** refers to:
   - A) Your own attacking machine
   - B) The remote **target** machine
   - C) The router
   - D) The payload type

5. **LHOST** refers to:
   - A) The remote target
   - B) Your **local** machine / listener (where a shell connects back)
   - C) A list of hosts to scan
   - D) The largest host on the network

6. Which module type is the code that runs **after** an exploit succeeds (e.g., opens a shell)?
   - A) Exploit
   - B) Payload
   - C) Auxiliary
   - D) Post

7. A scanner or login-checker that is **not** an exploit is which module type?
   - A) Exploit
   - B) Payload
   - C) Auxiliary
   - D) Meterpreter

8. **Meterpreter** is best described as:
   - A) A network switch
   - B) A powerful payload that gives a rich post-exploitation shell
   - C) A vulnerability scanner
   - D) An antivirus product

9. **msfvenom** is used to:
   - A) Patch vulnerabilities
   - B) Generate standalone payload files
   - C) Scan for open ports
   - D) Encrypt a hard drive

10. **Pivoting** means:
    - A) Rotating your monitor
    - B) Using one compromised machine as a stepping stone to reach machines you couldn't reach directly
    - C) Deleting logs
    - D) Cracking a password hash

11. An **SSH local port-forward** (`ssh -L`) lets you:
    - A) Reach a service through the SSH server that you couldn't reach directly
    - B) Crack the SSH password
    - C) Turn off the SSH server
    - D) Scan the whole internet

12. **Active Directory** is:
    - A) A Linux privilege-escalation tool
    - B) Microsoft's system for centrally managing Windows computers, users, and permissions
    - C) A type of payload
    - D) A web browser

13. Which defense most directly **limits how far an attacker can pivot** across a network?
    - A) Network segmentation
    - B) Changing the wallpaper
    - C) Buying more RAM
    - D) Disabling logging

14. Which defense most directly catches **Meterpreter-style behavior on a host**?
    - A) A faster CPU
    - B) EDR (Endpoint Detection and Response)
    - C) A longer password
    - D) Turning off the monitor

**Part B — Short answer** (4 points each)

15. Explain the difference between an **exploit** module and a **payload** module, using one example of each.

16. A student says, "Metasploit does everything, so I don't need to understand exploits manually." Give **two** concrete situations where being "just a tool runner" fails, and what understanding the manual approach gives you instead.

17. In your own words (2–3 sentences), explain **pivoting** and why **both attackers and defenders** care about it.

**Part C — Attack-to-defense matching** (2 points each)

| Attack capability | Best-fit defense |
|-------------------|------------------|
| 18. Exploit module relies on an unpatched vulnerability | A) Network segmentation |
| 19. Attacker pivots from a web server to an internal database | B) EDR |
| 20. Meterpreter running in memory on a host | C) Patching / updates |
| 21. Attack and session leave traces but no one is watching | D) Detection / logging (monitoring) |

## Project / performance task

**Prompt:** Document your **Metasploit session** from the lab — the full msfconsole workflow, your RHOSTS/LHOST, proof of a Meterpreter session, and one post-module result. Then write a clear **pivoting explanation in your own words** with a path sketch, and name the **defense** that would have detected or stopped the exploit you used.

**Deliverable:** The completed Metasploit session journal + the pivoting writeup (5–6 sentences) + one-line defense.

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| msfconsole workflow | Correct, ordered, right RHOSTS/LHOST, reproducible | Mostly correct; minor gap | Several gaps/errors | Unclear or incorrect |
| Session proof | Clear (`sysinfo`+`getuid`+session) and a post module | Session shown | Weak/ambiguous proof | No proof |
| Pivoting explanation | Clear, in own words, correct path sketch | Mostly clear | Vague or copied | Missing/incorrect |
| Defense | Specific, correct defense for the exploit | Correct but general | Vague | Missing/wrong |
| Ethics & scope | Explicitly authorized-target-only; professional tone | Notes scope | Weak mention | Ignores scope |

## Answer key

**Part A:** 1‑B, 2‑C, 3‑B, 4‑B, 5‑B, 6‑B, 7‑C, 8‑B, 9‑B, 10‑B, 11‑A, 12‑B, 13‑A, 14‑B

**Part B:**
15. An **exploit** takes advantage of a vulnerability to get access ("gets you in the door") — e.g., an exploit module for a vulnerable service. A **payload** is the code that runs *after* the exploit succeeds — e.g., a **Meterpreter** payload that opens a remote shell back to the attacker. Exploit = the way in; payload = what runs once you're in.

16. (Any two concrete situations) Examples: the target isn't vulnerable to any Metasploit module, so you must understand and adapt an exploit by hand; the framework's payload is caught by EDR/antivirus, so you need to understand how to modify the approach; the tool gives a confusing error and you can't troubleshoot without understanding what's happening underneath; you can't *explain* the finding to a client or fix it as a defender. **Instead:** understanding the manual approach lets you adapt when tools fail, troubleshoot, explain risk clearly, and defend better because you know what the attack actually looks like.

17. **Pivoting** is using a machine you've already compromised as a stepping stone to reach other machines you couldn't reach directly (e.g., a hidden internal network behind a public server). **Attackers** care because it's how a single foothold turns into a wider breach; **defenders** care because limiting pivoting (segmentation, monitoring) contains the damage when one machine is compromised.

**Part C:** 18‑C, 19‑A, 20‑B, 21‑D

**Scoring:** Part A = 28 pts, Part B = 12 pts, Part C = 8 pts. Quiz total = 48 pts. Performance task graded separately on the rubric (20 pts) and feeds the lab-journal grade.
