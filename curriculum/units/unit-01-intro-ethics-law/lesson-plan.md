# Unit 01 — What Is Offensive Security? Ethics, Law & the Hacker Mindset

- **Module:** Module 0 — Foundations
- **Suggested week:** Week 1
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Introduction to Cybersecurity; Effective Learning Strategies

## Learning objectives
By the end of this unit, students can:
- **Define** offensive security (penetration testing) and **explain** why organizations pay people to attack their own systems ("you can't protect what you don't understand").
- **Distinguish** white-hat, gray-hat, and black-hat hackers, and **describe** the difference between red teams and blue teams.
- **Describe** the "hacker mindset" and **give** examples of curiosity channeled ethically versus harmfully.
- **Explain** in plain language what the Computer Fraud and Abuse Act (CFAA, 18 U.S.C. § 1030) prohibits, **state** that minors are not exempt, and **identify** why even scanning or "just looking" can be illegal.
- **Identify** authorization and scope as the single dividing line between a penetration tester and a criminal.
- **Explain** responsible disclosure and **describe** how bug-bounty programs work.
- **Classify** real-world scenarios as legal/illegal and ethical/unethical, and **justify** each classification.
- **Apply** effective learning strategies (note-taking, persistence, the "Try Harder" mindset) and **set up** a lab journal they will maintain all semester.

