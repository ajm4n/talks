---
marp: true
theme: bootstrap
paginate: true
header: "Introduction to Offensive Security · Unit 17"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Reporting & Professional Communication
## Module 5 — Putting It Together · Unit 17

The client isn't buying the hack. They're buying the **report**.

<!-- teacher note: Opens Module 5. Students undervalue the report ("hacking was the fun part"). Counter it early and often: in industry, the report IS the job. -->

---

# Learning objectives

By the end of this unit, you can:

- **Explain** why the written report is the real deliverable of a pentest.
- **Identify** the standard report sections: executive summary, methodology, findings, remediation, appendices.
- **Write** an executive summary for a leader **and** a technical finding for IT staff — from the same issue.
- **Assign** a severity (Low/Med/High/Critical) and justify it by likelihood × impact.
- **Document** a finding with evidence, impact, and specific remediation.
- **Explain** the ethics of accurate reporting — no exaggeration, no hiding.
- **Produce** a complete sample report and receive your **capstone** assignment.

<!-- teacher note: Maps to PEN-200 report writing. The sample report this week is the dress rehearsal for the Unit 18 capstone report. -->

---

# The big idea: clients pay for the report

- A brilliant test with a sloppy report is a **failed engagement**.
- The client makes real decisions and spends real money based on what you write.
- A finding that isn't clearly written and reproducible **effectively doesn't exist** for the client.

> Two weeks of brilliant hacking + a one-paragraph email = the client did **not** get what they paid for.

<!-- teacher note: Warm-up — the brilliant-hacker-hands-over-a-paragraph scenario. Did the client get what they paid for? Why not? -->

---

# Report anatomy

| Section | Purpose | Audience |
|---------|---------|----------|
| **Executive summary** | The "so what" in plain language | Busy, non-technical leaders |
| **Methodology** | How the test was done (the phases) | Anyone |
| **Findings** | Each issue: evidence, severity, impact | Technical staff |
| **Remediation** | Specific, actionable fixes | Technical staff |
| **Appendices** | Raw tool output, references | Reference |

> Plus a restated **scope & authorization** — the written proof the test was permitted.

<!-- teacher note: Show a sanitized table of contents. The CEO reads the executive summary first — often it's all they read. -->

---

# A report outline

```
1. Executive summary      (plain language — how exposed are we?)
2. Methodology            (recon → scan → exploit → document)
3. Findings
   3.1 Finding 1 — title, asset, severity, evidence, impact
   3.2 Finding 2 — ...
4. Remediation & recommendations
5. Appendices
   A. Raw tool output (nmap, gobuster)
   B. References (CVE, OWASP, CVSS)
```

> Number your findings. Label every screenshot. Use consistent terms.

---

# Anatomy of a single finding

Every finding must include:

- **Title** — clear, specific ("not the website is bad").
- **Affected asset** — host, IP, or URL.
- **Evidence** — labeled screenshots + exact commands so a reader can reproduce it.
- **Severity** — Low / Med / High / Critical, *justified*.
- **Impact** — what an attacker could actually do to the organization.
- **Remediation** — the specific fix.

> *"Trust me, it worked"* is not evidence. Label every figure: *"Figure 1: login form accepts `' OR 1=1 --`"*.

<!-- teacher note: Show two versions of one finding — labeled screenshot + steps vs. "the site is hackable." Which can a developer act on? -->

---

# Severity: likelihood × impact

| Rating | Rough meaning | Example |
|--------|---------------|---------|
| **Critical** | Easy AND severe | Unauth RCE; SQLi dumping the user table |
| **High** | Serious, takes some effort | Stored XSS stealing admin sessions; default admin password |
| **Medium** | Real risk, limited or harder | Reflected XSS needing a click; directory listing |
| **Low** | Minor, little direct impact | Verbose error leaking a version; missing header |

**Severity inflation is the #1 error.** Not everything is Critical — justify every rating.

<!-- teacher note: Pair activity — three findings, assign and justify severity. Force likelihood × impact. Contrast a real Critical (RCE) with a Low (verbose error). -->

---

# CVSS (awareness level)

- **CVSS** = Common Vulnerability Scoring System.
- An industry method that turns factors into a **0–10 score**.
- It considers things like **how easy** the attack is and **how much damage** it does.

> You don't need to compute vectors by hand. Just know it **exists** and roughly what feeds it. (Online calculators do the math.)

<!-- teacher note: Keep CVSS awareness-only. Computing full vectors frustrates beginners. Save the calculator for the extension task. -->

---

# Writing for two audiences

**Same truth, different altitude.**

