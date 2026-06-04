# Unit 17 Assessment — Reporting & Professional Communication + Capstone Kickoff

## Formative checks
- **Exit tickets** (Days 1–5): the five main report sections + which one a non-technical CEO reads first; the three things every finding must include; a technical sentence rewritten for an executive; one change made after peer feedback; team target + scope statement.
- **Scramble-sort:** student correctly sorts scrambled report contents (screenshot, CEO paragraph, raw nmap output, fix recommendation, risk rating) into the right report sections.
- **Severity pair activity:** student assigns Low/Med/High/Critical to three sample findings and justifies each with likelihood and impact.
- **Executive-summary rewrite:** student turns a jargon-filled technical sentence into plain language with no commands and no un-glossed acronyms.
- **Rubric-based peer review:** student scores a partner's report against the report rubric with one glow and one grow.

## Quiz

1. In professional penetration testing, what does the client ultimately **pay for**?
   - A) The hack itself  B) The written report of what's wrong, how bad, and how to fix it  C) The tools used  D) A list of passwords

2. Which report section is written in **plain language for a non-technical leader**?
   - A) Methodology  B) Appendices  C) Executive summary  D) Findings

3. Which section explains **how** the test was performed (the phases and approach)?
   - A) Executive summary  B) Methodology  C) Remediation  D) Appendices

4. Every **finding** must include which three things?
   - A) A logo, a date, and a signature
   - B) Evidence, severity, and impact
   - C) A password, a screenshot, and a CVE
   - D) A joke, a chart, and a quote

5. A tester finds an unauthenticated flaw that dumps the entire customer database with one easy request. The most appropriate severity is:
   - A) Low  B) Medium  C) Informational  D) Critical

6. A finding is a verbose error message that only leaks the software version. The most appropriate severity is:
   - A) Critical  B) High  C) Low  D) Catastrophic

7. **CVSS** is best described as:
   - A) A programming language for exploits
   - B) An industry scoring system that turns factors into a 0–10 severity score
   - C) A type of firewall
   - D) A wordlist for content discovery

8. Severity is generally a combination of:
   - A) Likelihood × impact  B) Price × time  C) Screenshots × pages  D) Tools × commands

9. Which sentence belongs in an **executive summary** (not a technical finding)?
   - A) "Unsanitized input permits UNION-based SQL injection on `/login`."
   - B) "We ran `sqlmap` against the `id` parameter."
   - C) "An attacker could currently access customer records; we recommend prioritizing a fix this quarter."
   - D) "The response returned a 500 with a stack trace."

10. You found a Critical flaw, but it was embarrassingly easy (a default password). Honest reporting requires you to:
    - A) Dress it up as something more advanced so the test looks impressive
    - B) Leave it out so the client isn't embarrassed
    - C) Report it accurately as Critical, with evidence, and recommend the fix
    - D) Only mention it verbally

11. Why does a report **restate the scope and authorization**?
    - A) To fill space  B) It is the written record proving the test was authorized and stayed in bounds  C) To hide findings  D) It is not needed

12. Good reports depend most on:
    - A) Fancy fonts  B) Good lab-journal notes taken during the test  C) The number of pages  D) Using as much jargon as possible

13. **Remediation** for a SQL-injection finding should say:
    - A) "Make the website more secure."
    - B) "Use parameterized queries / prepared statements for database calls and validate input server-side."
    - C) "Turn it off and on again."
    - D) "Hire more people."

14. **Short answer:** Explain why *accuracy* is an ethical duty in a pentest report. Give one specific harm from **exaggerating** a finding and one from **hiding** a finding.

15. **Short answer:** The same SQL-injection issue must appear in both the executive summary and the technical findings. In your own words, how should the language differ between the two, and why? Name one thing that must NOT appear in the executive summary.

## Project / performance task — Complete Sample Report
**Prompt:** Using a finding from an earlier authorized lab (Unit 07 OSINT, Units 10–12 web, or Unit 15 privesc), write a **complete sample penetration-test report** with all five sections: executive summary, methodology, findings (with evidence, justified severity, and impact), remediation/recommendations, and appendices. Restate the original scope/authorization. Report only what actually happened — no inventing, no exaggerating, no hiding.

**Deliverable:** The complete sample report (the dress rehearsal for the Unit 18 capstone report), plus the peer-review rubric you scored for a partner.

**Rubric:** (the standard penetration-test report rubric from `instructor/grading-and-rubrics.md`)
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| **Executive summary** | Clear, non-technical, accurate risk framing | Mostly clear | Too technical/vague | Missing |
| **Methodology** | Phases clearly described and justified | Phases described | Partial | Missing |
| **Findings** | Each finding has evidence, severity, and impact | Most findings complete | Findings incomplete | Findings missing |
| **Remediation** | Specific, actionable fixes for each finding | General fixes | Vague fixes | Missing |
| **Communication** | Polished, well-organized, correct terminology | Solid | Rough | Unclear |

## Answer key
1: B — 2: C — 3: B — 4: B — 5: D — 6: C — 7: B — 8: A — 9: C — 10: C — 11: B — 12: B — 13: B

14. Accuracy is an ethical duty because the client makes **real decisions and spends real money** based on the report, and the report is also the trust record of the engagement. **Exaggerating harm** (accept any): scares the client into wasting money on the wrong priority, "cries wolf" so real warnings get ignored, or damages your credibility. **Hiding harm** (accept any): leaves a real vulnerability unfixed so attackers can exploit it, exposes customers/data, and betrays the client's trust. Both distort the truth the client paid for.

15. The **executive summary** uses plain language focused on risk and what to do — no commands, no un-glossed acronyms — because the audience is a busy, non-technical leader deciding how worried to be and what to prioritize. The **technical finding** is precise and reproducible (exact parameter, payload, affected URL, steps) because the audience is the staff who will fix it. Same truth, different altitude. Must NOT appear in the executive summary (accept any): raw commands, payloads, code, or unexplained acronyms/jargon.
