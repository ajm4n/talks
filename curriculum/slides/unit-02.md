---
marp: true
theme: bootstrap
paginate: true
header: "Introduction to Offensive Security · Unit 02"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Building Your Safe Hacking Lab
## Unit 02 — Foundations

This week we build a place where it's safe to break things. The whole point: **our lab cannot reach anything it shouldn't.**

<!-- Week 2, ~5 class periods. GATE: no student does hands-on work until their AUP is signed by student AND guardian and on file. Decide your tier(s) before Day 1. Test the full student workflow end-to-end before teaching. -->

---

<!-- _class: lead -->

# ⚖️ Gate: AUP first

# No hands-on work until your Acceptable Use & Ethics Agreement is signed — by you **and** your guardian — and on file.

Not signed yet? You'll do the reading alternative until it is.

<!-- Verify the gate on Day 1. Confirm exactly which students may begin. This is non-negotiable. -->

---

# Learning objectives

By the end of this unit you can:

- **Explain** what a VM is and why pros use VMs and snapshots.
- **Describe** what Kali Linux is and why pentesters use it.
- **Compare** the three lab tiers and say which you're using and why.
- **Define** network isolation; explain host-only/internal vs. bridged/NAT.

---

# Learning objectives (cont.)

- **Set up** your environment: Tier A AttackBox and/or Tier B VirtualBox + Kali.
- **Verify** isolation — reach the target but **not** the internet.
- **Take and restore** a snapshot (Tier B) or reset the environment (Tier A).
- **Document** your setup in the lab journal with screenshot proof.

<!-- Roadmap for the week. Day 4 — verifying isolation — is the most important lesson. -->

---

# ⚖️ The point this week

# Isolation is how we keep "authorized" honest.

- We attack only pre-approved, intentionally-vulnerable targets.
- We **physically prevent** attacks from reaching anything else.
- Verifying isolation is an **ethical** step, not just a technical one.

<!-- A promise not to attack the wrong thing isn't enough. Isolation backs up the promise. -->

---

<!-- _class: lead -->

# Day 1 — Virtual machines, Kali & the AUP gate

---

# Warm-up

> *"How would you safely test something dangerous without risking the real thing?"*

Think: crash-test dummies. Flight simulators. A practice space you can wreck and reset.

<!-- Connect their answers to VMs. -->

---

# What is a virtual machine?

A **VM** is a whole computer that runs as **software** inside your real computer.

| Term | Meaning |
|------|---------|
| **Host** | Your real, physical computer |
| **Guest** | A VM running on the host (e.g., Kali) |
| **Hypervisor** | The software that runs VMs (we use VirtualBox) |

> You can break a guest badly — and reset it in seconds.

---

# Why pros use VMs

- **Safe to break:** mistakes stay inside the VM.
- **Easy to reset:** restore to a clean state instantly.
- **Isolated:** the VM's network can be sealed off from everything else.

> Never do attack practice on your real OS. Use a guest.

---

# What is Kali Linux?

- A free **Linux distribution** (a version of Linux bundled with specific software).
- Loaded with security / pentesting **tools** out of the box.
- The standard **attack workstation** for pentesters.

> Kali is the toolbox. The VM is the safe workshop we put it in.

---

# Snapshots = an undo button

A **snapshot** is a saved, point-in-time copy of a VM you can instantly restore.

- Take one when the VM is clean and working.
- If the VM gets messed up or "owned" → **restore the snapshot.**
- Removes the fear of breaking things.

<!-- "When in doubt, restore the snapshot." Build this reset culture now. -->

---

# Day 1 exit ticket

> *"Name two reasons a security pro uses a VM instead of their real computer."*

Journal: define **VM, host, guest, hypervisor, snapshot** in your own words.

---

<!-- _class: lead -->

# Day 2 — The three lab tiers & why we isolate

---

# The three lab tiers

| Tier | What it is | Best when |
|------|-----------|-----------|
| **A — Browser** | TryHackMe / HTB AttackBox in your browser | Weak or locked-down machines; no install |
| **B — Local VMs** | VirtualBox + Kali + a target VM | You want full control |
| **C — Wargames** | picoCTF / OverTheWire (CTF, SSH) | Extra practice, later units |

Know which tier(s) your class uses — and why.

---

# Network isolation: the big idea

**Network isolation** = keeping the lab on its own network so attacks can't reach the school LAN or the internet.

An un-isolated attack can **leak** onto the real network = **unauthorized access** = illegal.

> Isolation is the technical proof behind your ethical promise.

---

# The four network modes

| Mode | VM can reach… | Use for attacks? |
|------|---------------|------------------|
| **Host-Only** | Host + other lab VMs, **not** the internet | ✅ Yes |
| **Internal** | **Only** other lab VMs (most isolated) | ✅ Yes |
| **NAT** | The internet (through the host) | ❌ No |
| **Bridged** | Straight onto the real network | ❌ **Never** |

