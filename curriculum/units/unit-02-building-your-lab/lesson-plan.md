# Unit 02 — Building Your Safe Hacking Lab

- **Module:** Module 0 — Foundations
- **Suggested week:** Week 2
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Course setup; setting up the lab environment / connecting to the lab

> ⚠️ **Gate:** No student begins the hands-on work in this unit until their **Acceptable Use & Ethics Agreement (AUP)** is signed by student **and** guardian and on file. (Template in `instructor/safety-legal-ethics.md`; it should have gone home in Unit 01.)

## Learning objectives
By the end of this unit, students can:
- **Explain** what a virtual machine (VM) is and why security professionals use VMs and snapshots.
- **Describe** what Kali Linux is and why pentesters use it.
- **Compare** the three lab tiers (browser platforms, local VirtualBox VMs, picoCTF/OverTheWire) and say which they are using and why.
- **Define** network isolation and **explain** the difference between host-only/internal networking and bridged/NAT — and why attack labs must never be bridged.
- **Set up** their environment: (Tier A) a TryHackMe account + launch the AttackBox and complete an intro room, and/or (Tier B) install VirtualBox, import Kali, and configure host-only networking.
- **Verify** isolation by confirming they can reach the lab target but **cannot** reach the internet (e.g., `ping 8.8.8.8` fails) during an attack lab.
- **Take and restore** a VM snapshot (Tier B) or reset a lab environment (Tier A).
- **Document** their setup in the lab journal with screenshot proof.

## Standards alignment
- **NICE Framework:** Tasks related to configuring and securing a controlled test environment; awareness of system administration and network fundamentals. Work-role awareness: Penetration Tester, System Administrator.
- **CSTA / state CS standards:** 3A-NI-04 (model the role of protocols in transmitting data); 3A-CS-01 (explain how hardware/software work together as a system); 3B-NI-04 (compare security measures); 2-NI-05 (explain physical/digital security measures).
- **Security+ domain(s):** 4.0 Security Operations (secure baselines, virtualization, isolation/segmentation — awareness); 3.0 Security Architecture (network isolation concepts).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Virtual machine (VM) | A whole computer that runs as software inside your real computer; you can break it safely and reset it. |
| Hypervisor | The software that runs VMs (here, VirtualBox). |
| Host | Your real, physical computer. |
| Guest | A VM running on the host (e.g., Kali). |
| Kali Linux | A free Linux distribution loaded with security/pentesting tools; the standard "attack workstation." |
| Linux distribution (distro) | A version of the Linux operating system, bundled with particular software. |
| Snapshot | A saved point-in-time copy of a VM you can instantly restore to a clean state. |
| Network isolation | Keeping the lab on its own network so attacks can't reach the school LAN or the internet. |
| Host-only adapter | A VM network where VMs talk to each other and the host, but **not** the outside network. |
| Internal network | A VM network where VMs talk **only** to each other (not even the host) — most isolated. |
| Bridged adapter | Puts a VM directly on the real network — **never** use for attack labs. |
| NAT | Gives a VM internet access through the host — **not** for attack labs (use only to update tools, then switch back). |
| IP address | The numeric address a device uses on a network (e.g., `192.168.56.101`). |
| `ping` | A command that checks whether you can reach another address on the network. |
| AttackBox | TryHackMe's in-browser Kali-like machine you control from a web page — no install needed. |
| Room (TryHackMe) | A guided, hands-on lesson on TryHackMe with tasks and questions. |
| TryHackMe / Hack The Box | Browser-based platforms with safe, intentionally-vulnerable, pre-authorized practice targets. |
| picoCTF / OverTheWire | Free, legal, sandboxed practice platforms (CTF challenges; SSH command-line wargames). |
| Sandbox | An isolated, safe environment meant to be experimented in. |

