# Unit 09 Assessment — Vulnerability Scanning & Enumeration

## Formative checks
- **Exit tickets** (Days 1–5): define scanning/enumeration/vuln scanning; what manual SMB enumeration finds; scanner strength vs weakness; false-positive verification; responsible-disclosure reflection.
- **Service-enumeration checks:** student names one useful finding per service (HTTP/FTP/SMB/SSH).
- **NSE interpretation check:** student explains the output of one NSE script in their own words.
- **CVE-mapping check:** student maps one version to a CVE and reads its severity.
- **Instructor walk-around:** verify all work stays on the authorized target and **no exploitation** occurs (initial the journal).

## Quiz

1. Put these in the correct order:
   - A) Vuln scanning → enumeration → scanning
   - B) Scanning → enumeration → vulnerability scanning
   - C) Enumeration → scanning → vuln scanning
   - D) They have no order

2. **Enumeration** differs from a basic port scan because it:
   - A) Only lists open ports
   - B) Digs into a service for detail (users, shares, versions, config)
   - C) Never touches the target
   - D) Requires no authorization

3. Why does **manual** enumeration still matter when automated scanners exist?
   - A) It doesn't — scanners are always better
   - B) Humans add context, catch misconfigurations, and verify scanner findings
   - C) It is faster than every tool
   - D) It is the only legal method

4. **SMB** enumeration on a target can reveal:
   - A) Decrypted passwords for every user
   - B) Network shares and user accounts
   - C) The target's physical location
   - D) Nothing useful

5. **NSE** stands for and refers to:
   - A) Network Security Edition — a Linux distro
   - B) Nmap Scripting Engine — small scripts that automate enumeration/detection/vuln checks
   - C) New Scan Export — an output format
   - D) Nessus Scan Engine

6. A **CVE** is:
   - A) A free vulnerability scanner
   - B) A public identifier for a specific known vulnerability
   - C) A type of firewall
   - D) The score of how severe a bug is

7. **CVSS** is best described as:
   - A) A 0–10 severity score for a vulnerability
   - B) A scanning tool
   - C) A port number
   - D) A scripting language

8. A **false positive** is:
   - A) A real, exploitable vulnerability
   - B) A finding a tool reports that turns out not to be real/exploitable
   - C) A closed port
   - D) A type of CVE

9. An automated vuln scanner reports "CRITICAL: vulnerable to CVE-XXXX." Before trusting it, you should:
   - A) Immediately exploit it to confirm
   - B) Verify it manually (check the version/behavior) because it may be a false positive
   - C) Post it online
   - D) Assume it is wrong and ignore it

10. A scanner finding a critical vulnerability on a target you are authorized to scan means you may now:
    - A) Exploit it freely
    - B) Note it and plan — but exploitation requires its own authorization and waits for Module 3
    - C) Sell the finding
    - D) Scan other people's servers

11. If you find a real vulnerability on a system you do NOT own, the right action is:
    - A) Exploit it to prove it's real
    - B) Post it publicly to warn others
    - C) Follow responsible disclosure — report it to the owner, don't exploit or publicize
    - D) Nothing is required

12. **Short answer:** In your own words, define **scanning**, **enumeration**, and **vulnerability scanning**, and explain how each builds on the previous.

13. **Short answer:** A teammate says "the scanner found a critical vuln, so let's exploit it right now." Explain what's wrong with that, using *authorization* and *false positive*.

## Project / performance task — Recon Mini-Project (Module 2 milestone)
**Prompt:** Produce a professional **Recon Report** on the authorized lab target that combines all of Module 2: passive recon context (Unit 07 methods/awareness), active scanning results (Unit 08), and this unit's enumeration, vuln-scan findings, CVE mappings, and a prioritized **attack plan** (planning only — no exploitation). Open with a scope statement confirming authorization; include methodology, findings (with evidence and severity), and recommended remediations. This is a graded **Project** (25% category).

**Deliverable:** A multi-section Recon Report (with the supporting lab journal). Graded with the **penetration-test report rubric** in `instructor/grading-and-rubrics.md`. (See that file for the full rubric; summary below.)

**Rubric (summary — full version in `instructor/grading-and-rubrics.md`):**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Scope & ethics | Clear authorization/scope; planning only, no exploitation | Scope stated | Vague | Missing or off-target/exploited |
| Methodology | Recon → scan → enumerate → vuln-map phases clearly described | Phases described | Partial | Missing |
| Findings | Each has evidence, version/CVE, and severity | Most complete | Incomplete | Missing/incorrect |
| Remediation | Specific, actionable fixes per finding | General fixes | Vague | Missing |
| Communication | Polished, organized, correct terminology | Solid | Rough | Unclear |

## Answer key
1: B — 2: B — 3: B — 4: B — 5: B — 6: B — 7: A — 8: B — 9: B — 10: B — 11: C

12. **Scanning** finds live hosts and open ports ("what's there"). **Enumeration** digs into each open service for detail — users, shares, versions, configuration ("what exactly is it"). **Vulnerability scanning** checks those services/versions against a database of known weaknesses to flag likely vulnerabilities ("what's weak"). Each step uses the output of the previous: you can't enumerate a service you haven't found, and you can't map vulnerabilities without knowing the service and version.

13. Two problems. (1) **Authorization:** finding a vulnerability is not permission to exploit it — exploitation is a separate, more serious act that needs its own authorization and, in this course, waits for Module 3 on authorized targets. (2) **False positive:** the scanner may be wrong; the finding must be verified manually before it's trusted. Acting on an unverified "critical" can waste effort or, off a lab target, be an illegal intrusion.
