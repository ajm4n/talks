# Unit 08 Assessment — Active Information Gathering & Scanning

## Formative checks
- **Exit tickets** (Days 1–5): why unauthorized scanning is a legal risk; `-sT` vs `-sS`; why versions matter; output-format choice; banner-vs-`-sV` comparison.
- **"Predict the port state"** checks: given a scenario, classify open/closed/filtered.
- **Flag-definition checks:** student states what `-sn`, `-sV`, `-O`, `-sC`, `-p-` do.
- **Instructor walk-around:** verify every student's scans target ONLY the lab VM (initial the journal).

## Quiz

1. Active information gathering is different from passive recon because it:
   - A) Only reads public records  B) Directly sends packets to / connects to the target
   - C) Is always legal  D) Never uses any tools

2. Port-scanning a stranger's server without permission is best described as:
   - A) Always perfectly legal because nothing breaks
   - B) Potentially a crime / evidence of attempted intrusion in many jurisdictions
   - C) Legal only if you use nmap
   - D) Legal if you are curious

3. A port reported as **filtered** most likely means:
   - A) A service is listening and responding
   - B) The port is reachable but nothing is listening
   - C) A firewall is blocking/dropping the probe
   - D) The host is powered off

4. Which nmap option performs **host discovery only** (no port scan)?
   - A) `-sV`  B) `-sn`  C) `-p-`  D) `-O`

5. Compared to a TCP connect scan (`-sT`), a SYN scan (`-sS`):
   - A) Completes the full handshake and needs no privileges
   - B) Is half-open, often faster/stealthier, and typically needs root
   - C) Only scans UDP ports
   - D) Cannot detect open ports

6. Which option asks open ports what **software and version** they are running?
   - A) `-sn`  B) `-O`  C) `-sV`  D) `-p`

7. `nmap -p-` scans:
   - A) Only the top 1000 ports  B) Only port 80
   - C) All 65,535 TCP ports  D) No ports

8. The OS-detection result from `-O` should be treated as:
   - A) A guaranteed fact  B) A best-guess that can be wrong
   - C) The target's password  D) Proof of a vulnerability

9. Which output format is easiest to **grep** for open ports / feed to a script?
   - A) Normal (`-oN`)  B) Grepable (`-oG`)  C) A screenshot  D) None can be searched

10. **Banner grabbing** with netcat lets you:
    - A) Decrypt all traffic  B) Read the text a service announces (often its name/version)
    - C) Shut down the service  D) Bypass authorization requirements

11. The ONLY thing that makes the exact same nmap command legal against a real server is:
    - A) Running it slowly  B) Using a VPN
    - C) Written authorization and a defined scope  D) Scanning at night

12. **Short answer:** Explain the difference between a **closed** port and a **filtered** port.

13. **Short answer:** Why is the **version number** of a service (e.g., "vsftpd 2.3.4") so valuable to both an attacker and a defender? Connect your answer to the next unit.

## Performance task — Annotated scan results
**Prompt:** Run the combined fingerprinting scan (`-sS -sV -sC -O -p-`) against the authorized lab target, then produce an **annotated scan results** entry in your lab journal. For each open port, label the service, the version, and write one sentence on why it matters. Include the scope statement confirming you scanned only the authorized lab VM.

**Deliverable:** Annotated scan output + saved `-oA` files in the lab journal. (Feeds the Module 2 recon mini-project in Unit 09.)

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Scope & ethics | Clear scope statement; only the authorized lab target scanned | Scope stated | Vague scope | Missing or off-target scan |
| Scan accuracy | All open ports, services, versions correctly captured | Most captured | Some missing | Sparse/incorrect |
| Annotation | Each port explained with why-it-matters insight | Most annotated | Minimal notes | Missing |
| Professionalism | Clean, labeled, reproducible commands, output files attached | Organized | Rough | Hard to follow |

## Answer key
1: B — 2: B — 3: C — 4: B — 5: B — 6: C — 7: C — 8: B — 9: B — 10: B — 11: C

12. A **closed** port is reachable but has no service listening (the host replies that nothing is there). A **filtered** port means a firewall or filter is blocking/dropping the probe, so nmap cannot tell whether a service is listening.

13. A version number maps to **known vulnerabilities (CVEs)**: an attacker can look up published exploits for that exact version, and a defender knows what to patch. This is exactly the next step — Unit 09 turns these versions into vulnerability findings and an attack plan.
