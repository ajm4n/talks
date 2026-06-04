---
marp: true
theme: bootstrap
paginate: true
header: "Introduction to Offensive Security · Unit 08"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Active Information Gathering & Scanning
## Module 2 — Reconnaissance · Unit 08

Last week we *read* about the target. This week we start *talking to it* — and that changes everything legally.

<!-- This is the first unit that sends packets to a target. The ethics shift is the whole point: passive recon read public records; active recon sends packets, which is exactly the "access" computer-crime law cares about. VERIFY host-only networking before anyone scans. nmap is the technical heart, taught deeply but accessibly. -->

---

# Where we are in Module 2

- Unit 07 — Passive recon (OSINT): read public records.
- **Unit 08 — Active recon & scanning** ← this week: send packets to the target.
- Unit 09 — Vuln scanning & enumeration → recon mini-project.

> The single change this week: **we now touch the target directly.** That changes the law.

---

# Learning objectives (1 of 2)

By the end of this unit you can:

- **Explain** active information gathering and why it legally requires authorization.
- **Describe** host discovery and the three port states: **open**, **closed**, **filtered**.
- **Run** an nmap host-discovery (ping) scan with `-sn`.
- **Distinguish** a TCP connect scan (`-sT`) from a SYN scan (`-sS`).
- **Select** ports with `-p`, ranges, `-p-`, and `--top-ports`.

---

# Learning objectives (2 of 2)

- **Identify** services/versions with `-sV`, attempt OS detection with `-O`, run default scripts with `-sC`.
- **Adjust** scan timing (`-T0`–`-T5`) and save results in multiple **output formats**.
- **Read and annotate** an nmap report — open ports, services, versions.
- **Grab a service banner** with netcat and explain what it reveals.

<!-- Objectives from the lesson plan. Revisit at the recap. -->

---

# Vocabulary — concepts

| Term | Meaning |
|------|---------|
| **Active info gathering** | Directly probing/connecting to a target — requires authorization. |
| **Host discovery** | Finding which hosts/IPs are alive before scanning ports. |
| **Port** | A numbered "door" where a service listens (80 = web, 22 = SSH). |
| **Port state** | **open** (listening), **closed** (reachable, nothing there), or **filtered** (firewall blocking). |
| **Port scanning** | Checking which ports are open/closed/filtered. |
| **nmap** | The standard open-source network mapper / port scanner. |

---

# Vocabulary — scan types & flags

| Term | Meaning |
|------|---------|
| **Ping scan (`-sn`)** | Host discovery only — no ports scanned. |
| **TCP connect (`-sT`)** | Full handshake; no root needed; "noisier." |
| **SYN scan (`-sS`)** | Half-open; faster/stealthier; needs root. |
| **Version detection (`-sV`)** | Asks open ports what software/version they run. |
| **OS detection (`-O`)** | nmap's *guess* at the operating system. |
| **Default scripts (`-sC`)** | Runs nmap's safe default NSE scripts. |

---

# Vocabulary — timing, output, banners

| Term | Meaning |
|------|---------|
| **Timing template (`-T0`–`-T5`)** | How fast/aggressive the scan runs (`-T4` typical in lab). |
| **Banner grabbing** | Reading the text a service announces (often its name/version). |
| **netcat (`nc`)** | Simple tool for raw network connections; great for banners. |
| **Output format** | How nmap saves results: `-oN` normal, `-oG` grepable, `-oX` XML, `-oA` all. |

---

<!-- _class: lead -->

# Day 1
## Active vs passive, the law, and what scanning actually does

<!-- Day 1. Warm-up: "Last week we read public records. This week we send packets TO the target. Why might that be a bigger legal deal?" -->

---

# Warm-up

> Last week we **read** public records about a target. This week we **send packets to** the target.

Why might that be a bigger legal deal?

- Reading a public record touches **no one's system**.
- Sending packets is **direct interaction** — exactly the kind of "access" computer-crime law cares about.

---

# What active information gathering is

- **Active info gathering** = directly probing or connecting to a target's systems.
- Examples: port scanning, banner grabbing, service fingerprinting.
- It is **louder** and leaves traces (logs, IDS alerts) on the target.

> Active = you reach out and touch the target. That is why it **requires authorization**.

---

# Ports: the doors of a host

- A **port** is a numbered door where a service listens.
- Common: **80** (web), **22** (SSH), **445** (SMB), **21** (FTP).
- **Host discovery** finds which machines are alive *before* you check their ports.

> Think of a building: host discovery finds which buildings are occupied; port scanning checks which doors are unlocked.

---

# The three port states

