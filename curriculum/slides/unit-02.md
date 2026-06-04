---
marp: true
theme: default
paginate: true
header: "Introduction to Offensive Security · Unit 02"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Unit 02 — Building Your Safe Hacking Lab

A place where it's safe to break things — and impossible to break the wrong thing.

<!-- Week 2. GATE: only students with a signed AUP (student + guardian) do hands-on work. Others do the reading alternative. -->

---

# ⚠️ The AUP gate

**No hands-on work until your Acceptable Use & Ethics Agreement is signed** — by you *and* a guardian — and on file.

- It should have gone home in Unit 01.
- Not signed yet? You do the reading/worksheet alternative until it is.

> Authorization starts with *your own* signature.

---

# Learning Objectives

By the end of this unit you can:

- **Explain** what a virtual machine (VM) is and why pros use VMs and snapshots.
- **Describe** what Kali Linux is and why pentesters use it.
- **Compare** the three lab tiers and say which you're using and why.
- **Define** network isolation; explain host-only/internal vs. bridged/NAT.
- **Set up** your environment (AttackBox and/or Kali VM).
- **Verify** isolation — reach the target, but **not** the internet.
- **Take and restore** a snapshot; **document** it all with screenshots.

---

# What is a virtual machine?

- A whole computer that runs as **software inside your real computer**.
- **Host** = your real machine · **Guest** = the VM running on it.
- The **hypervisor** (VirtualBox) is the software that runs VMs.

**Why pros use VMs:** safe to break, easy to reset, and isolated from everything else.

<!-- Warm-up analogy: crash-test dummies, flight simulators — test something dangerous without risking the real thing. -->

---

# Kali Linux & snapshots

- **Kali Linux** = a free Linux **distro** loaded with security tools — the standard "attack workstation."
- A **snapshot** = a saved point-in-time copy of a VM.
- Restore a snapshot to jump back to a **clean state** instantly.

> The snapshot is your "undo button." When in doubt, restore it.

---

# The three lab tiers

| Tier | What it is | When to use |
|------|-----------|-------------|
| **A** | TryHackMe / HTB browser AttackBox | No install; weak/locked-down hardware |
| **B** | Local VirtualBox VMs (Kali + target) | Full control; hands-on networking |
| **C** | picoCTF / OverTheWire | Free, legal CTF & wargame practice |

All three give you **safe, intentionally-vulnerable, pre-authorized** targets.

---

# Network isolation

| Mode | What it does | Attack lab? |
|------|-------------|-------------|
| **Host-only** | VMs + host only; no outside network | ✅ Yes |
| **Internal** | VMs talk only to each other | ✅ Most isolated |
| **NAT** | VM gets internet via host | ⚠️ Updates only |
| **Bridged** | Puts VM on the real network | ❌ **Never** |

> Never bridged or NAT during attacks.

<!-- Day 2 "sort the adapter" activity: give scenarios, students label safe vs. dangerous. -->

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

## Isolation is how we keep "authorized" honest.

Even with good intentions, an un-isolated lab can **leak onto the school network or internet** — that's unauthorized access. **Verifying isolation is an ethical step, not just a technical one.**

<!-- Discussion: why isn't it enough to PROMISE you won't attack the wrong thing? How does isolation back up the promise? -->

---

# Verifying isolation — the key step

From your attack machine:

```bash
ping -c 4 192.168.56.102   # the target → should SUCCEED
ping -c 4 8.8.8.8          # the internet → should FAIL
```

- ✅ Target ping **succeeds** → you can reach the lab.
- ✅ `8.8.8.8` ping **fails / times out** → **this failure is the correct result.**

> If `8.8.8.8` succeeds, STOP. Your VM is **not** isolated — check the adapter and tell your teacher.

---

# Key vocabulary

| Term | Quick definition |
|------|------------------|
| Virtual machine (VM) | A computer that runs as software you can safely break |
| Hypervisor | Software that runs VMs (VirtualBox) |
| Host / Guest | Your real machine / the VM on it |
| Kali Linux | Free Linux distro full of security tools |
| Snapshot | Saved clean state you can instantly restore to |
| Network isolation | Keeping the lab off the school LAN and internet |
| Host-only / Internal | Isolated VM networks (safe for attacks) |
| Bridged / NAT | On the real network / internet via host — not for attacks |

---

# More vocabulary

| Term | Quick definition |
|------|------------------|
| IP address | The numeric address a device uses (e.g. `192.168.56.101`) |
| `ping` | Checks whether you can reach another address |
| AttackBox | TryHackMe's in-browser Kali-like machine |
| Room (TryHackMe) | A guided, hands-on lesson with tasks/questions |
| picoCTF / OverTheWire | Free, legal sandboxed practice platforms |
| Sandbox | An isolated, safe place meant to experiment in |

---

# Lab launch — Build & verify your lab

**Platform:** **TryHackMe** AttackBox (Tier A) and/or **VirtualBox + Kali Linux** (Tier B).

You will:

1. **Set up** the AttackBox (Tier A) and/or import Kali and set **Host-Only** networking (Tier B).
2. Boot Kali, find its IP with `ip a`, and start the target.
3. **Verify isolation:** target ping succeeds, `ping 8.8.8.8` fails — screenshot both.
4. **Snapshot** the clean setup (`clean-isolated`) and complete an intro room.
5. **Document** everything with screenshots in your journal.

📄 Full instructions: `unit-02-building-your-lab/lab.md`

---

# Recap

- A **VM** lets you break things safely; a **snapshot** is your undo button.
- **Kali Linux** is the standard attack workstation.
- Three tiers: **browser (A)**, **local VMs (B)**, **CTF/wargames (C)**.
- **Isolation** keeps "authorized" honest — **host-only/internal, never bridged/NAT.**
- The required checkpoint: target ping **succeeds**, `8.8.8.8` ping **fails**.

---

<!-- _class: lead -->

# Exit ticket / discussion

**Discuss:** Why is it not enough to *promise* you won't attack the wrong thing? What could go wrong if your VM were set to **bridged**?

**Write:**
- Name the **two** network modes you must NOT use during an attack lab, and why.
- If your VM ever gets "owned," what's the fastest way back to a clean state?
