# Unit 07 — Passive Information Gathering (OSINT)

- **Module:** Module 2 — Reconnaissance
- **Suggested week:** Week 7
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Passive Information Gathering

> This unit opens Module 2 (Reconnaissance). It is the first time students "gather information about a target" — so the ethics framing is front-and-center. The core idea: **passive recon collects information that is already public, without ever touching the target's systems.** Even so, *what* you do with that information, and *who* you point it at, is bound by law and ethics. We practice only on a teacher-seeded fictional target or on the students' own footprint — never on a real third party.

## Learning objectives
By the end of this unit, students can:
- **Describe** the reconnaissance phase and where it sits in the attacker lifecycle (recon → scanning → exploitation → post-exploitation → reporting).
- **Distinguish** passive information gathering from active information gathering, and give one example of each.
- **Name and explain** at least six OSINT sources (WHOIS, DNS records, search-engine "dorking," certificate transparency, job postings, social media, document metadata, breach-data awareness).
- **Construct** a basic Google "dork" using operators (`site:`, `filetype:`, `intitle:`, `inurl:`, `-`) against teacher-provided data.
- **Look up** WHOIS and DNS records for an authorized/safe domain and explain what each field reveals.
- **Extract** metadata from a sample document and explain why it can leak sensitive information.
- **Evaluate** their own public digital footprint and list concrete steps to reduce it (defender view).
- **Explain** the legal and ethical limits of OSINT, including why "it's public" does not make every use lawful or ethical.
- **Produce** a short, professional mini OSINT report on an authorized target.

## Standards alignment
- **NICE Framework:** Knowledge of OSINT and reconnaissance techniques (K0177, K0436); Task — conduct open-source intelligence collection (T0751); Work role exposure: Threat/Warning Analyst, Cyber Defense Analyst.
- **CSTA / state CS standards:** 3A-NI-05 (security/privacy of data), 3A-IC-29 (privacy and data collection trade-offs), 3B-NI-04 (security risks).
- **Security+ domain(s):** 1.0 (reconnaissance, OSINT), 5.0 (governance — privacy, data handling awareness).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Reconnaissance (recon) | The information-gathering phase of an assessment — learning about a target before doing anything else. |
| Attacker lifecycle | The ordered phases of an attack/test: recon → scanning → exploitation → post-exploitation → reporting. |
| Passive information gathering | Collecting information *without* directly interacting with the target's systems (using public sources and third parties). |
| Active information gathering | Directly probing the target's systems (scanning, connecting) — covered next unit, and it requires authorization. |
| OSINT | Open-Source Intelligence — information gathered from publicly available sources. |
| Footprint (digital footprint) | The trail of public information that exists about a person or organization online. |
| WHOIS | A public record showing who registered a domain name and related details (registrar, dates, sometimes contacts). |
| DNS record | An entry in the internet's "phonebook" mapping names to addresses/services (A, MX, NS, TXT, CNAME). |
| Subdomain | A name under a main domain, like `mail.example.com` under `example.com`. |
| Google dorking | Using advanced search operators to find specific or unintended public information. |
| Search operator | A keyword that narrows a search (`site:`, `filetype:`, `intitle:`, `inurl:`, `-`). |
| Certificate transparency (CT) | Public logs of issued TLS certificates; can reveal subdomains and hostnames. |
| Metadata | "Data about data" — hidden info inside files (author, software, GPS, timestamps). |
| Breach data | Information exposed in a past data breach; awareness only — we do not download or use it. |
| Attack surface | All the points where a target could potentially be probed or attacked. |
| Scope | The agreed boundary of what you are allowed to look at or test. |