| | Executive summary | Technical finding |
|--|-------------------|-------------------|
| Reader | Non-technical leader | IT staff who will fix it |
| Length | Short (2–4 sentences) | Detailed, reproducible |
| Language | Plain — **no jargon** | Precise, exact commands |
| Answers | "How exposed are we? What do we do?" | "Exactly what, where, and how to fix" |

> Executive: *"A login page let us read the customer database. We recommend fixing it immediately."*
> Technical: *"Unsanitized input in the login form permits UNION-based SQL injection."*

<!-- teacher note: The executive summary is the hardest skill — students leak jargon. Hard rule: no commands, no acronyms without a plain-language gloss. Peers hunt for jargon. -->

---

# Remediation: be specific

- ❌ "Make it more secure."
- ✅ "Use **parameterized queries** for all database calls."
- ✅ "**Change the default admin password** and enforce a strong-password policy."
- ✅ "**Validate and sanitize** all user input server-side."

> A fix the IT team can act on tomorrow. Vague advice is worthless to the client.

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

## Accuracy is an ethical duty.

**Two failures, equally serious:**
- **Exaggerating** a finding to look impressive (crying wolf, wasting their money).
- **Minimizing or hiding** a finding because it's awkward or you ran out of time.

The report is also the **written record that the test was authorized and in scope.**

<!-- teacher note: Discussion prompt — you found a Critical that was embarrassingly easy (default password). Tempted to dress it up or downplay it? Honest reporting requires the truth; the client's safety outranks your ego. -->

---

# Key vocabulary

| Term | Meaning |
|------|---------|
| Deliverable | What the client receives and pays for — the report |
| Executive summary | Short, plain-language overview for leaders |
| Methodology | How the test was done (the phases) |
| Finding | One issue, with evidence, severity, impact |
| Evidence | Proof — labeled screenshots, commands, hosts |
| Severity | Low / Med / High / Critical |
| Likelihood × Impact | How easy to exploit × how bad if exploited |
| Remediation | The specific, actionable fix |
| CVSS | Scoring system that outputs a 0–10 severity |
| Scope | The agreed boundary, restated in the report |
| Accuracy | Truthful — not exaggerated, minimized, or hidden |

---

# 🧪 Lab launch — write a sample report

- **No new attacking.** You write up a finding you **already** produced in an earlier authorized lab (Unit 07 OSINT, Units 10–12 web, or Unit 15 privesc).
- **Read the Safety & authorization reminder aloud** with a partner.
- Fill in the **report template**: all five sections + one full finding.
- **Restate scope/authorization** at the top.
- **Peer-review** against the report rubric — one glow, one grow — then revise and submit.

> Report only what actually happened. No inventing. No new commands to "get a better screenshot."

<!-- teacher note: Pick one shared prior lab so you can model and grade consistently. Prepare ONE fully-worked sample finding to model on Day 2. Reports come from notes — thin journals bite here. -->

---

<!-- _class: lead -->

# 🚩 Capstone kickoff

**Next week:** your team runs the **full attack lifecycle** on an authorized target — then reports and presents.

- **Target:** a **picoCTF** set and/or an approved **TryHackMe** room — *approved list ONLY.*
- **Deliverables:** lab journal → full report → 3–5 minute presentation.
- **Today:** confirm your team, your target, and write your **scope statement**.

<!-- teacher note: Form teams of 2-3. Hand out the checklist, target list, due dates. Restate: picoCTF / approved rooms ONLY — no real or third-party systems ever. -->

---

# Recap

- The **report is the real deliverable** — clients pay for it, not the hack.
- Five sections: **exec summary, methodology, findings, remediation, appendices.**
- Every finding: **evidence + justified severity + impact + remediation.**
- **Severity** = likelihood × impact; don't inflate. **CVSS** exists (awareness).
- Write for **two audiences** — same truth, different altitude.
- **Accuracy is an ethical duty:** no exaggerating, no hiding.
- **Capstone** kicks off next week — confirm your team, target, and scope.

---

<!-- _class: lead -->

# Exit ticket / discussion

1. Name the five report sections. Which does a non-technical CEO read first?
2. What three things must every finding include?
3. Rewrite for an executive: *"Unsanitized input in the login form permits UNION-based SQL injection."*
4. Why is **accuracy** an ethical duty — give one harm from exaggerating and one from hiding.

**Each team submits:** target name, members, and a one-sentence scope/authorization statement.

<!-- teacher note: Sample report submitted Day 5. Quiz end of Day 5 or start of Week 18. Every team needs an approved target + scope statement before leaving. -->
