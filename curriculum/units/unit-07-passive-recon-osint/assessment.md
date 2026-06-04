# Unit 07 Assessment — Passive Information Gathering (OSINT)

## Formative checks
- **Exit tickets** (Days 1–5): passive vs active example; what an MX record / CT log leaks; "PDF-only on one site" dork; one metadata item + how to remove it; ethics reflection.
- **Passive-vs-active sort:** students correctly classify 8 activities and name which require authorization.
- **Dork-building check:** student writes a well-formed dork using at least two operators.
- **Metadata check:** student names three things metadata can leak.
- **Instructor walk-around:** initial the WHOIS/DNS lookup milestone in each journal.

## Quiz

1. Which phase comes FIRST in the attacker lifecycle?
   - A) Exploitation  B) Reconnaissance  C) Post-exploitation  D) Reporting

2. Which is an example of **passive** information gathering?
   - A) Running an nmap scan against the target's server
   - B) Reading the target company's public job postings
   - C) Logging into the target's admin panel
   - D) Sending a phishing email to an employee

3. "It's public information, so using it however I want is always legal and ethical." This statement is:
   - A) True — public means anything goes
   - B) False — aggregating public facts about a real person can be doxing/harassment and privacy/authorization still apply
   - C) True, but only for companies
   - D) False, because public information does not exist

4. A **WHOIS** record can reveal which of the following?
   - A) The registrar and registration/expiry dates
   - B) The exact passwords for the website
   - C) The contents of the company's email
   - D) Live CPU usage of the server

5. Which DNS record points to a domain's **mail** servers?
   - A) A  B) NS  C) MX  D) CNAME

6. **Certificate transparency logs** are useful in OSINT because they can:
   - A) Decrypt HTTPS traffic
   - B) Reveal subdomains/hostnames a company never advertised
   - C) Show user passwords
   - D) Disable a website

7. Which Google dork finds only PDF files on the single site `example.com`?
   - A) `example.com pdf`
   - B) `site:example.com filetype:pdf`
   - C) `intitle:example.com -pdf`
   - D) `inurl:pdf example`

8. A job posting that says "must know Apache, Windows Server 2016, Cisco ASA" is valuable to an attacker because it:
   - A) Reveals the company's likely technology stack (attack-surface clues)
   - B) Contains the admin password
   - C) Is illegal to read
   - D) Proves the company has no security

9. Which is **metadata** that can leak from a document or photo?
   - A) Author username, creating software version, GPS coordinates
   - B) The reader's IP address
   - C) The Wi-Fi password of whoever opens it
   - D) Nothing — files contain no hidden data

10. The course's single most important dividing line between a penetration tester and a criminal is:
    - A) The tools they use
    - B) How fast they type
    - C) Written authorization and an agreed scope
    - D) Whether the target is a company or a person

11. **Short answer:** Explain why "passive recon doesn't touch the target's systems" does NOT mean passive recon is always legal or ethical. Use the words *scope*, *doxing*, and *authorization*.

12. **Short answer:** Give one defender (blue-team) action a person or company can take to reduce its OSINT footprint, and say what threat it reduces.

## Project / performance task — Mini OSINT Report
**Prompt:** Using only the authorized teacher-seeded target, write a short, professional **mini OSINT report**. Include: (1) the target and a **scope statement** confirming authorization; (2) the **sources** you used; (3) **findings organized by source** (WHOIS/DNS, certificate transparency, search/dorking, job posting, metadata); and (4) a **defender "so what"** section recommending how the target could reduce its exposure. No real third party may appear in the report.

**Deliverable:** 1–2 page mini OSINT report submitted with your lab journal. (This report feeds forward into the Module 2 recon mini-project in Unit 09.)

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Scope & ethics | Clear authorization/scope statement; only the seeded target appears | Scope stated | Vague scope | Missing or targets a real third party |
| Findings by source | Accurate findings from all five source types, each explained | Most sources covered | Some sources, little explanation | Sparse/incorrect |
| Defender "so what" | Specific, actionable exposure-reduction steps tied to findings | General recommendations | Vague | Missing |
| Professionalism | Polished, organized, correct terminology | Solid | Rough | Hard to follow |

## Answer key
1: B — 2: B — 3: B — 4: A — 5: C — 6: B — 7: B — 8: A — 9: A — 10: C

11. Passive recon avoids touching the target's systems, so it rarely breaks computer-intrusion law by itself — but **authorization** and **scope** still apply, and aggregating public facts about a real person is **doxing**, which is harmful and often illegal regardless of where each fact came from. "Public" is not the same as "ethical to use."

12. Accept any reasonable answer, e.g.: enable privacy settings / make profiles private (reduces social-media OSINT); strip metadata before posting documents/photos (reduces username + GPS leaks); use a domain-privacy/redaction service on WHOIS (reduces registrant exposure); write generic job postings without exact software versions (reduces tech-stack inference); use a password manager with unique passwords (reduces breach-data reuse risk). Must name the threat reduced.