---

# Never bridged. Never NAT (during attacks).

- **Bridged** puts your VM directly on the real network — an attack could hit the school LAN.
- **NAT** gives the VM internet access — an attack could reach the open internet.
- Either one = **unauthorized access** waiting to happen.

> The one allowed exception: temporarily switch to NAT to **update tools**, then switch back to host-only and **re-verify**.

<!-- Frame the NAT-to-update workflow as deliberate and supervised. Re-verify isolation afterward. -->

---

# Sort the adapter (guided practice)

For each scenario, pick host-only, internal, or NAT — and flag any that are dangerous:

- Attacking a target VM on the same network → **Host-Only / Internal**
- Two lab VMs that should never see the host → **Internal**
- Updating Kali's tools, supervised, then switching back → **NAT (temporary)**
- "I'll just bridge it, it's faster" → 🚩 **Dangerous — never**

---

# Day 2 exit ticket

> *"Which two network modes must you NOT use during an attack lab, and why?"*

Journal: which tier(s) is our class using, and one sentence on why isolation matters.

---

<!-- _class: lead -->

# Day 3 — Set up your environment

---

# 🔒 Say the reminder, confirm the gate

> You may only run offensive techniques inside the approved, isolated lab — and only after your AUP is **signed by you and your guardian** and on file. Unauthorized access (even scanning) is illegal under the CFAA. **Minors are not exempt.**

Everyone confirms: **is your AUP signed?** If not, do the reading alternative.

---

# Tier A — Create your account

1. Go to the TryHackMe URL your teacher gives you (must be allowlisted by IT).
2. Create an account with school-appropriate details.
3. **Do not** reuse a personal password.

📸 Screenshot: your logged-in dashboard (no password visible).

---

# Tier A — Launch the AttackBox

1. Open the assigned intro room (e.g., *Intro to Cyber Security*).
2. Click **Start AttackBox** — wait for the split-screen to load.
3. The AttackBox is a **pre-isolated, sandboxed** machine in your browser — nothing to install.

📸 Screenshot: the AttackBox loaded next to the room.

> If the session times out, just relaunch it — that's normal.

---

# Tier B — Import Kali into VirtualBox