## Materials & prep
- The **Lab Setup Guide** for instructors: `instructor/lab-setup-guide.md` (read it fully — this unit operationalizes it).
- **Decide your tier(s)** before Day 1 (Tier A browser only, Tier B local VMs, or both). The lessons below support both; skip the parts you aren't using.
- **Tier A:** A class/teacher TryHackMe account plan; the platform domains/VPN/attack-box endpoints **allowlisted** by IT; the intro room chosen (e.g., *Intro to Cyber Security* or another free starter room).
- **Tier B:** Lab machines with **≥ 8 GB RAM**, ~60 GB free disk, **VT-x/AMD-V enabled in BIOS**; VirtualBox installed (or install rights); the official **Kali VirtualBox image** downloaded and staged locally; a target VM (e.g., Metasploitable 2) staged; host-only adapter created.
- Lab journal (continued from Unit 01).
- Projector to demo VirtualBox network settings / TryHackMe AttackBox live.
- **Instructor prep notes:**
  - Complete the **Pre-course IT checklist** in `instructor/lab-setup-guide.md` (meet IT, allowlist domains, confirm install permissions, enable VT-x).
  - Build and **snapshot** a clean Kali (+ target) so students can reset; stage downloads locally to save bandwidth.
  - Test the full student workflow end-to-end on one machine before Day 1.
  - **Verify the AUP gate:** confirm which students may begin hands-on work.

## ⚖️ Ethics & legal callout
**The point this week:** *Isolation is how we keep "authorized" honest.* We attack only pre-approved, intentionally-vulnerable targets, and we physically prevent our attacks from reaching anything else by isolating the lab network (host-only/internal, never bridged). Even with the right intentions, an un-isolated attack lab can leak onto the school network or internet — which would be unauthorized access. Verifying isolation is an ethical step, not just a technical one.

**Discussion prompt:** "Why is it not enough to *promise* you won't attack the wrong thing? How does network isolation back up your promise — and what could go wrong if your VM were set to 'bridged'?"

## Lesson sequence

### Day 1 — Virtual machines, Kali, and the AUP gate
- **Warm-up (5–10 min):** "What would you do if you wanted to safely test something dangerous without risking the real thing?" (Crash-test dummies, flight simulators.) Connect to VMs.
- **Direct instruction (15–20 min):** What a VM is (host vs. guest, hypervisor); why pros use VMs (safe to break, easy to reset, isolated). What Kali Linux is and why pentesters use it (free, loaded with tools, the standard attack workstation). Snapshots as an "undo button."
- **Guided practice (15 min):** Instructor demos creating/restoring a snapshot on a sample VM (or shows screenshots if Tier A only). Class confirms AUP status — **only signed students proceed to hands-on**; others complete a reading/worksheet alternative until signed.
- **Independent practice / lab:** Journal entry — define VM, host, guest, hypervisor, snapshot in their own words.
- **Closure / exit ticket (5 min):** "Name two reasons a security pro uses a VM instead of their real computer."

### Day 2 — The three lab tiers and why we isolate
- **Warm-up (5–10 min):** Quick draw: students sketch "my computer" and "a VM inside it" to check the host/guest concept.
- **Direct instruction (15–20 min):** The three tiers from the Lab Setup Guide — (A) TryHackMe/HTB browser, (B) local VirtualBox VMs, (C) picoCTF/OverTheWire — strengths and when to use each. Then the critical idea: **network isolation.** Host-only vs. internal vs. bridged vs. NAT, with the rule: **never bridged/NAT during attacks.** Why: an un-isolated attack can reach the school LAN or internet = unauthorized access.
- **Guided practice (15 min):** "Sort the adapter" activity — give scenarios; students label whether host-only, internal, or NAT is appropriate, and flag any that are dangerous.
- **Independent practice:** Journal: which tier(s) is our class using, and one sentence on why isolation matters.
- **Closure / exit ticket (5 min):** "Which two network modes must you NOT use during an attack lab, and why?"

### Day 3 — Set up your environment (Tier A and/or Tier B)
- **Warm-up (5–10 min):** Restate the safety reminder aloud as a class; everyone confirms their AUP is signed.
- **Direct instruction (10 min):** Walk through today's setup goal for your tier(s). For Tier A: create the account, launch the AttackBox. For Tier B: import the Kali appliance and open its network settings.
- **Guided practice / lab:** Begin **Lab Part A (Tier A)** and/or **Lab Part B (Tier B)** from `lab.md`:
  - Tier A: create the TryHackMe account, launch the AttackBox, confirm it loads.
  - Tier B: import Kali into VirtualBox, set its adapter to **Host-Only**, boot it, log in, find its IP.