## Materials & prep
- Student laptops with a web browser (most of this unit is browser-based; no special install required).
- Optional: Kali VM (from Unit 02) for command-line tools `whois`, `dig`/`nslookup`, and `exiftool`.
- Free **TryHackMe** accounts (an OSINT room is an approved alternative target — browser-based, free tier).
- **Teacher-seeded target packet** (the safe, fictional persona/company — see prep notes).
- Handouts: "OSINT source map" reference; Google-dork operator cheat sheet; mini OSINT report template; digital-footprint self-audit checklist.
- **Instructor prep notes:**
  - **Build or obtain the safe target.** Create a fictional persona/company (e.g., "Nora Vance, founder of *BrightLeaf Coffee*") with seeded artifacts you control: a sample WHOIS/DNS export, a couple of mock "social media" screenshots, a sample PDF/Word doc with deliberately-embedded metadata, and a mock "job posting." Place these in a shared lab folder or a sandbox site you host. This guarantees every student finds the same expected results and **no real person is targeted.**
  - If using a TryHackMe OSINT room instead, verify access on the school network and pre-complete it to know the answers.
  - For the "own footprint" activity, set ground rules: students audit **only themselves**, never classmates. No screenshots of other students. This is a privacy lesson, not a doxing exercise.
  - Decide whether to enable the optional Kali command-line tools or keep the unit fully browser-based.
  - Pre-read the breach-data section: we cover it at **awareness level only**. Do not have students download breach dumps or enter anyone's real email into breach-checking tools beyond their own.

## ⚖️ Ethics & legal callout
"It's public" is **not** the same as "anything goes." Passive recon never touches the target's systems, so it rarely breaks computer-intrusion laws by itself — but **pointing reconnaissance at a real person or organization you have no authorization to assess can still cross into stalking, harassment, privacy violations, or be the planning stage of a crime.** Aggregating public facts about a real individual (their address, schedule, employer, family) is **doxing**, and it is harmful and often illegal regardless of where each fact came from. In this unit we gather information **only** about a teacher-seeded fictional target or about **our own** footprint. Authorization and scope still apply, even to "just looking."

**Discussion prompt:** Every fact in a person's "dossier" — their employer, their gym schedule, their kid's school — was individually public. Does combining public facts create something new and harmful? Where is the line between "research" and "surveillance/doxing"? Who decides?

## Lesson sequence

### Day 1 — Recon overview, the attacker lifecycle, passive vs active
- **Warm-up (5–10 min):** "If you wanted to learn everything about a new school before your first day — without setting foot on campus — how would you do it?" Brainstorm sources on the board. (This is OSINT.)
- **Direct instruction (15–20 min):** Introduce the **attacker lifecycle** and where recon sits. Define **passive** vs **active** information gathering: passive uses public sources and third parties and never touches the target; active directly probes the target (next unit) and **requires authorization**. Frame recon as a defender skill too ("attackers profile you — so should you, to reduce your footprint").
- **Guided practice (15 min):** As a class, sort a list of activities into passive vs active (e.g., "read the company's public job postings" = passive; "scan their web server with nmap" = active). Discuss the gray areas.
- **Independent practice / lab:** Read the **OSINT source map** handout; for each source, write one sentence on what it can reveal.
- **Closure / exit ticket (5 min):** "Give one example of passive recon and one example of active recon, and state which one requires authorization."

### Day 2 — Domain & infrastructure OSINT: WHOIS, DNS, certificate transparency
- **Warm-up (5–10 min):** "When a company registers a website, what public records does that create?"
- **Direct instruction (15–20 min):** WHOIS (registrar, registration/expiry dates, sometimes contacts; note privacy redaction). DNS record types: **A** (address), **MX** (mail), **NS** (name servers), **TXT**, **CNAME**. **Subdomains** and how **certificate transparency logs** can reveal hostnames a company didn't advertise. Tie back to **attack surface**.
- **Guided practice (15 min):** Instructor demo against the **teacher-seeded domain** (or a benign demo domain the instructor pre-clears): show WHOIS and DNS lookups in the browser (or `whois` / `dig` on Kali). Students record fields and what each reveals.
- **Independent practice / lab:** Begin the lab — Part A (domain/infrastructure recon on the authorized target).
- **Closure / exit ticket (5 min):** "What does an MX record tell an attacker or a defender? What does certificate transparency leak?"

### Day 3 — Search-engine OSINT (Google dorking), job postings, social media
- **Warm-up (5–10 min):** Show a benign dork like `site:gov filetype:pdf budget` and ask what it's doing.
- **Direct instruction (15–20 min):** Search operators: `site:`, `filetype:`, `intitle:`, `inurl:`, exclusion with `-`, exact phrase with quotes. How **job postings** leak the tech stack ("must know Apache, Cisco, Windows Server 2016") and **social media** leaks people, roles, and habits. Emphasize: dorking finds **already-public** pages faster — it is not "breaking in."
- **Guided practice (15 min):** Students build dorks against the **teacher-provided dataset/sandbox** (not the live internet against real orgs) to find specific seeded files and pages.
- **Independent practice / lab:** Lab Part B — search-engine OSINT and tech-stack inference from the seeded job posting.
- **Closure / exit ticket (5 min):** "Write a dork that finds only PDF files on a single given site."