**Step 1 — Prerequisites:** VirtualBox installed; **VT-x/AMD-V enabled in BIOS** (if Kali won't start or is painfully slow, this is usually why).

**Step 2 — Import:**

- VirtualBox → **File → Import Appliance**
- Choose the official Kali image your teacher staged → import
- Kali appears in your VM list.

<!-- VT-x/AMD-V disabled is the #1 Tier B failure. Confirm it before Day 3. -->

---

# Tier B — Set Kali to Host-Only

1. Select Kali → **Settings → Network**.
2. Set **Adapter 1** → **Host-Only Adapter** (the host-only network your teacher created).
3. ❌ Do **not** select Bridged or NAT for attack labs.
4. Click **OK**.

📸 Screenshot: Network settings showing **Host-Only Adapter**.

---

# Tier B — Boot Kali and find its IP

```bash
ip a
```

- Log in with the credentials your teacher provides (change the default password if instructed).
- Find Kali's host-only IP — often in the `192.168.56.x` range. **Write it in your journal.**

📸 Screenshot: the terminal showing Kali's IP.

Then start the **target VM** (e.g., Metasploitable 2) on the **same host-only network**.

---

# Day 3 exit ticket

> *"What IP did your Kali (or AttackBox) get, and what network mode is it on?"*

<!-- IP & network-mode check. Each student should be able to state both. -->

---

<!-- _class: lead -->

# Day 4 — Verify isolation (the most important step)

---

# Warm-up

> *"How would you **prove** your lab can't reach the internet?"*

Predict before you test.

---

# How isolation verification works

From your attack machine you should be able to reach the **target** — but **not** any outside address.

We use `ping`:

| Result | Meaning |
|--------|---------|
| Replies come back | You can reach that address |
| Times out / 100% loss | You **cannot** reach it |

> Here, failing to reach the internet is the **correct** result.

---

# Tier B — Verify (step 1: reach the target)

```bash
ping -c 4 192.168.56.102   # your target's host-only IP
```

- **Expected:** replies come back — the ping **succeeds.**
- This proves Kali can reach the lab target on the isolated network.

📸 Screenshot the successful target ping.

---

# Tier B — Verify (step 2: can't reach the internet)

```bash
ping -c 4 8.8.8.8
```

- **Expected:** the ping **fails / times out** (100% packet loss).
- **This failure is the correct, desired result** — your attacks cannot reach the internet.

📸 Screenshot the failed `8.8.8.8` ping.

> ⚠️ If `8.8.8.8` **succeeds**, STOP — your VM is NOT isolated. Check the adapter is Host-Only and tell your teacher before doing anything.

---

# Tier A — Verify

1. You're using the provided **AttackBox/sandbox** — already isolated and pre-authorized.
2. You may act **only** on the in-scope target the room provides — nothing else.
3. Confirm you're working inside the room's target, not any outside address.

📸 Screenshot: the AttackBox + room confirming you're in the sandbox.

---

# Day 4 exit ticket

> *"Paste/describe the result of `ping 8.8.8.8`. Why is failure the **correct** result here?"*

Then take/confirm a clean **snapshot** (Tier B) of the isolated setup.

<!-- Celebrate the ping 8.8.8.8 FAILURE as a required checkpoint. -->

---

<!-- _class: lead -->

# Day 5 — Snapshot, document & wrap up

---

# Snapshot your clean lab (Tier B)

1. With Kali clean and isolated: select the VM → **Snapshots → Take**.
2. Name it `clean-isolated`.
3. This is your **undo button** — if the VM ever gets owned, restore it.

📸 Screenshot: the Snapshots view showing `clean-isolated`.

> Tier A: note in your journal how to **reset/relaunch** the AttackBox instead.

---

# Write a clean setup journal entry

A good entry includes:

- Which **tier(s)** you used.
- Your attack machine's **IP** and **network mode** (Tier B), or that you used the **AttackBox** (Tier A).
- Your **isolation results**: target ping succeeded; `8.8.8.8` failed.
- What went wrong and how you fixed it (**"Try Harder"** notes).

<!-- Normalize troubleshooting. Share one thing that broke and how it got fixed. -->

---

# Day 5 exit ticket

> *"If your VM ever gets messed up or 'owned,' what's the fastest way back to a clean state?"*

Then take the **Unit 02 quiz** and assemble your deliverable.

---

# Full vocabulary (1 of 2)

| Term | Meaning |
|------|---------|
| Virtual machine (VM) | A whole computer running as software inside your real one |
| Host / Guest | Your real machine / the VM running on it |
| Hypervisor | The software that runs VMs (VirtualBox) |
| Kali Linux | Free Linux distro loaded with pentest tools — the attack workstation |
| Distribution (distro) | A version of Linux bundled with particular software |
| Snapshot | A saved VM state you can instantly restore |
| Sandbox | An isolated, safe environment made for experimenting |

---

# Full vocabulary (2 of 2)

| Term | Meaning |
|------|---------|
| Network isolation | Keeping the lab on its own network, sealed off |
| Host-Only adapter | VM talks to host + lab VMs, **not** the internet |
| Internal network | VM talks **only** to other lab VMs |
| Bridged | VM on the real network — **never** for attacks |
| NAT | VM gets internet via host — not for attacks (updates only) |
| IP address / `ping` | Numeric network address / command to test reachability |
| AttackBox / Room | Browser Kali machine / a guided THM lesson |

---

# 🔒 Lab safety & authorization reminder

> You may only run offensive techniques inside the approved, isolated lab — and only after your AUP is **signed by you and your guardian** and on file. Never use these techniques against any system you don't own or have **written permission** to test — the school, classmates, or any website. **Minors are not exempt.** This unit's whole point: make sure your lab **cannot reach anything it shouldn't.**

---

# Lab walk-through summary

- **Part A (Tier A):** account → launch AttackBox → work an intro room.
- **Part B (Tier B):** import Kali → set **Host-Only** → boot → `ip a` → start target.
- **Part C (everyone):** **verify isolation** — target ping ✅, `8.8.8.8` ✅ fails.
- **Part D (everyone):** snapshot `clean-isolated` + write the journal entry.

---

# Lab deliverables

**Tier A:** logged-in dashboard, loaded AttackBox, intro room with completed tasks.

**Tier B:** Host-Only network settings, Kali's IP (`ip a`), successful target ping, **failed** `ping 8.8.8.8`, and the `clean-isolated` snapshot.

**Everyone:** a lab-journal entry with the safety reminder at the top.

---

# Recap

- **VMs** are safe, resettable, isolatable computers-in-software; **Kali** is the attack workstation.
- **Snapshots** are your undo button.
- Three tiers: **A browser, B local VMs, C wargames.**
- **Isolation** keeps "authorized" honest. **Host-Only/Internal** for attacks; **never Bridged/NAT.**
- **Verify** it: target ping succeeds, `ping 8.8.8.8` **fails** — and that failure is the win.

---

<!-- _class: lead -->

# Exit ticket & discussion

1. Why is verifying isolation an **ethical** step, not just a technical one?
2. A classmate's Kali is set to **Bridged** and about to start an attack lab — what do you tell them, and what should they do instead?
3. Your VM gets "owned" mid-lab. Fastest way back to known-good?

*Submit: screenshot proof of a working, isolated lab + your lab-journal entry.*