| State | Meaning |
|-------|---------|
| **Open** | A service is listening and responding. |
| **Closed** | Reachable, but nothing is listening there. |
| **Filtered** | A firewall is blocking or dropping the probe. |

> **Closed ≠ filtered.** Closed = "nobody home." Filtered = "a guard won't let you knock."

<!-- Students confuse filtered vs closed constantly. Reinforce: filtered = firewall dropping; closed = reachable but nothing listening. -->

---

# Guided practice + verify the lab

- Classify scenarios as **legal / illegal** based *only* on authorization & scope.
- Then verify your VMs are on **host-only networking** and can reach each other but **not** the internet:

```bash
ip a          # find your Kali IP and subnet
```

<!-- Verifying host-only networking is the single most important safety control this unit. Confirm both VMs are host-only (NOT bridged/NAT) before anyone scans. -->

---

# Lab Setup + Part A — host discovery

```bash
sudo nmap -sn 192.168.56.0/24
```

- `-sn` = **ping scan**: find live hosts only, **no ports scanned yet**.
- Identify which IP is your target (the isolated Metasploitable VM).
- Write your **scope statement** in the journal first: *"I am authorized to scan only the isolated lab target on the host-only network."*

---

# Exit ticket — Day 1

> Why does scanning a real third-party server without permission risk being a **crime**, even if nothing breaks?

<!-- Looking for: sending packets is direct access; under laws like the CFAA, unauthorized scanning can itself be a crime or evidence of attempted intrusion. No "just curious" exception. -->

---

<!-- _class: lead -->

# Day 2
## Host discovery and port scanning (`-sn`, `-sT` vs `-sS`, `-p`)

<!-- Day 2. Warm-up: "What's the difference between finding which houses are occupied and checking which doors are unlocked?" Demo -sn then a -sT top-ports scan; have students predict before each result. -->

---

# Warm-up

> What's the difference between finding which **houses are occupied** and checking which **doors are unlocked**?

- Occupied houses → **host discovery** (`-sn`)
- Unlocked doors → **port scanning** (`-sT`, `-sS`)

First you find what's alive; then you probe it.

---

# TCP connect scan (`-sT`)

```bash
nmap -sT --top-ports 20 <target-ip>
```

- Completes the **full TCP 3-way handshake** (SYN → SYN/ACK → ACK).
- **Works without root** — anyone can run it.
- "Noisier": the full connection is more likely to be **logged**.

> Use `-sT` when you don't have root privileges.

---

# SYN scan (`-sS`)

```bash
sudo nmap -sS <target-ip>
```

- "**Half-open**": sends SYN, gets SYN/ACK, then sends **RST** — never finishes the handshake.
- **Faster and stealthier** than `-sT`.
- **Needs root** (`sudo`).

> Use `-sS` when you have root and want speed/stealth.

<!-- -sS and -O silently misbehave without root. If results look empty/weird, check for sudo. -->

---

# `-sT` vs `-sS` side by side

| | `-sT` connect | `-sS` SYN |
|---|---|---|
| Handshake | Full 3-way | Half-open (SYN, then RST) |
| Root needed? | No | **Yes** |
| Speed | Slower | Faster |
| Profile | Noisier, logged | Stealthier |

> Same goal (find open ports), different trade-offs.

---

# Choosing which ports to scan

```bash
nmap -p 22,80,443 <target-ip>     # specific ports
nmap -p 1-1000 <target-ip>        # a range
sudo nmap -p- <target-ip>         # ALL 65,535 ports (slower)
nmap --top-ports 20 <target-ip>   # the most common ports
```

- Start small, broaden as you learn the target.
- `-p-` is thorough but slow — use it when it's worth the wait.

---

# Lab Part B — progressive port scans

```bash
nmap -sT --top-ports 20 <target-ip>
sudo nmap -sS <target-ip>
nmap -p 21,22,80,445 <target-ip>
sudo nmap -p- <target-ip>
```

**Record** for each scan: ports and their **state** (open/closed/filtered). In your own words, explain the difference between `-sT` and `-sS`.

<!-- Typical Metasploitable 2 has almost no firewall, so nearly everything is open or closed (little filtered). Good contrast vs a firewalled THM box. -->

---

# Exit ticket — Day 2

> When would you choose `-sT` over `-sS`?

<!-- Answer: when you don't have root/sudo (-sS needs root); -sT works unprivileged though it's noisier. -->

---

<!-- _class: lead -->

# Day 3
## Fingerprinting: service/version (`-sV`), OS (`-O`), default scripts (`-sC`)

<!-- Day 3. Warm-up: "An open port tells you a door exists. How would you learn WHAT'S behind the door?" Run a combined scan together; annotate the report line by line on the board. -->

---