### Day 4 — Document metadata, breach-data awareness, and your own footprint (defender view)
- **Warm-up (5–10 min):** "A photo you post can contain the GPS coordinates of where it was taken. True or false? Why does that matter?"
- **Direct instruction (15–20 min):** **Metadata** in documents and images (author, software, timestamps, sometimes GPS); how it leaks usernames and internal software versions. **Breach-data awareness** (covered at awareness level only): old breaches expose emails/passwords; this is why password reuse is dangerous — **we do not download or use breach dumps.** Then flip to defense: students audit **their own** public footprint and learn to shrink it (privacy settings, removing metadata, unique passwords, search yourself).
- **Guided practice (15 min):** Class extracts metadata from the **teacher-provided sample document** (browser tool or `exiftool` on Kali) and lists what leaked.
- **Independent practice / lab:** Lab Part C — metadata extraction on the sample doc **and** the personal digital-footprint self-audit.
- **Closure / exit ticket (5 min):** "Name one piece of metadata that could leak from a document and one step to remove it before sharing."

### Day 5 — Build the mini OSINT report + ethics wrap-up
- **Warm-up (5–10 min):** Re-read the Day-1 ethics callout. "What changed in how you think about your own online footprint this week?"
- **Direct instruction (10 min):** Read the **Safety & authorization reminder** in `lab.md` aloud. Review the **mini OSINT report** template: target, scope statement, sources used, findings (organized by source), and a defender "so what / how to reduce exposure" section.
- **Guided practice / independent lab:** Students assemble their findings from Parts A–C into the **mini OSINT report** on the authorized target.
- **Closure / exit ticket (5 min):** Submit the mini OSINT report draft; one-sentence reflection on the legal/ethical line of OSINT.
- **Assessment:** Unit quiz (`assessment.md`) may be given at end of Day 5 or start of Week 8.

## Differentiation
- **Support:** Provide a partially completed report template with section prompts and sentence frames ("Using WHOIS, I found ___, which tells a defender ___."). Provide a pre-built dork list to run and interpret rather than author from scratch. Pair students for the lookups. Keep the unit fully browser-based to avoid VM friction.
- **Extension:** Use the optional Kali tools (`whois`, `dig`, `exiftool`) on the command line and compare to browser methods. Map the seeded organization's full attack surface from CT logs + subdomain enumeration of the authorized target. Complete an additional TryHackMe OSINT room. Write a one-page "how I would reduce this organization's exposure" defender memo.

## Homework / independent work
- Complete the **digital-footprint self-audit checklist** on yourself and write 3 concrete actions you will take (privacy settings, unique passwords, removing metadata before posting).
- Finish the OSINT room or report draft if not completed in class (browser-based, free).
- Short write-up (½ page): "Why is "it's public" not the same as "ethical to use'? Use the words *scope*, *doxing*, and *authorization*."

## Assessment
- **Formative:** Daily exit tickets; passive-vs-active sorting; dork-building check; metadata extraction check; instructor walk-around during lookups.
- **Summative:** Unit quiz + the **mini OSINT report** deliverable — see `assessment.md`. (Sets the stage for the Module 2 recon mini-project in Unit 09.)

## Instructor notes & common pitfalls
- **The #1 risk this unit is target selection.** Keep students on the teacher-seeded target or their own footprint. Explicitly forbid pointing OSINT at real classmates, teachers, local businesses, or any real third party. Restate this each day.
- Students conflate "passive" with "legal/safe-no-matter-what." Correct it: passive recon avoids touching systems, but **doxing/harassment law and privacy still apply.**
- Google dorking is the lesson most likely to be misused at home. Frame it precisely: it surfaces **already-public** content faster; it is not hacking, but pointing it at real orgs to hunt for exposed secrets is not authorized work.
- Breach data: keep it **awareness only.** Do not let students download breach dumps or check other people's emails. The takeaway is "reuse passwords = danger," motivating password managers (Unit 14).
- The "own footprint" activity is powerful but sensitive — students may find upsetting results. Set a supportive tone, allow private journaling, and never require students to share what they found about themselves.
- Tie everything forward: the findings here feed the **recon mini-project** in Unit 09 and the eventual pentest report (Unit 17).
