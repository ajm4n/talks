# Unit 02 Assessment — Building Your Safe Hacking Lab

## Formative checks
- **Daily exit tickets** (one per day, from the lesson plan).
- **"Sort the adapter" activity** (Day 2): students correctly label scenarios host-only / internal / NAT and flag dangerous ones.
- **IP & network-mode check** (Day 3): student can state their attack machine's IP and network mode.
- **Isolation-result check** (Day 4): student shows that the target ping succeeded and `ping 8.8.8.8` failed.
- **AUP gate check** (Day 1): confirm signed agreement is on file before hands-on work.

## Quiz

1. A virtual machine (VM) is best described as:
   - A) A physical second computer
   - B) A whole computer that runs as software inside your real computer
   - C) A web browser
   - D) A type of virus

2. Your real, physical computer is called the ____, and a VM running on it is called the ____.
   - A) guest; host   B) host; guest   C) server; client   D) target; attacker

3. Why do security professionals do their work inside VMs? (Choose the BEST answer.)
   - A) VMs are faster than real computers
   - B) You can safely break them, isolate them, and reset them to a clean state
   - C) VMs are required by law
   - D) VMs can't run Linux

4. What is Kali Linux?
   - A) A web browser
   - B) A free Linux distribution loaded with security/pentesting tools, used as an attack workstation
   - C) A type of firewall
   - D) An antivirus program

5. A **snapshot** lets you:
   - A) Take a photo of your screen
   - B) Save a VM's state so you can instantly restore it to a clean point later
   - C) Speed up the internet
   - D) Permanently delete a VM

6. During an attack lab, which VirtualBox network mode should you use to keep the lab isolated?
   - A) Bridged   B) NAT   C) Host-Only (or Internal Network)   D) Any of them

7. Which network modes must you NOT use during an attack lab, and why?
   - A) Host-Only and Internal — they're too slow
   - B) Bridged and NAT — they expose the school network / give internet access, breaking isolation
   - C) Internal and NAT — they cost money
   - D) None; all modes are safe

8. You run `ping 8.8.8.8` from Kali during an attack lab. For a properly isolated lab, the correct result is:
   - A) It succeeds (replies come back)
   - B) It fails / times out (no replies) — proving you can't reach the internet
   - C) It restarts the VM
   - D) It installs updates

9. You run `ping` against your lab **target's** host-only IP and it succeeds. This tells you:
   - A) Your lab is broken
   - B) Kali can reach the target on the isolated network — good
   - C) You are connected to the internet
   - D) The target is infected

10. The TryHackMe **AttackBox** is:
   - A) A physical computer you must buy
   - B) An in-browser, pre-isolated attack machine you control from a web page — no install needed
   - C) A malware sample
   - D) A type of firewall

11. Which is true about the three lab tiers?
   - A) You must use all three
   - B) Tier A (browser) needs only a web browser and works on weak/locked-down machines; Tier B (local VMs) gives full control but needs more setup
   - C) Tier C requires bridged networking
   - D) Tier B has no isolation requirement

12. Before doing any hands-on work in this unit, you must have:
   - A) A new laptop
   - B) A signed Acceptable Use & Ethics Agreement on file
   - C) A bridged network
   - D) Administrator rights to the school network

13. Your VM gets "owned" / messed up during a lab. The fastest way back to a known-good state is:
   - A) Reinstall the whole operating system
   - B) Buy a new computer
   - C) Restore your clean snapshot
   - D) Switch to bridged networking

14. **Short answer:** In 2–3 sentences, explain why verifying isolation is an *ethical* step, not just a technical one.

15. **Short answer:** A classmate's Kali VM is set to **Bridged** and they're about to start an attack lab. What do you tell them, and what should they do instead?

## Project / performance task

**Prompt:** Build a working, isolated lab and prove it. Set up your assigned tier(s), verify isolation, snapshot/reset, complete the intro room (Tier A) or finalize the VM (Tier B), and document everything.

**Deliverable:** Screenshot proof of a working isolated lab + a lab-journal entry.
- **Tier A:** logged-in dashboard, loaded AttackBox, intro room with completed tasks.
- **Tier B:** Network settings showing **Host-Only**, Kali's IP (`ip a`), successful **target** ping, **failed** `ping 8.8.8.8`, and a `clean-isolated` snapshot.
- **Journal entry:** tier used, IP, network mode, isolation test results, and troubleshooting notes — with the safety reminder at the top.

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Environment set up | Fully working; intro room completed / Kali + target booting cleanly | Working with minor gaps | Partially set up; needs help to run | Not set up |
| Network isolation | Host-only configured AND verified (target ping succeeds, `8.8.8.8` fails) with proof | Isolation configured and mostly verified | Configured but not verified | Not isolated / bridged or NAT used |
| Screenshot proof | All required screenshots, clearly labeled | Most screenshots present | Some screenshots missing/unclear | Little or no proof |
| Snapshot / reset | Clean snapshot taken (or reset process documented) | Snapshot taken | Attempted | None |
| Journal & professionalism | Clear, complete entry with safety reminder + troubleshooting notes | Complete with minor gaps | Sparse entry | Missing/incomplete |

## Answer key
1. B
2. B
3. B
4. B
5. B
6. C
7. B
8. B
9. B
10. B
11. B
12. B
13. C
14. **Sample:** Isolation physically prevents your attacks from reaching anything outside the lab — like the school network or the internet — which would be unauthorized access. Promising not to hurt the wrong thing isn't enough; verifying isolation backs up that promise and protects you and others from accidental, illegal harm.
15. **Sample:** Tell them to stop before starting — bridged puts the VM on the real network, so an attack could hit the school LAN or other devices, which is unauthorized and illegal. They should change Adapter 1 to **Host-Only** (or Internal Network), then re-verify by confirming `ping 8.8.8.8` fails before doing anything.
