# Safety, Legal & Ethics Guide (Instructor)

> This is the most important document in the course. Read it fully before teaching anything else, and make sure every student and guardian has signed the Acceptable Use Agreement before any hands-on work.

## The one rule that matters most

> **Authorization is the only line between a penetration tester and a criminal.**
> You may only use offensive techniques against systems you **own** or have **explicit, written permission** to test, within a defined **scope**. Everything in this course happens in isolated lab environments built to be attacked.

Reinforce this in every single unit. It is woven into each lesson plan's "Ethics & legal callout."

## Legal background for instructors (U.S.)

> *Not legal advice. Consult your district/administration and applicable law. Laws vary by country and state.*

- **Computer Fraud and Abuse Act (CFAA), 18 U.S.C. § 1030.** The primary U.S. federal anti-hacking law. Prohibits accessing a computer "without authorization" or "exceeding authorized access." Penalties range from misdemeanors to serious felonies.
- **State computer-crime laws.** Every U.S. state has its own; many mirror or exceed the CFAA.
- **Minors are not exempt.** Students can face juvenile or criminal charges, school discipline, and lasting consequences. Make this concrete and real.
- **Even "looking" can be illegal.** Unauthorized scanning, accessing accounts that aren't yours, or "just testing" a friend's/school's systems can violate the law and the school AUP.
- **Tools are dual-use.** The same tools used by professionals are used by criminals; possession is generally legal, *unauthorized use* is not.

Other relevant frameworks to mention: ECPA (wiretapping/interception), COPPA (data on minors), FERPA (student records), and your school's own technology AUP.

## Responsible disclosure
Teach students the professional norm: if you ever discover a real vulnerability (e.g., in a school system or an app you use) **by accident**, you do **not** exploit it, share it, or post it. You report it privately to the owner (or a trusted adult/teacher) and let them handle it. Introduce the concept of bug-bounty programs and coordinated disclosure as the legitimate path.

## Required before any hands-on work

1. **Acceptable Use & Ethics Agreement** signed by student **and** guardian (template below).
2. **Lab boundaries briefing** — students understand exactly which targets are in-scope (only the provided lab) and that the school network, classmates' devices, and the internet are **out of scope, always**.
3. **Account setup** on approved platforms only (TryHackMe, HTB Academy, picoCTF, OverTheWire) using school-appropriate accounts.

## Classroom safety & technical guardrails

- **Isolate the lab.** Local VMs run on a **host-only / internal network** in VirtualBox — never bridged to the school network or internet while attacking. See the [Lab Setup Guide](lab-setup-guide.md).
- **No attacking real targets — ever.** Including the school, the teacher, vendors, classmates, or "that one website." Browser CTF platforms (picoCTF) are pre-authorized, sandboxed targets.
- **No malware on school machines.** Treat samples and payloads only inside isolated VMs; never on the host or school network.
- **Credentials & privacy.** Students never use real personal data, real passwords, or classmates' accounts in exercises.
- **Acceptable handling of findings.** Findings stay in the classroom/lab journal. No public posting of exploits against real systems.
- **Report-don't-exploit culture.** Praise students who report issues responsibly rather than chasing "gotchas."

## Mandatory-reporting & escalation
If a student demonstrates intent or evidence of unauthorized hacking (of the school, peers, or outside systems), or accesses illegal content, follow your school's incident and counseling procedures immediately. Build a relationship with your IT/security staff before the course starts so they expect lab traffic and know who to call.

## A note on the "hacker mindset" vs. harm
Curiosity and a desire to break things are assets in this field — when channeled ethically. Frame the goal as **building** (better defenses, safer software, a security career), not **breaking** for its own sake. Highlight role models: ethical hackers, bug-bounty hunters, security researchers, and the certifications/careers that reward this mindset legally.

---

## Acceptable Use & Ethics Agreement (template)

> Customize with your school's name and policies, route through administration/legal, and collect signatures before Unit 2.

**Course:** Introduction to Offensive Security (Ethical Hacking)

I understand that in this course I will learn cybersecurity techniques that could be harmful or illegal if misused. By signing, I agree that:

1. I will use these skills **only** inside the approved lab environments and platforms provided by my teacher.
2. I will **never** use these techniques against any system, network, account, website, or device that I do not personally own or have **explicit written permission** to test — including the school's systems, my classmates' devices, and any website or service on the internet.
3. I understand that unauthorized access to computers is **illegal** under the Computer Fraud and Abuse Act and state law, and can result in **criminal charges, school discipline, and serious lifelong consequences**, even for minors.
4. If I accidentally discover a real security problem, I will **not exploit or share it**; I will report it privately to my teacher.
5. I will not install or run hacking tools or malware on school computers outside the approved lab setup.
6. I will keep findings, exploits, and credentials from class confidential and in-class.
7. I understand that violating this agreement may result in removal from the course and disciplinary or legal action.

Student name: __________________________  Signature: __________________ Date: ________

Parent/Guardian name: ___________________ Signature: __________________ Date: ________

Teacher: ______________________________  Signature: __________________ Date: ________
