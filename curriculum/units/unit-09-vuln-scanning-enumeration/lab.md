# Unit 09 Lab — Enumeration, Vuln Scanning & the Recon Mini-Project

- **Platform:** Kali VM + **Metasploitable 2** target on a **host-only** network. A TryHackMe **enumeration** room is an approved browser-based alternative. Optional: Nessus Essentials / OpenVAS.
- **Time:** ~4–5 class periods (Parts A–E + mini-project across Days 1–5)
- **Difficulty:** beginner → intermediate

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment and **only** against
the isolated Metasploitable 2 VM on the host-only network or an authorized
TryHackMe room. Enumeration and vulnerability scanning are **active** — they send
probes and login attempts to the target and are even more intrusive than a port
scan. Doing this to any system you do not own or have written permission to test is
illegal. **Finding a vulnerability is NOT permission to exploit it.** In this lab we
**stop at the attack plan** — we do not exploit anything (that waits for Module 3 on
authorized targets). If you ever find a real vulnerability outside this lab, follow
**responsible disclosure** (Unit 01): do not exploit it and do not post it publicly.
If unsure, stop and ask your instructor.

## Objectives
- Manually enumerate HTTP, FTP, SMB, and SSH on the authorized target.
- Run targeted nmap NSE scripts and interpret the output.
- (Optional) Run an automated vuln scan, or analyze an instructor-provided report.
- Map enumerated services/versions to CVEs and flag a likely false positive.
- Build a prioritized attack plan (planning only — no exploitation).
- Assemble the **Recon mini-project report** combining Units 07–09.

## Setup
1. Start your Kali VM and the Metasploitable 2 VM on the **host-only** network. Confirm they reach each other but NOT the internet.
2. In your lab journal, write date, objective, and the **scope statement:** *"I am authorized to enumerate and vuln-scan only the isolated lab target. I will not exploit anything."*
3. Have your Unit 08 annotated scan results open — you'll enumerate the open services you already found.
4. Reread the safety reminder above.

## Walkthrough

### Part A — HTTP enumeration (Day 1)
**Step 1 — Inspect the web service** on port 80:
```bash
curl -I http://<target-ip>/            # server header
curl http://<target-ip>/robots.txt     # disallowed paths (if present)
```
Browse the site in the Kali browser; note any apps, login pages, or directory listings.
**Record:** server software/version, any interesting paths, and what they suggest.

### Part B — FTP, SMB, and SSH enumeration (Day 2)
**Step 2 — FTP (port 21):** try an anonymous login.
```bash
ftp <target-ip>      # user: anonymous  password: (anything)
```
**Step 3 — SMB (ports 139/445):** list shares and gather info.
```bash
smbclient -L //<target-ip>/ -N
enum4linux -a <target-ip>
```
**Step 4 — SSH (port 22):** read the banner / version.
```bash
nc <target-ip> 22
```
**Record:** whether anonymous FTP worked and what was visible; SMB shares/users found; SSH version. Note which findings a plain port scan would have missed.

### Part C — nmap NSE scripts (Day 3)
**Step 5 — Run targeted scripts:**
```bash
nmap --script ftp-anon -p 21 <target-ip>
nmap --script smb-os-discovery,smb-enum-shares -p 139,445 <target-ip>
nmap --script vuln -p <ports> <target-ip>     # safe vuln-detection scripts
```
**Record:** what each script reported; compare it to your manual findings from Parts A–B.

### Part D — Automated vuln scan (OPTIONAL, Day 3)
**Step 6 — Run Nessus Essentials or OpenVAS** against the target (instructor-configured), OR analyze the **instructor-provided sample report**.
**Record:** the top findings, each with its CVSS severity. Mark any you suspect are **false positives** and say why.

### Part E — CVE mapping & attack plan (Day 4)
**Step 7 — Map services to CVEs.** For 2–3 starred versions from your scans, look up the CVE(s) and CVSS using your instructor's "how to read a CVE" guide.
**Record this table:**

| Service & version | Port | CVE(s) | CVSS | True positive? | Why it matters |
|-------------------|------|--------|------|----------------|----------------|

**Step 8 — Draft a prioritized attack plan** (planning only): list, in order, what an attacker would try first and why. **Do not exploit anything.**

## Deliverables
- **Lab journal** entries for Parts A–E (lab journal rubric, `instructor/grading-and-rubrics.md`).
- The completed **CVE-mapping table** and the prioritized **attack plan** (planning only).
- The **Recon mini-project report** — see the prompt and rubric in `assessment.md` and the penetration-test report rubric in `instructor/grading-and-rubrics.md`.

## Stretch goals (optional)
- Run the full Nessus/OpenVAS scan and triage every finding (true vs likely false positive, with justification).
- Write a one-page deep-dive on one CVE (what, CVSS, affected versions, fix).
- Complete an additional TryHackMe enumeration room and add a journal entry.
- Expand the attack plan and defend the ordering to a peer.

## Answer key (instructor only)
*(Regenerate from YOUR Metasploitable 2 image — versions drift. Typical values below.)*
- **HTTP (80):** Apache 2.2.8; web apps present (DVWA, Mutillidae, phpinfo). robots.txt may be absent. Apps = rich attack surface for Module 3.
- **FTP (21):** anonymous login often allowed; banner `vsFTPd 2.3.4`. NSE `ftp-anon` confirms.
- **SMB (139/445):** Samba 3.x; `smbclient -L`/`enum4linux` reveal shares (e.g., `tmp`, `IPC$`) and user accounts (`msfadmin`, etc.). This is the classic "manual enumeration finds users/shares a port scan can't" lesson.
- **SSH (22):** `SSH-2.0-OpenSSH_4.7p1`.
- **NSE:** `ftp-anon` = "Anonymous FTP login allowed"; `smb-os-discovery` = Unix/Samba details; `smb-enum-shares` lists shares; `--script vuln` may flag several (and some **false positives** — good teaching moment).
- **Sample CVE mappings:**
  - vsftpd 2.3.4 → **CVE-2011-2523** (backdoor command execution), CVSS ~10. True positive — but **do NOT exploit; map only.**
  - Samba 3.x → e.g., **CVE-2007-2447** ("username map script" RCE), high severity.
  - UnrealIRCd 3.2.8.1 (port 6667) → **CVE-2010-2075** (backdoor).
  - Expect students to flag at least one scanner finding as a **likely false positive** and propose manual verification.
- **Attack plan:** acceptable plans prioritize high-CVSS, confirmed findings (e.g., vsftpd backdoor) and justify ordering. Full credit requires it stays a **plan** — any actual exploitation is a scope violation; redirect to Module 3.
- **Common errors:** scanning/enumerating off-target (STOP, re-teach scope); exploiting instead of planning (hold the line); trusting scanner output without verification; empty SMB/`-O` output (missing `sudo`/wrong tool).
