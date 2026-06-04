# Unit 09 — Vulnerability Scanning & Enumeration

- **Module:** Module 2 — Reconnaissance (final unit of the module)
- **Suggested week:** Week 9
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Vulnerability Scanning

> This unit closes Module 2. Students now know how to find live hosts and open ports (Unit 08); here they learn to **dig into each service (enumeration)** and to **identify which findings are actually vulnerabilities (vuln scanning)** — then turn that into an **attack plan** (without attacking; exploitation is Module 3). The big skills: **manual enumeration of common services**, **nmap NSE scripts**, **awareness of automated vuln scanners**, and **mapping findings to CVEs** while watching for **false positives.** The module ends with the **Recon mini-project**: a professional recon report on the authorized lab target. The authorization rule still governs everything — vuln scanning is active and requires permission.

## Learning objectives
By the end of this unit, students can:
- **Distinguish** scanning, enumeration, and vulnerability scanning, and explain how they build on each other.
- **Manually enumerate** common services — HTTP, FTP, SMB, and SSH — and explain why manual enumeration matters even when automated tools exist.
- **Run** targeted nmap **NSE scripts** against a service and interpret the output.
- **Describe** automated vulnerability scanners (Nessus Essentials, OpenVAS/Greenbone) at an awareness level, and optionally run one in the lab.
- **Map** an enumerated service/version to a **CVE** and read the basics of a CVE/severity entry.
- **Identify** likely **false positives** and explain how to verify a finding manually.
- **Turn** enumeration findings into a prioritized **attack plan** (what to try first and why) — without exploiting.
- **Produce** the Module 2 **Recon mini-project report** on the authorized lab target.

## Standards alignment
- **NICE Framework:** Knowledge of vulnerability assessment tools/CVEs (K0009, K0040, K0070); Task — perform vulnerability scanning and enumeration (T0028, T0510); Work role exposure: Vulnerability Assessment Analyst, Penetration Tester.
- **CSTA / state CS standards:** 3A-NI-05 (security risks/safeguards), 3B-NI-04 (security trade-offs), 3A-NI-04 (services/protocols).
- **Security+ domain(s):** 1.0 (scanning), 4.0 (vulnerability management, CVE/CVSS), 2.0 (threats/vulnerabilities).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Scanning | Finding live hosts and open ports (Unit 08) — the "what's there" step. |
| Enumeration | Actively digging into a service to extract details: users, shares, versions, config — the "what exactly is it" step. |
| Vulnerability scanning | Checking services/versions against a database of known weaknesses to flag likely vulnerabilities. |
| Vulnerability | A weakness that could be exploited to harm confidentiality, integrity, or availability. |
| Service enumeration | Probing a specific service (HTTP, FTP, SMB, SSH) for usable detail. |
| SMB | Server Message Block — Windows file/printer sharing; often enumerable for shares/users. |
| NSE | Nmap Scripting Engine — small scripts that automate enumeration/detection/vuln checks. |
| CVE | Common Vulnerabilities and Exposures — a public ID for a specific known vulnerability (e.g., CVE-2011-2523). |
| CVSS | A 0–10 severity score for a vulnerability (higher = more severe). |
| False positive | A finding a tool reports as a vulnerability that turns out not to be real/exploitable. |
| Automated vuln scanner | A tool (Nessus, OpenVAS) that scans broadly and reports possible vulnerabilities. |
| Nessus Essentials | A free-for-limited-use vulnerability scanner (free tier caps the number of IPs). |
| OpenVAS / Greenbone | A free, open-source vulnerability scanner. |
| Attack surface | All the points where a target could be probed or attacked. |
| Attack plan | A prioritized list of what an attacker would try, and why, based on findings. |

