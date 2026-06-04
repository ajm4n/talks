# Unit 08 — Active Information Gathering & Scanning

- **Module:** Module 2 — Reconnaissance
- **Suggested week:** Week 8
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Active Information Gathering

> This unit is where students first **touch the target directly.** That single fact changes everything about the ethics: passive recon (Unit 07) read public records; active recon **sends packets to the target**, which is exactly the kind of "access" computer-crime law cares about. The core idea: **active scanning against any system you do not own or have written permission to test is illegal — full stop.** We only ever scan the isolated lab VM (Metasploitable 2 on the host-only network) or authorized TryHackMe rooms. The technical heart of the unit is **nmap**, taught deeply but accessibly.

## Learning objectives
By the end of this unit, students can:
- **Explain** what active information gathering is and why it legally requires authorization, contrasting it with passive recon.
- **Describe** host discovery and port scanning at a conceptual level (what "open," "closed," and "filtered" ports mean).
- **Run** an nmap host-discovery (ping) scan with `-sn` and interpret which hosts are up.
- **Distinguish** a TCP connect scan (`-sT`) from a SYN scan (`-sS`) and explain when each is used.
- **Select** ports to scan with `-p` (specific ports, ranges, `-p-`, `--top-ports`).
- **Identify** running services and versions with `-sV`, attempt OS detection with `-O`, and run default scripts with `-sC`.
- **Adjust** scan timing (`-T0`–`-T5`) and save results in multiple **output formats** (`-oN`, `-oG`, `-oX`).
- **Read and annotate** an nmap report, identifying open ports, services, and versions.
- **Grab a service banner** with netcat and explain what it reveals.

## Standards alignment
- **NICE Framework:** Knowledge of network scanning/enumeration tools and techniques (K0342, K0177); Task — conduct active information gathering / network mapping (T0696); Work role exposure: Vulnerability Assessment Analyst, Penetration Tester.
- **CSTA / state CS standards:** 3A-NI-04 (network protocols/services), 3A-NI-05 (security risks), 3B-NI-04 (security trade-offs).
- **Security+ domain(s):** 1.0 (reconnaissance, active scanning), 4.0 (security operations — network mapping).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Active information gathering | Directly probing/connecting to a target's systems (scanning, banner grabbing) — requires authorization. |
| Host discovery | Finding which hosts/IPs are alive on a network before scanning their ports. |
| Port | A numbered "door" on a host where a service listens (e.g., 80 = web, 22 = SSH). |
| Port state | Whether a port is **open** (service listening), **closed** (reachable, nothing listening), or **filtered** (a firewall is blocking). |
| Port scanning | Checking which ports on a host are open/closed/filtered. |
| nmap | The standard open-source network mapper / port scanner. |
| Ping scan (`-sn`) | Host discovery only — find live hosts without scanning ports. |
| TCP connect scan (`-sT`) | Completes the full TCP handshake; works without admin rights but is "noisier." |
| SYN scan (`-sS`) | "Half-open" scan; sends SYN, doesn't finish the handshake; faster/stealthier; needs root. |
| Service/version detection (`-sV`) | Asks open ports what software and version they are running. |
| OS detection (`-O`) | nmap's best guess at the target's operating system from network fingerprints. |
| Default scripts (`-sC`) | Runs nmap's safe default NSE scripts to gather extra detail. |
| Timing template (`-T0`–`-T5`) | How fast/aggressive the scan runs; `-T4` is common in labs, `-T0` is very slow/stealthy. |
| Banner grabbing | Connecting to a service to read the text it announces (often its name/version). |
| netcat (`nc`) | A simple tool to read/write raw network connections; useful for banner grabbing. |
| Output format | How nmap saves results: normal (`-oN`), grepable (`-oG`), XML (`-oX`), or all (`-oA`). |