- **Independent practice:** Continue setup; troubleshoot with the teacher.
- **Closure / exit ticket (5 min):** "What IP did your Kali (or AttackBox) get, and what network mode is it on?"

### Day 4 — Verify isolation (the most important step)
- **Warm-up (5–10 min):** "How would you *prove* your lab can't reach the internet?" Predict before testing.
- **Direct instruction (10 min):** Teach the isolation verification: from your attack machine, you should be able to reach the **target** but **not** an outside address. Introduce `ping` and what success/failure looks like.
- **Guided practice / lab:** Complete the **isolation verification** in `lab.md`:
  - Tier B: from Kali, `ping` the target's host-only IP → **succeeds**; `ping 8.8.8.8` → **fails/times out**. Capture both screenshots.
  - Tier A: confirm you are using the provided AttackBox/sandbox (pre-isolated), complete the assigned intro room's first tasks, and screenshot the room/AttackBox.
- **Independent practice:** Take/confirm a **snapshot** (Tier B) of the clean, isolated setup.
- **Closure / exit ticket (5 min):** "Paste/describe the result of `ping 8.8.8.8`. Why is failure the *correct* result here?"

### Day 5 — Complete the intro room, document, and wrap-up
- **Warm-up (5–10 min):** Share one thing that went wrong during setup and how it got fixed (normalize troubleshooting / "Try Harder").
- **Direct instruction (10 min):** How to write a clean setup journal entry and what counts as good screenshot proof (IP, network mode, ping results, room completion).
- **Guided practice / lab:** Finish the assigned **intro room** (Tier A) and/or finalize the **Tier B verification**; assemble the deliverable.
- **Independent practice / assessment:** Complete the **journal setup entry + screenshot proof** deliverable; take the Unit 02 quiz (see `assessment.md`).
- **Closure / exit ticket (5 min):** "If your VM ever gets messed up or 'owned,' what's the fastest way back to a clean state?"

## Differentiation
- **Support:** Provide a printed click-by-click checklist with labeled screenshots for each step; pair students; offer the **Tier A browser path** to students with weak/locked-down hardware (no install needed). Pre-stage all downloads. Provide a "stuck?" flowchart for common errors (VT-x disabled, wrong adapter, AttackBox won't load).
- **Extension:** Have advanced students add a **second isolated network mode** (try internal network and compare to host-only), set up an additional target (e.g., DVWA), explore an OverTheWire (Bandit) level over SSH, or write a short "how I verified isolation" mini-guide for classmates.

## Homework / independent work
- If not finished in class: complete the assigned intro room (Tier A) or finalize and snapshot the isolated VM setup (Tier B).
- Journal: write the full setup entry (tier, IP, network mode, isolation test results) and attach screenshots.
- Optional: read the Tier C section of the Lab Setup Guide and create a free picoCTF or OverTheWire account for later units.

## Assessment
- **Formative:** Daily exit tickets; "sort the adapter" activity; IP/network-mode check (Day 3); isolation-result check (Day 4).
- **Summative:** Unit 02 quiz; the **working isolated lab + screenshot proof + journal entry** deliverable — see `assessment.md`.

## Instructor notes & common pitfalls
- **AUP first.** Do not let any student touch a target or AttackBox without a signed AUP on file.
- **Isolation is the hill to die on.** The single most common dangerous mistake is leaving a VM on **bridged** or **NAT** during attacks. Make the `ping 8.8.8.8` *failure* a celebrated, required checkpoint.
- **NAT-to-update workflow:** If students must update tools, temporarily switch Kali to NAT, update, then **switch back to host-only and re-verify** before any attacking. Frame this as a deliberate, supervised step (per the Lab Setup Guide).
- **Common Tier B errors:** VT-x/AMD-V disabled in BIOS (VM won't start or is extremely slow); not enough RAM; wrong adapter selected; forgetting to snapshot the clean state. Build/snapshot a master image to redeploy quickly.
- **Common Tier A errors:** content filter blocking the platform/AttackBox endpoints (fix with IT *before* day one); AttackBox session timeouts (teach students to relaunch).
- **Change default credentials** on Kali images and document the process for students (good security hygiene from day one).
- **Reset culture:** Teach "when in doubt, restore the snapshot." It removes the fear of breaking things and speeds up labs all semester.