# Warm-up

> An open port tells you a **door exists**. How would you learn **what's behind** the door?

You ask it. nmap can:

- Ask the service its **name and version** (`-sV`)
- Guess the **operating system** (`-O`)
- Run small scripts for **extra detail** (`-sC`)

---

# Service/version detection (`-sV`)

```bash
nmap -sV <target-ip>
```

- Connects to each open port and asks: *what software, what version?*
- Output like `21/tcp open ftp vsftpd 2.3.4`.

> The **version** is the prize: it maps to known vulnerabilities. (More in Unit 09.)

---

# OS detection (`-O`)

```bash
sudo nmap -O <target-ip>
```

- nmap fingerprints how the host responds to network probes and **guesses** the OS.
- Example: "Linux 2.6.x" — a *best guess*, not fact.
- **Needs root.**

> Treat `-O` as a hint, never as proof.

<!-- OS detection is a GUESS. Don't let students treat it as fact. -->

---

# Default scripts (`-sC`)

```bash
nmap -sC <target-ip>
```

- Runs nmap's **safe default NSE scripts** to gather extra detail.
- Can reveal things like SSL info, supported auth methods, or directory listings.

> A free first pass of automated enumeration — bundled into the scan.

---

# Combining it all

```bash
sudo nmap -sS -sV -sC -O -p- <target-ip>
```

| Flag | Does |
|------|------|
| `-sS` | SYN scan (stealthy, needs root) |
| `-sV` | service & version detection |
| `-sC` | default scripts |
| `-O` | OS guess |
| `-p-` | all 65,535 ports |

> The classic recon command. **Star (★) every version number** — those are Unit 09's leads.

---

# Lab Part C — fingerprint & annotate

```bash
sudo nmap -sS -sV -sC -O -p- <target-ip>
```

**Record** for each open port:

- the **service** and **version** nmap reports
- the **OS guess** (note: a guess)
- any interesting `-sC` script output

★ the version numbers — your leads for Unit 09.

<!-- Annotate the report line by line on the board together before students do it solo. -->

---

# Exit ticket — Day 3

> Why is the **version** number of a service so valuable to both attackers and defenders?

<!-- Answer: versions map to known vulnerabilities (CVEs). An attacker looks up published exploits for that exact version; a defender knows what to patch. This is the bridge to Unit 09. -->

---

<!-- _class: lead -->

# Day 4
## Timing, output formats, and reading scan results

<!-- Day 4. Warm-up: "Why might a scanner run SLOWLY on purpose?" Walk the "anatomy of an nmap report" handout. Save a scan with -oA and open each output file. -->

---

# Warm-up

> Why might a scanner run **slowly** on purpose?

- A fast, aggressive scan is **easy to detect** — it spikes traffic and trips alarms.
- A slow scan blends into normal traffic — **stealthier**, but takes much longer.

Speed vs stealth is a trade-off you control with **timing templates**.

---

# Timing templates (`-T0`–`-T5`)

| Template | Behavior |
|----------|----------|
| `-T0` / `-T1` | Very slow — evades detection (paranoid/sneaky) |
| `-T3` | Default |
| `-T4` | Faster — **typical in the lab** |
| `-T5` | Fastest — can miss results / be unreliable |

```bash
nmap -sT -T1 --top-ports 10 <target-ip>   # slow / stealthy
nmap -sT -T4 --top-ports 10 <target-ip>   # faster
```

---

# Output formats

```bash
sudo nmap -sS -sV -T4 -oA scan_target <target-ip>
```

| Flag | File | Best for |
|------|------|----------|
| `-oN` | `.nmap` (normal) | Humans to read |
| `-oG` | `.gnmap` (grepable) | `grep` / scripting |
| `-oX` | `.xml` (XML) | Feeding other tools |
| `-oA` | all three | Saving everything at once |

> Professionals save scan output as **evidence** for the report.

---

# Reading an nmap report

A typical line:

```text
21/tcp   open   ftp     vsftpd 2.3.4
```

| Field | Meaning |
|-------|---------|
| `21/tcp` | Port number / protocol |
| `open` | Port state |
| `ftp` | Service |
| `vsftpd 2.3.4` | Software + version |

> Read every line: port → state → service → version.

---

# Lab Part D — timing & output

```bash
sudo nmap -sS -sV -T4 -oA scan_target <target-ip>
nmap -sT -T1 --top-ports 10 <target-ip>
nmap -sT -T4 --top-ports 10 <target-ip>
```

**Record:** attach/cite the saved files; note which format you'd **grep** vs **hand to another tool**; one sentence on what `-T1` vs `-T4` changes.

```bash
grep open scan_target.gnmap     # quick open-port list
```