## Materials & prep
- Kali VM (Unit 02) with nmap and netcat installed (both ship with Kali).
- **Metasploitable 2** target VM on the **host-only / internal** network (no internet bridge). Intentionally vulnerable; isolated.
- Free TryHackMe accounts — the **"Nmap"** room is an approved browser-based alternative target.
- Handouts: nmap flag cheat sheet; "anatomy of an nmap report" annotated sample; port-state reference; lab journal template.
- **Instructor prep notes:**
  - Verify both VMs are on a **host-only** adapter and can reach each other but NOT the internet/school LAN. Confirm with `ip a` and a quick `ping`. This is the single most important safety control.
  - Pre-run each scan yourself and record the expected open ports/services for the answer key (versions drift between Metasploitable images).
  - If host-only networking is unavailable, default to the TryHackMe Nmap room (browser-based, free tier) — pre-complete it.
  - SYN scans (`-sS`, `-O`) need root; have students use `sudo` or fall back to `-sT`. Decide your policy.
  - Remind students nmap is installed by default — emphasize they must NEVER point it outside the lab. Consider a signed AUP acknowledgment before this unit.

## ⚖️ Ethics & legal callout
Unit 07 was "just looking" at public records. **This unit sends packets to a target — that is direct, unauthorized access territory.** In many jurisdictions (and under laws like the U.S. CFAA), **port-scanning a system you don't own or aren't authorized to test can itself be a crime, or strong evidence of attempted intrusion** — even if you "didn't break anything." There is no "I was just curious" exception. The **only** thing that makes the exact same nmap command legal is **written authorization and a defined scope.** In this class, that scope is: the isolated Metasploitable VM and approved TryHackMe rooms. Nothing else.

**Discussion prompt:** Knocking on every door in a neighborhood to see which are unlocked isn't "breaking in" — but is it harmless? How is port scanning similar? Why does the law still care, and why does authorization change the answer?

## Lesson sequence

### Day 1 — Active vs passive, the law, and what scanning actually does
- **Warm-up (5–10 min):** "Last week we read public records about a target. This week we send packets *to* the target. Why might that be a bigger legal deal?"
- **Direct instruction (15–20 min):** Define **active information gathering**. Re-anchor the authorization rule from the course philosophy. Explain **host discovery** and **ports** (the "doors" analogy), and the three **port states**: open, closed, filtered. Introduce nmap as the standard tool.
- **Guided practice (15 min):** As a class, classify scenarios as legal/illegal based solely on authorization & scope. Verify lab VMs are on host-only networking together.
- **Independent practice / lab:** Lab Setup + Part A (host discovery `-sn`).
- **Closure / exit ticket (5 min):** "Why does scanning a real third-party server without permission risk being a crime, even if nothing breaks?"

### Day 2 — nmap host discovery and port scanning (`-sn`, `-sT` vs `-sS`, `-p`)
- **Warm-up (5–10 min):** "What's the difference between finding which houses are occupied and checking which doors are unlocked?"
- **Direct instruction (15–20 min):** `-sn` (ping scan / host discovery). Then port scanning: **TCP connect `-sT`** (full handshake, no root, noisier) vs **SYN `-sS`** (half-open, faster/stealthier, needs root). Port selection with `-p 22,80,443`, ranges `-p 1-1000`, all ports `-p-`, and `--top-ports`.
- **Guided practice (15 min):** Instructor demos `-sn` then a `-sT` top-ports scan against Metasploitable; students predict before each result.
- **Independent practice / lab:** Lab Part B (progressive port scans).
- **Closure / exit ticket (5 min):** "When would you choose `-sT` over `-sS`?"

### Day 3 — Fingerprinting: service/version (`-sV`), OS (`-O`), default scripts (`-sC`)
- **Warm-up (5–10 min):** "An open port tells you a door exists. How would you learn *what's behind* the door?"
- **Direct instruction (15–20 min):** `-sV` (service & version detection), `-O` (OS detection + its uncertainty), `-sC` (default NSE scripts). Combine into a common recon command (e.g., `sudo nmap -sS -sV -sC -O -p- target`). Why **versions** matter (they map to known vulnerabilities — foreshadows Unit 09).
- **Guided practice (15 min):** Run a combined scan together; annotate the report line by line on the board.
- **Independent practice / lab:** Lab Part C (fingerprinting + annotation).
- **Closure / exit ticket (5 min):** "Why is the *version* number of a service so valuable to both attackers and defenders?"

