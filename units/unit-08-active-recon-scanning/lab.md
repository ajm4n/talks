# Unit 08 Lab — Scanning an Isolated Target with nmap

- **Platform:** Kali VM + **Metasploitable 2** target on a **host-only** network. A TryHackMe **"Nmap"** room is an approved browser-based alternative.
- **Time:** ~4 class periods (Parts A–E across Days 1–5)
- **Difficulty:** beginner

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment and **only** against
the isolated Metasploitable 2 VM on the host-only network or an authorized
TryHackMe room. **Port-scanning any system you do not own or have written
permission to test is illegal** — in many places it is a crime by itself, or
evidence of attempted intrusion, even if nothing breaks. There is no "I was just
curious" exception. nmap is installed on Kali by default; never point it at the
school network, the internet, or any real host. The only thing that makes the same
command legal is **written authorization and a defined scope.** If you are unsure,
stop and ask your instructor.

## Objectives
- Confirm the target VM is on the isolated host-only network and find its IP.
- Discover live hosts with `-sn`.
- Run progressive port scans (`-sT`/`-sS`, `-p`, `--top-ports`, `-p-`) and read port states.
- Fingerprint services and OS with `-sV`, `-O`, `-sC`.
- Adjust timing and save results in multiple output formats.
- Grab service banners with netcat and compare them to nmap's findings.
- Produce an **annotated scan results** journal entry.

## Setup
1. Start your Kali VM and the Metasploitable 2 VM. Confirm **both** use a **host-only / internal** adapter (NOT bridged/NAT to the internet).
2. In your lab journal, write the date, objective, and this **scope statement:** *"I am authorized to scan only the isolated lab target on the host-only network."*
3. Find your Kali IP and subnet:
```bash
ip a
```
4. Reread the safety reminder above before sending a single packet.

## Walkthrough

### Part A — Host discovery (Day 1–2)
**Step 1 — Find live hosts** on the host-only subnet (replace with your subnet, e.g. `192.168.56.0/24`):
```bash
sudo nmap -sn 192.168.56.0/24
```
**Record:** which IPs are reported "up." Identify which one is Metasploitable (your target). Note: `-sn` does host discovery **only** — no ports scanned yet.

### Part B — Port scanning (Day 2)
**Step 2 — Quick top-ports TCP connect scan:**
```bash
nmap -sT --top-ports 20 <target-ip>
```
**Step 3 — SYN scan of the top 1000 ports** (needs root):
```bash
sudo nmap -sS <target-ip>
```
**Step 4 — Specific ports and a full scan:**
```bash
nmap -p 21,22,80,445 <target-ip>
sudo nmap -p- <target-ip>     # all 65535 ports (slower)
```
**Record:** for each scan, list ports and their **state** (open/closed/filtered). In your own words, explain the difference between `-sT` and `-sS`.

### Part C — Fingerprinting (Day 3)
**Step 5 — Service/version, OS, and default scripts together:**
```bash
sudo nmap -sS -sV -sC -O -p- <target-ip>
```
**Record:** for each open port, the **service** and **version** nmap reports, the **OS guess**, and any interesting `-sC` script output. Star (★) the version numbers — those are your leads for Unit 09.

### Part D — Timing & output formats (Day 4)
**Step 6 — Run a scan and save all output formats:**
```bash
sudo nmap -sS -sV -T4 -oA scan_target <target-ip>
```
This creates `scan_target.nmap` (normal), `.gnmap` (grepable), `.xml` (XML).
**Step 7 — Compare timing** (observe speed, don't over-run the network):
```bash
nmap -sT -T1 --top-ports 10 <target-ip>   # slow/stealthy
nmap -sT -T4 --top-ports 10 <target-ip>   # faster
```
**Record:** attach/cite the saved output files; note which format you'd grep vs hand to another tool; one sentence on what `-T1` vs `-T4` changes.

### Part E — Banner grabbing with netcat (Day 5)
**Step 8 — Connect to services by hand and read the banner:**
```bash
nc <target-ip> 21      # FTP banner
nc <target-ip> 22      # SSH banner
```
(For HTTP, after connecting type `HEAD / HTTP/1.0` then press Enter twice.)
**Record:** the raw banner text, and compare it to nmap's `-sV` guess for the same port. Did they agree?

## Deliverables
- **Lab journal** entries for Parts A–E (graded with the lab journal rubric in `instructor/grading-and-rubrics.md`).
- An **annotated scan results** entry: paste your fingerprinting scan output and annotate each open port with its service, version, and one note on why it matters.
- The saved `-oA` output files (`.nmap`, `.gnmap`, `.xml`).

## Stretch goals (optional)
- Capture `-sS` vs `-sT` in Wireshark and explain the half-open vs full handshake (callback to Unit 03).
- Write a Bash one-liner (Unit 05) that runs nmap with `-oG` and greps only the open ports.
- Complete an additional TryHackMe scanning room and add a journal entry.
- Research one of the starred service versions and predict whether it has known issues (preview of Unit 09).

## Answer key (instructor only)
*(Regenerate from YOUR Metasploitable 2 image — version strings drift. Typical defaults below.)*
- **Host discovery:** Kali + Metasploitable show "up." Target is usually the `.x` you assigned (commonly seen at `192.168.56.10x`).
- **Open ports (typical Metasploitable 2):** 21 (vsftpd 2.3.4), 22 (OpenSSH 4.7p1), 23 (telnet), 25 (Postfix smtpd), 53 (ISC BIND 9.4.2), 80 (Apache httpd 2.2.8), 111 (rpcbind), 139/445 (Samba 3.x), 512/513/514 (r-services), 1099, 1524 (bindshell/"root"), 2049 (NFS), 2121 (ProFTPD), 3306 (MySQL 5.0.51a), 3632 (distccd), 5432 (PostgreSQL 8.3), 5900 (VNC), 6000 (X11), 6667 (UnrealIRCd), 8009 (AJP13), 8180 (Apache Tomcat).
- **Port states:** nearly all listed = `open`; unlisted scanned ports = `closed` (Metasploitable has no host firewall, so almost nothing is `filtered`). Good teaching contrast vs a firewalled THM box.
- **OS detection (`-O`):** guesses Linux 2.6.x — remind students this is a *guess*.
- **`-sT` vs `-sS`:** `-sT` = full 3-way handshake, works without root, noisier/logged; `-sS` = half-open (SYN, then RST), faster/stealthier, needs root. Full credit = correct trade-off, not just definitions.
- **Banners:** FTP (21) announces `220 (vsFTPd 2.3.4)`; SSH (22) announces `SSH-2.0-OpenSSH_4.7p1 Debian-8ubuntu1`. Should match nmap `-sV`. The vsftpd 2.3.4 string is a famous backdoored version — note it as a Unit 09 lead, do NOT exploit here.
- **Output formats:** `.gnmap` is grep-friendly (`grep open scan_target.gnmap`); `.xml` feeds other tools; `.nmap` is human-readable.
- **Common errors:** scanning the wrong/real network (STOP, re-teach scope); empty `-sS`/`-O` output (missing `sudo`); confusing `filtered` vs `closed`; treating `-O` as fact.
