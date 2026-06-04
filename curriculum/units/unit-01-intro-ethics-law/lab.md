# Unit 01 Lab — Ethics, Law & the Hacker Mindset (Discussion & Case-Study Lab)

- **Platform:** None — this is a discussion, classification, and role-play lab. **No tools, no hacking, no scanning.**
- **Time:** ~90–120 min spread across Days 3–5 (plus journal setup on Day 1)
- **Difficulty:** Intro

## 🔒 Safety & authorization reminder
You may only run offensive techniques inside the approved, isolated lab environments provided by your teacher, and only after your Acceptable Use & Ethics Agreement is signed. Doing any of this to a system you do not own or have **explicit written permission** to test — including the school, classmates' devices, or any website on the internet — is **illegal** under the CFAA and state law. **Minors are not exempt.** This lab involves **no hacking at all**: you will read, classify, discuss, and role-play. There is nothing to attack here, and that is the point — we build judgment before we build skills.

## Objectives
- Set up and format a lab journal you will keep all semester.
- Classify real-world scenarios as legal/illegal and ethical/unethical, and justify each choice.
- Practice a responsible-disclosure response through a structured role-play.
- Produce a signed ethics reflection.

## Setup
1. Get your **lab journal** (a bound notebook, or the digital doc your teacher shares).
2. On page 1, copy the safety reminder above by hand (digital: paste it and bold it).
3. Title the page "Unit 01 — Ethics & Law" and date it.
4. Get the **Scenario Worksheet** and the **Responsible-Disclosure Role-Play cards** from your teacher.

---

## Part 1 — Lab journal setup (Day 1)
A lab journal is where you record *what you did, what happened, and what you learned.* Professionals keep one so their work is repeatable and reportable. Yours starts now.

### Step 1 — Create your cover and format
Set up these standing sections in your journal:
- **Cover:** Your name, course name, term.
- **Page 1:** The safety/authorization reminder (copied above).
- **A running log:** For every future lab, you'll write Date / What I tried / Command or action / Result / What I learned.

### Step 2 — First entry: your baseline
Write 3–5 sentences answering: *"What do I think hacking is right now?"* You will revisit this at the end of the course to see how your understanding changed.

**Screenshot/photo to take:** A photo or screenshot of your set-up journal page 1 (with the safety reminder visible) to attach to your deliverable.

---

## Part 2 — Scenario classification worksheet (Days 3–4)
For each scenario, decide two things and **write one sentence of justification for each**:
1. **Legal or illegal?** (Is there authorization? Is the action in scope?)
2. **Ethical or unethical?** (Even if legal, was it the right thing to do?)

> Note: legal and ethical are not always the same. Something can be legal but a bad idea, or technically against a rule but well-intentioned. Say so in your justification.

### Scenarios
- **S1.** A company hires Maya and signs a contract listing exactly which servers she may test. She tests only those servers and writes a report.
- **S2.** Devon notices the school grading portal shows other students' grades if you change a number in the web address. He changes the number a few times "just to confirm it's real," then tells no one.
- **S3.** Priya finds the same grading-portal issue, does **not** change anything further, and emails her teacher and the IT office a private description of the problem.
- **S4.** Sam runs a port scan against a popular website "to practice," without permission, but doesn't log in or change anything.
- **S5.** A bug-bounty program publishes a scope page inviting researchers to test its app. Lee tests only the in-scope app and reports a bug through the program.
- **S6.** Alex installs a "gray-hat" tool and scans a neighbor's Wi-Fi router login page "to see if it's secure," planning to warn them afterward.
- **S7.** Jordan completes an intentionally-vulnerable TryHackMe room on the in-browser AttackBox provided by the class.
- **S8.** Riley finds a classmate left a laptop unlocked and logs into their email "as a joke" without reading anything.

Complete all eight. (Part A on Day 3 = S1–S4; Part B on Day 4 = S5–S8, or as your teacher directs.)

---

## Part 3 — Responsible-disclosure role-play (Day 4)
Work in pairs. Each pair gets a **scenario card** describing an accidentally-discovered vulnerability (your teacher provides these; e.g., "you noticed your favorite game's site emails are exposed").

### Step 1 — Assign roles
- **Discoverer:** the person who found the issue by accident.
- **Owner:** the company/IT contact receiving the report.
(If you have a third person, they are the **Observer** who gives feedback.)

### Step 2 — Run the report (5–7 min)
The Discoverer reports the issue following the responsible-disclosure rules:
- Do **not** exploit it further.
- Do **not** share it publicly or with friends.
- Report it **privately** to the owner (or a trusted adult), describe it clearly and respectfully, and let them fix it.

### Step 3 — Swap roles
Switch roles (and scenarios if provided) and run it again.

### Step 4 — Journal it
Each student writes a short journal entry: *What did a good disclosure sound like? What did the Discoverer avoid doing, and why?*

---

## Deliverables
- **Completed Scenario Worksheet** (all 8 scenarios, both classifications + a justification sentence for each).
- **Signed ethics reflection** (the pledge + a short written reflection — see prompt in `assessment.md`).
- **Lab journal**, set up with the safety reminder on page 1, the baseline entry, and a role-play reflection entry. Attach a photo/screenshot of page 1.

## Stretch goals (optional)
- Research how one real bug-bounty platform publishes its scope and write 3–4 sentences in your journal on what "in scope" means there.
- Draft a model responsible-disclosure email you would send if you found a real bug (no real targets — make it generic).
- Write a one-paragraph "case brief" on a teacher-approved famous cybersecurity case, focused only on the legal/ethical analysis (no attack instructions).

## Answer key (instructor only)
Classifications are below. Accept reasonable justifications; the *reasoning* matters more than a single "right" label, especially on the ethical axis.

- **S1 — Legal / Ethical.** Written authorization, stays in scope, reports findings. Model professional behavior.
- **S2 — Illegal / Unethical.** "Just confirming" is still unauthorized access (exceeding authorized access). Changing the value is exactly the line. Should have stopped and reported.
- **S3 — Legal / Ethical.** Didn't exploit further; reported privately to the right people. This is responsible disclosure done well.
- **S4 — Illegal / Unethical (with nuance).** Unauthorized scanning can violate the CFAA/state law even with no changes — "just looking" is not a defense. Use this to crush the "I didn't break anything" myth.
- **S5 — Legal / Ethical.** Published scope = authorization within that scope; reported through the program. Legitimate path.
- **S6 — Illegal / Unethical.** "Gray hat" with "good intentions" — still unauthorized access to someone else's device. Good intentions do not create authorization. Risky and illegal.
- **S7 — Legal / Ethical.** Pre-authorized, intentionally-vulnerable, isolated lab target provided by the class. This is what authorized practice looks like.
- **S8 — Illegal / Unethical.** Accessing another person's account without permission, "joke" or not. Likely violates CFAA/state law and the school AUP.

**Role-play look-fors:** Discoverer does not exploit/share; reports privately, clearly, respectfully; addresses the right owner/trusted adult; gives them time to fix. Praise "report-don't-exploit" behavior loudly.

**Journal check:** Page 1 has the safety reminder; baseline entry present; role-play reflection present.