## Standards alignment
- **NICE Framework:** OG-WRL-001 (broad cybersecurity awareness); Task T0867 (apply cyber laws/regulations/ethics); aligns to Protect & Defend / Oversee & Govern (Legal Advice & Advocacy) awareness.
- **CSTA / state CS standards:** 3A-NI-05 (give examples of cybersecurity tradeoffs); 3A-IC-29 (explain laws/ethics governing computing); 2-IC-23 (responsible computing); 3B-IC-28 (legal/ethical concerns of computing).
- **Security+ domain(s):** 5.0 Governance, Risk & Compliance (laws/regulations, ethics); 2.0 awareness of threat actor types.

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Offensive security | The practice of attacking systems *on purpose, with permission* to find weaknesses before criminals do. |
| Penetration test (pentest) | An authorized, simulated attack on a system to find and report security weaknesses. |
| Penetration tester | A security professional who is hired and given written permission to attack systems and report what they find. |
| White-hat hacker | An ethical hacker who works with permission and reports problems so they can be fixed. |
| Black-hat hacker | A criminal who attacks systems without permission for harm, theft, or personal gain. |
| Gray-hat hacker | Someone who acts without permission but claims good intentions — still illegal, and risky. |
| Red team | The "attackers" in a security exercise; they simulate real adversaries. |
| Blue team | The "defenders"; they detect, respond to, and stop attacks. |
| Hacker mindset | Deep curiosity about how things work and a drive to find clever, unexpected uses — an asset when channeled ethically. |
| Authorization | Explicit, written permission from the owner to test a specific system. |
| Scope | The exact list of systems, addresses, and actions you are allowed to test — and nothing outside it. |
| CFAA | The Computer Fraud and Abuse Act (18 U.S.C. § 1030), the main U.S. federal anti-hacking law. |
| Vulnerability | A weakness in a system that an attacker could use to do something they shouldn't. |
| Exploit | A technique or piece of code that takes advantage of a vulnerability. |
| Responsible disclosure | Privately reporting a real vulnerability to the owner instead of exploiting or publishing it. |
| Bug bounty | A program where an organization pays ethical hackers to find and report vulnerabilities legally. |
| Scanning | Probing a system or network to learn what's running on it; can be illegal without authorization. |
| AUP | Acceptable Use Policy — the rules you agree to follow (here, the course's Acceptable Use & Ethics Agreement). |
| Lab journal | A running notebook where you record what you did, what happened, and what you learned. |

## Materials & prep
- Slides for offensive security overview, hat colors, red/blue team, CFAA basics.
- **Scenario worksheet** (see `lab.md`) — one per student or pair.
- **Signed-reflection handout** (ethics pledge + short reflection prompt) — one per student.
- Lab-journal template: a physical bound notebook **or** a digital doc/wiki page per student.
- 2–3 vetted, age-appropriate news articles on real cybersecurity cases (instructor selects current, school-appropriate examples; see Instructor notes).
- Projector / board for whole-class discussion.
- **Instructor prep notes:**
  - Read `instructor/safety-legal-ethics.md` fully before teaching this unit.
  - This unit is **discussion and case-study only — no hacking, no tools.** That comes later, after the AUP is signed.
  - Pre-read every news article you assign; avoid sensational or instructional "how-to-attack" content. Focus on consequences and ethics.
  - Send the Acceptable Use & Ethics Agreement home **this week** so signatures are collected before Unit 02. (Template lives in `instructor/safety-legal-ethics.md`.)

## ⚖️ Ethics & legal callout
**The one rule:** *Authorization is the only line between a penetration tester and a criminal.* Everything offensive in this course happens only in isolated, pre-approved lab environments. Unauthorized access — even scanning or "just looking" — is illegal under the CFAA and state law, and **minors are not exempt.**

**Discussion prompt:** "A student finds that the school grading portal lets you see other students' grades by changing a number in the web address. What is the *right* thing to do, and what could go wrong if they 'just look around to be sure'?" Use this to introduce responsible disclosure.

## Lesson sequence

### Day 1 — What is offensive security, and why does it exist?
- **Warm-up (5–10 min):** Bell question on the board: "Why would a company *pay* someone to break into its own systems?" Students write a one-sentence guess; share a few.
- **Direct instruction (15–20 min):** Define offensive security and penetration testing. Core idea: *you can't protect what you don't understand.* Defenders need to know how attackers think. Introduce offense-feeds-defense.
- **Guided practice (15 min):** Class brainstorm — list things people protect in real life (a house, a bank, a phone) and how a "good-guy tester" would help find weaknesses (lock-picking demos for locksmiths, crash-testing cars). Map each analogy to a computer-security equivalent.
- **Independent practice:** Students start their lab journal — first entry: "What I think hacking is right now" (a baseline they'll revisit at the end of the course).
- **Closure / exit ticket (5 min):** One sentence: "Offensive security exists because ______."

### Day 2 — Hats, teams, and the hacker mindset
- **Warm-up (5–10 min):** Quick sort: show 4 short, anonymized actor descriptions; students label each white/gray/black hat on a half-sheet.
- **Direct instruction (15–20 min):** White vs. gray vs. black hat (emphasize that gray hat is **still illegal**, not a safe middle ground). Red team vs. blue team and how they work together (purple team). The hacker mindset: curiosity, persistence, thinking about how systems can be *misused* — and why that's a defensive superpower when it's authorized.
- **Guided practice (15 min):** "Same skill, different choice" T-chart: take one skill (e.g., finding a hidden web page) and list an ethical use vs. an illegal use. Students fill in 2–3 rows.
- **Independent practice:** Journal entry: "Describe a time your curiosity helped you figure something out. How could that same curiosity be channeled in security?"
- **Closure / exit ticket (5 min):** "Why is 'gray hat' still risky and usually illegal?"

### Day 3 — The law: CFAA, scope, and authorization
- **Warm-up (5–10 min):** True/False rapid round on slides (e.g., "Scanning a website you don't own is always fine if you don't change anything" → False).
- **Direct instruction (15–20 min):** Plain-language tour of the CFAA (18 U.S.C. § 1030): "without authorization" and "exceeding authorized access." State computer-crime laws. **Minors are not exempt** — juvenile/criminal charges, school discipline, lasting consequences. Even scanning or "looking" can break the law and the school AUP. Tools are *dual-use*: legal to own, illegal to use without permission. Then the key concept: **authorization + scope** is what makes the exact same action legal.
- **Guided practice (15 min):** Read a one-page (instructor-simplified) authorization/scope example. Students underline (a) what is in scope, (b) what is out of scope, (c) what would happen if the tester went outside scope.
- **Independent practice:** Begin the **Scenario Worksheet** from `lab.md` (Part 1: legal vs. illegal classification).
- **Closure / exit ticket (5 min):** "In your own words: what is the difference between a pentester and a criminal?"

### Day 4 — Responsible disclosure, bug bounties & cases in the news
- **Warm-up (5–10 min):** Revisit the grading-portal prompt from the Ethics callout; students predict the right move.
- **Direct instruction (15–20 min):** Responsible disclosure: discover by accident → don't exploit, don't share, report privately to the owner or a trusted adult. Introduce bug-bounty programs (companies pay for reports legally) and coordinated disclosure as the *legitimate* path. Walk through 1–2 vetted real cases, focusing on what made an action legal/illegal and what the consequences were.
- **Guided practice (15 min):** **Responsible-disclosure role-play** (see `lab.md`): in pairs, one student plays the discoverer, one the system owner; practice a respectful, professional report. Swap roles.
- **Independent practice:** Finish the **Scenario Worksheet** (Part 2: ethical vs. unethical + "Would you report it?").
- **Closure / exit ticket (5 min):** "Name one thing a responsible hacker does *not* do after finding a bug."

### Day 5 — Learning to learn + the ethics pledge
- **Warm-up (5–10 min):** "What makes a hard problem feel impossible — and what helps you push through?" Quick share.
- **Direct instruction (15–20 min):** Effective learning strategies for this course: good note-taking and the lab journal, breaking problems into steps, documenting what you tried, asking for help the right way, and the OffSec-style **"Try Harder"** mindset (persistence and productive struggle — *not* recklessness or rule-breaking). Connect persistence back to ethics: frustration is never an excuse to attack something out of scope.
- **Guided practice (15 min):** Model a strong lab-journal entry vs. a weak one; class critiques and improves the weak one together. Confirm everyone's journal is set up and formatted.
- **Independent practice / assessment:** Students complete and **sign the ethics reflection** (deliverable) and submit the completed Scenario Worksheet. Take the Unit 01 quiz (see `assessment.md`).
- **Closure / exit ticket (5 min):** Write the course motto in their own words and one personal goal for the semester.

## Differentiation
- **Support:** Provide a vocabulary half-sheet with the key terms pre-listed; offer sentence starters for the scenario worksheet ("This is illegal because…", "A responsible hacker would…"). Allow worksheet completion in pairs. Provide the news-case summaries in simplified form. Permit verbal responses for exit tickets.
- **Extension:** Have advanced students research a real bug-bounty platform (e.g., how HackerOne/Bugcrowd-style programs publish scope) and report back on what "in scope" means there. Ask them to write a short "case brief" on a famous cybersecurity case, focusing strictly on the legal/ethical analysis (no attack details). Challenge them to draft a model responsible-disclosure email.

## Homework / independent work
- Take the Acceptable Use & Ethics Agreement home for student **and guardian** signatures (due before Unit 02 — required gate for any hands-on work).
- Read one assigned vetted news case and write a 3–5 sentence journal response: was it legal? ethical? what should have happened instead?
- Finish any incomplete sections of the Scenario Worksheet.

## Assessment
- **Formative:** Daily exit tickets; hat-sorting half-sheet (Day 2); in-class scenario discussion participation; journal-setup check.
- **Summative:** Unit 01 quiz, completed Scenario Worksheet, and the signed ethics reflection — see `assessment.md`.

## Instructor notes & common pitfalls
- **No tools, no hacking this week.** If students push to "try something," that's a teachable moment: nothing happens until the AUP is signed and we're inside an isolated lab.
- Choose news cases carefully: avoid anything that reads as a tutorial, glorifies attackers, or is too graphic. Keep the focus on decisions and consequences. Refresh examples each year so they stay current.
- Watch for the "gray-hat is fine" misconception — name it explicitly and correct it. "Good intentions" do not create authorization.
- Some students will know more than they let on. Reframe their energy toward the legal, rewarded paths (bug bounties, CTFs, this course's labs) early.
- Make the consequences for minors concrete but not fear-mongering: the goal is informed, ethical decision-making, not anxiety.
- Build a relationship with your school IT/security staff now; tell them the course is starting so they expect lab activity in later units.
- Collect signed AUPs and confirm the list of who can begin hands-on work before Unit 02.
