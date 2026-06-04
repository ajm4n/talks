# Lab Setup Guide (Instructor)

This course supports three tiers of lab environment. **You can mix and match** — most schools use browser platforms for convenience plus a local VM setup for the deeper labs. Pick based on your hardware, IT support, and budget.

> 🔒 **Golden rule:** local attack VMs must run on an **isolated network** (host-only or internal) — never bridged to the school network or internet while running attacks. See "Isolating the network" below.

## Tier comparison

| Tier | Platform | Cost | Setup burden | Best for |
|------|----------|------|--------------|----------|
| A | **TryHackMe / HTB Academy** (browser) | Free tier + optional sub | Lowest | Most units; schools with limited IT support or weak hardware |
| B | **Local VirtualBox VMs** (Kali + targets) | Free | Medium–high | Networking, scanning, exploitation, priv-esc labs |
| C | **picoCTF / OverTheWire** (browser/SSH) | Free | Lowest | CTF practice, Linux/command-line, capstone |

You do **not** need all three. A fully-functional course can run on **Tier A + Tier C alone** (no local installs), which is ideal for Chromebook environments or locked-down school machines.

---

## Tier A — TryHackMe / HTB Academy (browser-based)

**Why:** No installs, works on Chromebooks, guided "rooms," built-in attack box.

1. Create a class/teacher account. TryHackMe offers free rooms and education discounts; HTB Academy has student/academic options.
2. Recommended free TryHackMe starting rooms: *Intro to Cyber Security*, *Linux Fundamentals 1–3*, *Network Fundamentals*, *Nmap*, *OWASP Top 10*, *Burp Suite Basics*, *Metasploit*.
3. Students use the in-browser **AttackBox** (or connect their own Kali via VPN — see Tier B). For HS, the browser AttackBox avoids VPN/firewall headaches.
4. Track progress via the room completion/badges.

> Check your school's content filter — allowlist the platform domains and their VPN/attack-box endpoints with IT *before* day one.

---

## Tier B — Local VirtualBox VMs

**Why:** Full control, free, mirrors real professional workflow, works offline.

### Hardware guidance
- Host with **≥ 8 GB RAM** (16 GB strongly preferred to run two VMs).
- ~60 GB free disk per station.
- CPU virtualization (VT-x/AMD-V) enabled in BIOS.

### Software
1. Install **Oracle VirtualBox** (free) on each lab machine. (VMware Workstation Player is an alternative.)
2. Download the **Kali Linux** VirtualBox image from the official Kali site (pre-built VM) — this is the students' attack workstation. Default creds are documented by Kali; change them.
3. Add **intentionally-vulnerable target VMs**, for example:
   - **Metasploitable 2** — classic Linux target for scanning/exploitation.
   - **DVWA** (Damn Vulnerable Web Application) — for the web units (run as a VM or container).
   - **VulnHub** beginner boxes (e.g., "Basic Pentesting") — for capstone-style practice.

### Isolating the network (critical)
Configure both Kali and the target on the **same isolated network**, with **no route to the school LAN or internet** during attack labs:

- **Host-Only Adapter:** VMs can talk to each other and the host, but not the outside network. *Recommended default.*
- **Internal Network:** VMs talk only to each other (not even the host). Most isolated.
- ❌ **Do NOT use Bridged or NAT** for attack labs (bridged exposes the school LAN; NAT gives internet access).

Verify isolation: from Kali, confirm you can reach the target's host-only IP but **cannot** ping an external address (e.g., `ping 8.8.8.8` should fail) during attack exercises.

> Tip: you may temporarily switch Kali to NAT to update tools, then switch back to host-only before any attacking. Document this for students as a deliberate, supervised step.

### Snapshots
Take a **snapshot** of each clean VM after setup so students (and you) can quickly reset a broken/"owned" machine to a known-good state.

---

## Tier C — picoCTF / OverTheWire

**Why:** Free, legal, pre-authorized targets; excellent for command-line skill-building and the capstone.

- **OverTheWire (Bandit):** SSH-based Linux/command-line wargame — perfect companion to Unit 4.
- **picoCTF:** Carnegie Mellon's beginner CTF with a year-round practice gym; great for Units 13–18 and the capstone. Browser + downloadable challenges.

These are sandboxed, intentionally-vulnerable, and explicitly meant to be attacked — no isolation setup required.

---

## Recommended baseline for most schools
- **Tier A (TryHackMe)** as the primary platform for Units 1–16.
- **Tier C (OverTheWire + picoCTF)** for Linux practice (Unit 4) and the capstone (Unit 18).
- **Tier B (local VMs)** if you have the hardware/IT support, especially for Units 8–9 (scanning) and 15 (priv-esc), where students benefit from a self-contained attacker↔target pair.

## Pre-course IT checklist
- [ ] Meet with IT/security staff; explain the course and expected lab traffic.
- [ ] Allowlist required platform domains through the content filter.
- [ ] Confirm VirtualBox install permissions (if using Tier B).
- [ ] Verify VT-x/AMD-V is enabled in BIOS on lab machines (Tier B).
- [ ] Decide host-only vs internal networking and document it for students.
- [ ] Build and snapshot clean VM images; stage downloads locally to save bandwidth.
- [ ] Test the full student workflow on one machine end-to-end before week 1.
