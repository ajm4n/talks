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

We promised to attack only what we're allowed to. This week we build a lab that *physically can't* reach anything else — and we prove it.

<!-- Week 2, ~5 class periods. GATE: no student touches a target or AttackBox without a signed AUP on file (student AND guardian). Decide your tier(s) before Day 1. -->

---

# Learning objectives

By the end of this unit you can:

- **Explain** what a virtual machine (VM) is and why pros use VMs and snapshots.
- **Describe** what Kali Linux is and why pentesters use it.
- **Compare** the three lab tiers and say which you're using and why.
- **Define** network isolation; explain host-only vs. internal vs. bridged vs. NAT.
- **Set up** your environment (TryHackMe AttackBox and/or local Kali VM).
- **Verify** isolation: reach the target but **not** the internet.
- **Take and restore** a snapshot (or reset an environment).
- **Document** your setup with screenshot proof.

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

## Isolation is how we keep "authorized" honest.

A signed promise isn't enough. We **physically prevent** our attacks from leaving the lab by isolating the network — **host-only/internal, never bridged or NAT.** An un-isolated lab can leak onto the school LAN or internet = unauthorized access. **Verifying isolation is an ethical step, not just a technical one.**

<!-- Discussion: "Why isn't promising enough? How does isolation back up your promise, and what goes wrong if a VM is set to bridged?" -->

---

# What is a virtual machine?

- A **VM** is a whole computer that runs **as software** inside your real computer.
- **Host** = your real machine. **Guest** = the VM running on it.
- **Hypervisor** = the software that runs VMs (we use **VirtualBox**).
- Why pros love them: **safe to break, easy to reset, isolated** from real systems.

<!-- Warm-up analogy: crash-test dummies, flight simulators — safely test something dangerous without risking the real thing. -->

---

# Kali Linux & snapshots

- **Kali Linux** = a free Linux distro loaded with security tools — the standard "attack workstation."
- A **distro** is just a flavor of Linux bundled with particular software.
- A **snapshot** is a saved, point-in-time copy of a VM.
  - It's your **undo button**: restore to a clean state in seconds.
  - **When in doubt, restore the snapshot.**

<!-- Reset culture removes the fear of breaking things and speeds up every lab this semester. -->

---

# The three lab tiers

| Tier | What it is | When to use |
|------|-----------|-------------|
| **A** | TryHackMe / HTB **browser AttackBox** | No install; weak/locked-down hardware |
| **B** | Local **VirtualBox + Kali** + target VM | Full control; offline; deeper practice |
| **C** | **picoCTF / OverTheWire** | Free sandboxed challenges & wargames |

> Tier A targets are already pre-authorized and sandboxed. Tier B isolation is **your** job.

---

# Network isolation: the modes

| Mode | What it does | Attack labs? |
|------|--------------|--------------|
| **Host-Only** | VM talks to host + other VMs, **not** outside | ✅ Yes |
| **Internal** | VMs talk **only** to each other — most isolated | ✅ Yes |
| **Bridged** | Puts the VM **directly on the real network** | ❌ NEVER |
| **NAT** | Gives the VM internet via the host | ⚠️ Updates only, then switch back |

<!-- Isolation is the hill to die on. The #1 dangerous mistake is leaving a VM on bridged/NAT during an attack. -->

---

# Setting up (Tier B path)

1. Confirm prerequisites: VirtualBox installed, **VT-x/AMD-V enabled in BIOS**.
2. **File → Import Appliance** → the official Kali image your teacher staged.
3. **Settings → Network → Adapter 1 → Host-Only Adapter.** ❌ Not Bridged/NAT.
4. Boot Kali, log in, run `ip a` to find its host-only IP (often `192.168.56.x`).
5. Start the target VM (e.g., Metasploitable 2) on the **same** host-only network.

<!-- Tier A path: create the account, launch the AttackBox in-browser — no install. Common Tier B error: VT-x disabled = won't boot or painfully slow. -->

---

# Verify isolation — the most important step

From your Kali terminal:

```bash
ping -c 4 192.168.56.102   # the TARGET → should SUCCEED
ping -c 4 8.8.8.8          # the INTERNET → should FAIL
```

- ✅ Target ping **succeeds** → you can reach the lab.
- ✅ `8.8.8.8` ping **fails / times out** → **this failure is the correct result.**

> If `ping 8.8.8.8` *succeeds*, STOP. Your VM is **not** isolated — check the adapter and tell your teacher before doing anything else.

<!-- Make the 8.8.8.8 FAILURE a celebrated, required checkpoint. Capture both screenshots. -->

---

# Snapshot & document

- Take a snapshot of the clean, isolated VM — name it **`clean-isolated`**.
- Journal your setup entry:
  - Which **tier(s)** you used.
  - Attack machine **IP** + **network mode** (or "used the AttackBox").
  - **Isolation results:** target ping ✅, `8.8.8.8` ping ❌.
  - What went wrong and how you fixed it ("Try Harder" notes).

<!-- Tier A: note how to reset/relaunch the AttackBox instead of snapshotting. -->

---

# Key vocabulary

| Term | Meaning |
|------|---------|
| **VM / Hypervisor** | A software computer / the software that runs it (VirtualBox) |
| **Host / Guest** | Your real machine / the VM running on it |
| **Kali Linux** | Free Linux distro loaded with pentest tools |
| **Snapshot** | A saved clean state you can instantly restore to |
| **Network isolation** | Keeping the lab off the school LAN and internet |
| **Host-only / Internal** | Isolated VM networks — safe for attacks |
| **Bridged / NAT** | On/through the real network — **never** during attacks |
| **AttackBox / Room** | TryHackMe's browser Kali / a guided hands-on lesson |

---

# Lab launch

**Platform:** TryHackMe browser AttackBox (Tier A) and/or VirtualBox + Kali + a target VM (Tier B).

- **Part A/B:** Set up your AttackBox or your isolated Kali VM.
- **Part C:** **Verify isolation** — reach the target, fail to reach `8.8.8.8`. *(everyone)*
- **Part D:** Snapshot + document with screenshots. *(everyone)*

→ Full step-by-step in this unit's **`lab.md`**.

<!-- AUP gate again: only signed students go hands-on. Others do the reading alternative until signed. -->

---

# Recap

- A **VM** is a safe, resettable software computer; **Kali** is our attack workstation.
- **Snapshots** = an instant undo button.
- Three tiers: browser (A), local VMs (B), CTF sandboxes (C).
- **Host-only/internal = safe. Bridged/NAT = never during attacks.**
- A failed `ping 8.8.8.8` is the **proof** your lab is isolated.

---

<!-- _class: lead -->

# Exit ticket & discussion

**Exit ticket:** Paste or describe your `ping 8.8.8.8` result. Why is **failure** the correct result here?

**Discuss:** Why isn't it enough to just *promise* you won't attack the wrong thing? How does network isolation back up your promise — and what could go wrong if your VM were set to "bridged"?

<!-- If a VM ever gets "owned," fastest way back = restore the snapshot. Next unit: networking from zero. -->