## Materials & prep
- Kali VM (nmap + NSE, smbclient, enum4linux, netcat, a browser, curl — all on Kali).
- **Metasploitable 2** target on the **host-only** network (from Unit 08). A TryHackMe **enumeration** room is an approved browser-based alternative.
- **Optional:** Nessus Essentials (free tier; account/activation required) or OpenVAS in the lab VM — set up ahead of time if you choose the optional vuln-scan lab.
- Handouts: per-service enumeration checklists (HTTP/FTP/SMB/SSH); NSE script cheat sheet; "how to read a CVE" guide; **Recon mini-project report template**; pointer to the report rubric in `instructor/grading-and-rubrics.md`.
- **Instructor prep notes:**
  - Reconfirm host-only networking and that nmap/enum tools only reach the lab target. Same #1 safety control as Unit 08 — restate scope daily.
  - Pre-run manual enumeration and NSE scripts; record expected shares/users/versions for the answer key (versions drift).
  - **Nessus/OpenVAS is optional and awareness-first.** If you run it, install/activate before class (Nessus Essentials requires registration and limits scanned IPs; first plugin download is slow). If hardware/time is tight, do the *awareness* version: show an instructor-captured report.
  - Pre-select 2–3 CVEs that match your Metasploitable versions (e.g., vsftpd 2.3.4 backdoor) for the CVE-mapping activity. Students **map** to CVEs; they do **not** exploit (that's Module 3).
  - Have the **Recon mini-project** prompt and rubric ready; this is a graded Project (25% category).

## ⚖️ Ethics & legal callout
Enumeration and vulnerability scanning are **active** — they send probes and sometimes login attempts to the target, which is even "louder" and more intrusive than a port scan. **All of it requires authorization.** A vuln scanner saying "this host has a critical vulnerability" is **not** permission to exploit it — finding a weakness and attacking it are completely different acts, legally and ethically. Reporting a real, unauthorized finding is also bound by **responsible disclosure** (Unit 01): you don't post it publicly or exploit it; you report it to the owner. In this class everything stays on the authorized lab target, and we **stop at the plan** — we identify what an attacker *would* try, but exploitation waits for Module 3 on authorized targets.

**Discussion prompt:** You scan a friend's website (without asking) and a tool reports a critical vulnerability. What are your legal and ethical obligations? What should you do — and what must you absolutely NOT do?

## Lesson sequence

### Day 1 — Scanning vs enumeration vs vuln scanning; why manual matters
- **Warm-up (5–10 min):** "Last unit you found open port 445 running Samba. What's the *next* question you'd ask about it?"
- **Direct instruction (15–20 min):** Define and sequence **scanning → enumeration → vulnerability scanning.** Why **manual enumeration matters**: automated tools miss context, produce false positives, and a human can spot a misconfiguration a scanner ignores. Re-anchor the authorization rule (this is active).
- **Guided practice (15 min):** From the Unit 08 scan results, as a class pick which open services are worth enumerating and predict what each might reveal.
- **Independent practice / lab:** Lab Setup + Part A (HTTP enumeration).
- **Closure / exit ticket (5 min):** "In one sentence each, define scanning, enumeration, and vuln scanning."

### Day 2 — Manual enumeration of common services (HTTP, FTP, SMB, SSH)
- **Warm-up (5–10 min):** "What could an anonymous FTP login or an open SMB share leak?"
- **Direct instruction (15–20 min):** Per-service enumeration: **HTTP** (directories, server header, robots.txt, tech), **FTP** (anonymous login, banner, files), **SMB** (shares/users via smbclient/enum4linux), **SSH** (banner, version, auth methods). What each leak is worth.
- **Guided practice (15 min):** Instructor demos anonymous FTP and an SMB share listing against the lab target; students record findings.
- **Independent practice / lab:** Lab Part B (FTP + SMB + SSH enumeration).
- **Closure / exit ticket (5 min):** "Name one thing manual SMB enumeration can find that a quick port scan won't."

### Day 3 — nmap NSE scripts + automated vuln scanners (awareness/optional lab)
- **Warm-up (5–10 min):** "What if nmap could run a small program against each open port to dig deeper?"
- **Direct instruction (15–20 min):** **NSE**: script categories (default, safe, vuln), running `--script` against a port (e.g., `--script smb-os-discovery`, `ftp-anon`). Then **automated vuln scanners** at awareness level: what Nessus Essentials / OpenVAS do, their value (broad coverage) and limits (noise, false positives, no context). Show a sample report.
- **Guided practice (15 min):** Run a couple of NSE scripts together and interpret output.
- **Independent practice / lab:** Lab Part C (NSE scripts) + **optional** Part D (run Nessus/OpenVAS or analyze the instructor-provided report).
- **Closure / exit ticket (5 min):** "Give one strength and one weakness of an automated vuln scanner vs manual enumeration."

### Day 4 — Mapping findings to CVEs, false positives, and building an attack plan
- **Warm-up (5–10 min):** "You found 'vsftpd 2.3.4.' How would you find out if that version is dangerous?"
- **Direct instruction (15–20 min):** Reading a **CVE** entry and **CVSS** severity; mapping a service/version to its CVE(s). **False positives**: why scanners over-report and how to verify manually before trusting a finding. Turning verified findings into a prioritized **attack plan** ("what would I try first, and why") — **planning only, no exploitation.**
- **Guided practice (15 min):** As a class, map 2–3 lab-target services to CVEs and flag one likely false positive; sketch a mini attack plan together.
- **Independent practice / lab:** Lab Part E (CVE mapping + attack-plan draft).
- **Closure / exit ticket (5 min):** "What is a false positive, and how would you verify a scanner finding before trusting it?"

### Day 5 — Recon mini-project (Module 2 milestone)
- **Warm-up (5–10 min):** Re-read the lab **Safety & authorization reminder** and the ethics callout. "We can build an attack plan — why do we STOP before exploiting?"
- **Direct instruction (10 min):** Review the **Recon mini-project report template** and the **penetration-test report rubric** in `instructor/grading-and-rubrics.md`. The report combines passive recon (Unit 07), active scanning (Unit 08), and this unit's enumeration/vuln findings into one professional document.
- **Guided practice / independent lab:** Students assemble the **Recon mini-project report** on the authorized lab target.
- **Closure / exit ticket (5 min):** Submit the mini-project (or draft); one-sentence reflection on responsible disclosure.
- **Assessment:** Unit quiz (`assessment.md`) + the Recon mini-project is the graded Module 2 deliverable.

## Differentiation
- **Support:** Provide per-service enumeration checklists with the exact commands and a fill-in findings sheet. Give a partially completed CVE-mapping table and a report template with section prompts/sentence frames. Use the browser-based TryHackMe enumeration room. Skip the optional Nessus lab and use the instructor-captured report instead.
- **Extension:** Run the full Nessus Essentials / OpenVAS scan, triage every finding, and label true vs likely false positives with justification. Research and write up a CVE in depth (what it is, CVSS, affected versions, fix). Build a fuller, prioritized attack plan and defend the ordering. Complete an additional TryHackMe enumeration room.

## Homework / independent work
- Complete the per-service enumeration checklists from memory.
- Finish the Recon mini-project report draft / enumeration room if not done in class.
- Short write-up (½ page): "A scanner flags a 'critical' vulnerability on a server you don't own. What do you do and what must you NOT do? Use *authorization* and *responsible disclosure*."

## Assessment
- **Formative:** Daily exit tickets; service-enumeration checks; NSE interpretation check; CVE-mapping check; false-positive reasoning; instructor walk-around verifying on-target work only.
- **Summative:** Unit quiz + the **Recon mini-project report** (Module 2 milestone, Project category) — see `assessment.md` and the report rubric in `instructor/grading-and-rubrics.md`.

## Instructor notes & common pitfalls
- **Same #1 risk: target selection.** Enumeration/vuln scanning is even more intrusive than port scanning. Keep everything on the authorized lab target; restate scope daily; watch for off-target work.
- Hammer the distinction: **finding a vulnerability is not permission to exploit it.** Students get excited at "critical" findings — hold the line; exploitation is Module 3 on authorized targets only.
- Students treat scanner output as gospel — teach **false positives** and manual verification explicitly.
- Nessus/OpenVAS setup is the biggest time-sink; have the awareness/instructor-report fallback ready. Nessus Essentials is free but registration-gated and IP-limited; OpenVAS is fully open-source but heavier to install.
- The Recon mini-project is a real grade — give students the rubric **before** they start.
- Tie forward: this report and attack plan become the launch point for Module 3 (web attacks / exploitation) and the final pentest report (Unit 17).