---

# Exit ticket — Day 4

> Which output format would you **grep** for `open 80/tcp`, and which would you **hand to another tool**?

<!-- Answer: grep the grepable format (.gnmap, -oG); hand the XML (.xml, -oX) to another tool. -->

---

<!-- _class: lead -->

# Day 5
## Banner grabbing with netcat + annotated results writeup

<!-- Day 5. Warm-up: "nmap guessed the service. How could you confirm it by hand?" Read the lab Safety & authorization reminder aloud. -->

---

# Warm-up

> nmap **guessed** the service with `-sV`. How could you **confirm** it by hand?

You connect to the port yourself and read what it tells you — the **banner**.

---

# Banner grabbing with netcat

```bash
nc <target-ip> 21      # FTP banner
nc <target-ip> 22      # SSH banner
```

- A **banner** is the text a service announces — often its name and version.
- For HTTP: connect, then type `HEAD / HTTP/1.0` and press Enter twice.

> netcat reads/writes raw connections — the simplest way to talk to a service by hand.

---

# Comparing banner to `-sV`

| Port | Banner (netcat) | nmap `-sV` |
|------|-----------------|-----------|
| 21 (FTP) | `220 (vsFTPd 2.3.4)` | `vsftpd 2.3.4` |
| 22 (SSH) | `SSH-2.0-OpenSSH_4.7p1 Debian-8ubuntu1` | `OpenSSH 4.7p1` |

> They should **agree**. The `vsftpd 2.3.4` string is a famous backdoored version — **note it as a Unit 09 lead; do NOT exploit it here.**

<!-- Hold the line: this is recon. The vsftpd 2.3.4 backdoor is exciting but exploitation is Module 3. -->

---

# Lab Part E — banners + annotated results

```bash
nc <target-ip> 21
nc <target-ip> 22
```

**Record:** the raw banner text; compare to nmap's `-sV` for the same port. Did they agree?

Then assemble your **annotated scan results** journal entry: paste the fingerprinting output and annotate each open port with service, version, and why it matters.

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

## This unit sends packets to a target. That is direct-access territory.

Port-scanning a system you don't own or aren't authorized to test **can itself be a crime** — or evidence of attempted intrusion — even if nothing breaks.

<!-- Re-anchor the rule. The #1 risk this unit is target selection. Restate scope every day. -->

---

# No "just curious" exception

- The **same nmap command** is legal against our lab VM and a **crime** against a stranger's server. The only difference is **written authorization + a defined scope.**
- Our scope: the isolated **Metasploitable 2** VM and approved **TryHackMe** rooms. **Nothing else.**
- nmap ships on every Kali box — **never** point it at the school network or the internet.

> There is no "I was just curious" exception.

---

# Discussion

> Knocking on every door in a neighborhood to see which are unlocked isn't "breaking in."
>
> But is it **harmless**? How is **port scanning** similar? Why does the law still care — and why does **authorization** change the answer?

<!-- Let students argue both sides, then land it: intent + authorization are what the law (and ethics) hinge on. -->

---

# Recap

- Active recon **touches the target** — authorization is mandatory.
- Host discovery first (`-sn`), then ports, then fingerprinting.
- Port states: open / closed / **filtered** (firewall) ≠ closed.
- `-sT` (no root, noisy) vs `-sS` (root, stealthy). `-O` is a *guess*.
- **Versions are the gold** — they become Unit 09's vuln leads.
- Save output as evidence. Stay on the lab VM, every day.

---

# Key vocabulary — quick review

| Term | Meaning |
|---|---|
| `-sn` | Ping scan (host discovery only) |
| `-sT` / `-sS` | TCP connect / SYN (half-open) scan |
| `-sV` / `-O` / `-sC` | Version / OS / default-script detection |
| `-p-` / `--top-ports` | All ports / most common ports |
| Port state | open / closed / filtered |
| Banner grabbing | Reading the text a service announces |
| `-oN` / `-oG` / `-oX` / `-oA` | Normal / grepable / XML / all output |

---

<!-- _class: lead -->

# Exit ticket — Day 5 + homework

**Exit ticket:** submit annotated scan results; one sentence on the authorization line for active scanning.

**Homework:**
- Complete the nmap flag cheat sheet from memory.
- ½-page: "Why is the exact same nmap command legal against our lab VM but a potential crime against a stranger's server?" Use **authorization** and **scope**.

*Next up — Unit 09: Vulnerability Scanning & Enumeration + the Module 2 recon mini-project.*

<!-- Open ports/services/versions found here feed Unit 09 and the recon mini-project. Quiz from assessment.md end of Day 5 or start of Week 9. -->
