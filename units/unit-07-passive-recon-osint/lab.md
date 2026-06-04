# Unit 07 Lab — Passive OSINT on an Authorized Target

- **Platform:** Browser-based (any laptop) + optional Kali VM (`whois`, `dig`, `exiftool`). A TryHackMe OSINT room is an approved alternative.
- **Time:** ~3 class periods, woven across Days 2–5
- **Difficulty:** intro

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment and **only** against
the teacher-seeded fictional target or **your own** public footprint. Doing this to
any system, person, or organization you do not own or have written permission to
investigate is illegal. Passive recon never touches a target's systems — but
aggregating public facts about a **real** person (their address, schedule,
employer, family) is **doxing**, which is harmful and often illegal no matter where
each fact came from. If you are not 100% sure a target is authorized, stop and ask
your instructor.

## Objectives
- Perform domain/infrastructure recon (WHOIS, DNS, certificate transparency) on the authorized target and record what each field reveals.
- Build and run Google "dorks" against the teacher-provided dataset to locate specific seeded files and pages.
- Infer a target's likely technology stack from a seeded job posting.
- Extract metadata from a sample document and explain what it leaks.
- Audit **your own** public digital footprint and list concrete steps to reduce it.
- Assemble all findings into a short, professional mini OSINT report.

## Setup
1. Confirm the **authorized target** with your instructor (the seeded persona/company, e.g., "Nora Vance / BrightLeaf Coffee"). Write the target and the **scope statement** at the top of your lab journal: *"I am authorized to gather only publicly available information about this teacher-seeded fictional target."*
2. Open your lab journal. Record date, objective, and tools.
3. (Optional) Start your Kali VM from Unit 02 if you are using the command-line tools.
4. Confirm you are NOT pointing any tool at a real third party. Reread the safety reminder.

## Walkthrough

### Part A — Domain & infrastructure recon (Day 2)
**Step 1 — WHOIS.** Look up who registered the target's domain.
- Browser: use a WHOIS lookup site provided by your instructor, or
- Kali:
```bash
whois brightleafcoffee.example
```
Expected: registrar name, registration/expiry dates, name servers, and possibly a (redacted) registrant. **Record:** which fields are present and what each could tell a defender or attacker.

**Step 2 — DNS records.** Look up the record types.
```bash
dig brightleafcoffee.example A
dig brightleafcoffee.example MX
dig brightleafcoffee.example NS
dig brightleafcoffee.example TXT
```
(Browser alternative: an online "DNS lookup" tool.) **Record:** the A (address), MX (mail), NS (name server), and any TXT records, and one sentence on what MX records reveal.

**Step 3 — Certificate transparency / subdomains.** Using the CT-log search tool your instructor provides (pointed at the seeded data), list any subdomains that appear (e.g., `mail.`, `vpn.`, `dev.`). **Record:** which subdomains showed up and why an unadvertised `dev.` host matters to attack surface.

### Part B — Search-engine OSINT & tech-stack inference (Day 3)
**Step 4 — Google dorks against the seeded dataset.** Using the teacher-provided sandbox/dataset (NOT the live internet against a real org), build dorks:
```text
site:brightleafcoffee.example filetype:pdf
site:brightleafcoffee.example intitle:"index of"
"BrightLeaf" filetype:xlsx -site:brightleafcoffee.example
```
**Record:** each dork, what it was meant to find, and what it actually returned.

**Step 5 — Tech-stack inference.** Read the seeded **job posting**. List every technology named (e.g., "Apache, Windows Server 2016, Cisco ASA"). **Record:** the likely tech stack and why a posting is an information leak.

### Part C — Metadata & your own footprint (Day 4)
**Step 6 — Document metadata.** Extract metadata from the teacher-provided sample document.
- Kali:
```bash
exiftool sample-brochure.pdf
```
- Browser alternative: an online metadata viewer your instructor approves.
**Record:** author/username, creating software + version, timestamps, and any GPS data. Note what each could leak.

**Step 7 — Your own footprint (privacy lesson).** Audit **only yourself** using the self-audit checklist. Search your own name; check what is public on your own accounts; check your own email in a breach-notification service if you choose. **Do NOT search classmates or anyone else.** Keep this private if you wish — you are not required to share results.

## Deliverables
- **Lab journal** entries for Parts A–C (graded with the lab journal rubric in `instructor/grading-and-rubrics.md`).
- **Mini OSINT report** on the authorized target: target + scope statement, sources used, findings organized by source, and a defender "so what / how to reduce exposure" section. (See `assessment.md` for the prompt and rubric.)
- A short list of 3 concrete steps you will take to shrink your own footprint.

## Stretch goals (optional)
- Complete an additional TryHackMe OSINT room (free tier, browser-based) and add a journal entry.
- Map the full attack surface of the seeded org from CT logs + subdomains and draw a diagram.
- Write a one-page defender memo: "How I would reduce this organization's exposure."
- Compare browser vs Kali command-line methods for the same lookup and note pros/cons.

## Answer key (instructor only)
*(Exact values depend on YOUR seeded packet. Below are the expected findings for the reference "BrightLeaf Coffee" seed; substitute your own.)*
- **WHOIS:** Registrar = "DemoRegistrar LLC"; created 2021-03-04, expires 2026-03-04; NS = `ns1/ns2.demoreg.example`; registrant redacted (privacy). Students should note redaction does NOT mean "nothing learned" — dates and registrar still useful.
- **DNS:** A = `203.0.113.10`; MX = `mail.brightleafcoffee.example` (reveals mail provider/self-hosted); NS as above; TXT contains a seeded SPF record (`v=spf1 ...`) hinting at email vendor.
- **CT / subdomains:** `mail.`, `www.`, and a seeded `dev.brightleafcoffee.example` — the `dev.` host is the key finding (unadvertised, likely weaker, expands attack surface).
- **Dorks:** the `filetype:pdf` dork returns the seeded brochure; the `index of` dork returns a seeded open directory; the `xlsx` dork returns a seeded "employee-list" spreadsheet. Full credit = dork is well-formed AND student explains intent vs result.
- **Job posting tech stack:** Apache 2.4, Windows Server 2016, Cisco ASA, MySQL — students should connect "named versions = known-CVE leads" (foreshadows Unit 09).
- **Metadata (sample-brochure.pdf):** Author = `j.okafor`; software = "LibreOffice 7.2"; created/modified timestamps; a seeded GPS tag. Key teaching point: `j.okafor` is a likely **username format** (first-initial-last-name) usable in later attacks; software version is a CVE lead.
- **Footprint audit:** No fixed answer — assess on completion and quality of the 3 reduction steps, not on what was found. Never require sharing.
- **Common errors:** running tools against the live internet / a real org (STOP and re-teach scope); treating "passive = always legal"; confusing A vs MX records; malformed dorks (missing `:` or quotes).