### Day 4 — Timing, output formats, and reading scan results
- **Warm-up (5–10 min):** "Why might a scanner run *slowly* on purpose?"
- **Direct instruction (15–20 min):** Timing templates `-T0`–`-T5` (stealth vs speed; `-T4` typical in lab, `-T0/-T1` evade detection but are slow). Output formats: `-oN` normal, `-oG` grepable, `-oX` XML, `-oA` all. How professionals save evidence for the report. Walk the **anatomy of an nmap report** handout.
- **Guided practice (15 min):** Save a scan with `-oA`, open each output file, discuss which format suits which purpose.
- **Independent practice / lab:** Lab Part D (timing + output formats; produce saved evidence files).
- **Closure / exit ticket (5 min):** "Which output format would you grep for 'open 80/tcp', and which would you hand to another tool?"

### Day 5 — Banner grabbing with netcat + annotated results writeup
- **Warm-up (5–10 min):** "nmap guessed the service. How could you confirm it by hand?"
- **Direct instruction (10–15 min):** **Banner grabbing** with netcat (`nc target 21`, `nc target 22`); reading the announced service/version text; comparing to nmap's `-sV` guess. Read the lab **Safety & authorization reminder** aloud.
- **Guided practice / independent lab:** Lab Part E (netcat banners) + assemble the **annotated scan results** journal entry.
- **Closure / exit ticket (5 min):** Submit annotated scan results; one-sentence reflection on the authorization line for active scanning.
- **Assessment:** Unit quiz (`assessment.md`) end of Day 5 or start of Week 9.

## Differentiation
- **Support:** Provide a "scan ladder" handout with the exact commands to run in order and a fill-in-the-blank annotation sheet. Use the browser-based TryHackMe Nmap room to avoid VM/networking friction. Pair students. Pre-set `sudo` so SYN/OS scans "just work."
- **Extension:** Compare `-sS` vs `-sT` packet behavior in Wireshark (callback to Unit 03). Try evasion-relevant timing (`-T0` vs `-T4`) and discuss IDS detection. Script a small Bash loop (Unit 05) that runs nmap and greps `-oG` output. Complete an extra TryHackMe scanning room.

## Homework / independent work
- Complete the nmap flag cheat sheet from memory and define each flag in your own words.
- Finish the annotated scan results entry / TryHackMe Nmap room if not done in class.
- Short write-up (½ page): "Why is the exact same nmap command legal against our lab VM but a potential crime against a stranger's server? Use *authorization* and *scope*."

## Assessment
- **Formative:** Daily exit tickets; "predict the port state" checks; flag-definition checks; instructor walk-around verifying scans target only the lab VM.
- **Summative:** Unit quiz + the **annotated scan results** deliverable in the lab journal — see `assessment.md`. (Feeds the Module 2 recon mini-project in Unit 09.)

## Instructor notes & common pitfalls
- **The #1 risk this unit is target selection.** nmap is on every Kali box; a curious student can scan the school network or the internet in seconds — which can be illegal and will trigger IT alerts. Verify host-only networking, restate the scope every single day, and watch for off-target scans.
- Students confuse **filtered** vs **closed** — reinforce: filtered = a firewall is dropping/blocking; closed = reachable but nothing listening.
- `-sS` and `-O` silently misbehave without root; if results look empty/weird, check for `sudo`.
- OS detection (`-O`) is a **guess**; don't let students treat it as fact.
- Metasploitable version strings drift — regenerate the answer key from your own image.
- Tie forward: the open ports/services/versions found here become the **enumeration and vuln-scanning** targets in Unit 09 and feed the recon mini-project.
