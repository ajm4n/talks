# Unit 16 Lab — Metasploit Framework (with optional SSH port-forward demo)

- **Platform:** TryHackMe — a beginner **Metasploit** room (walks through `msfconsole`, getting a Meterpreter session, and basic post modules), run from the TryHackMe **AttackBox** or a **Kali Linux** VM (Metasploit is preinstalled). Optional: a simple **SSH local port-forward** demo on the isolated lab. Free tier.
- **Time:** ~3 class periods of lab work across Days 2–5.
- **Difficulty:** Beginner

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment — the authorized
TryHackMe room or the isolated class lab. Metasploit will happily attack
whatever you point it at; it does **not** check whether you have permission —
**you** are responsible for that. The target machines here are **deliberately
vulnerable** so you can practice safely. Using `msfconsole`, msfvenom, or a
tunnel against any system you do not own or do not have **written permission**
to test is a serious crime under the CFAA and state law. The single line
between a penetration tester and a criminal is **authorization and scope**. If
you are ever unsure whether a target is in scope, stop and ask your instructor.

## Objectives
- Navigate `msfconsole` using the workflow: `search`, `use`, `show options`, `set`, `exploit`/`run`.
- Correctly set **RHOSTS** (target) and **LHOST** (your listener).
- Use an **exploit** module with a **Meterpreter payload** to open a **session** on an authorized target.
- Run basic **post-exploitation** commands/modules (e.g., `sysinfo`, `getuid`) and read the output.
- Understand at an **awareness level** what **msfvenom** generates and why defenders care.
- (Optional) Demonstrate a simple **SSH local port-forward** to make **pivoting** concrete.
- Document the session and **explain pivoting in your own words**.

## Setup
1. Read the **Safety & authorization reminder** above out loud with a partner before touching a target.
2. Log in to TryHackMe and start the assigned **Metasploit** room. Click **Start AttackBox** (or boot your Kali VM and connect as your instructor directs).
3. Start the **target machine** and note its IP address. Wait until it is fully booted.
4. Find your own AttackBox/Kali IP (you'll need it for `LHOST`):
   ```bash
   ip addr        # look for the tun0 / room VPN interface, or the AttackBox IP
   ```
5. Open your lab journal (template at the bottom). Record the date, room name, target IP (your `RHOSTS`), and your IP (your `LHOST`).

## Walkthrough

> Aim Metasploit **only** at the authorized target IP for this room. Record each command and its result in your journal as you go.

### Step 1 — Launch msfconsole
```bash
msfconsole
```
- **Expected:** The Metasploit banner and an `msf6 >` prompt. (First launch can take a minute.)

### Step 2 — Find a module (`search`)
Search for the module the room points you to (by service, software name, or CVE).
```bash
search <keyword-from-the-room>
```
- **Expected:** A numbered list of matching modules. Note the **full module path** of the exploit you want (e.g., `exploit/...`).

### Step 3 — Select the module (`use`) and read its settings (`show options`)
```bash
use <exploit/module/path>
show options
```
- **Expected:** The prompt changes to show the module name. `show options` lists settings; **required** ones are marked `yes`. You'll almost always need to set **RHOSTS** (the target).

### Step 4 — Choose a payload and set options (`set`)
```bash
# Use a Meterpreter payload if the room/module supports it:
set PAYLOAD <meterpreter-payload-from-the-room>

set RHOSTS <target-ip>      # the TARGET machine
set LHOST <your-ip>         # YOUR AttackBox/Kali (where the shell connects back)
# set LPORT and any other required option the room specifies
show options                # double-check nothing required is blank
```
- **Expected:** `show options` now shows your values filled in. **RHOSTS = target**, **LHOST = you** — mixing these up is the #1 reason a session never opens.

### Step 5 — Run the exploit (`exploit`)
```bash
exploit
```
- **Expected:** Metasploit launches the exploit and, on success, opens a session — ideally `Meterpreter session 1 opened`. If it fails, recheck `LHOST`, the payload, and that the target is up.

### Step 6 — Basic Meterpreter post-exploitation
Once you have a Meterpreter prompt (`meterpreter >`):
```bash
sysinfo        # OS, hostname, architecture
getuid         # which account you're running as
help           # see available commands
```
- **Expected:** `sysinfo` shows the target's details; `getuid` shows your current user. Record these — they are proof of a working session.

### Step 7 — Run a basic post module
Background the session and run a post module (or run one the room specifies):
```bash
background              # returns you to msf prompt; note the session number
search post <topic>     # e.g., a basic enumeration post module
use <post/module/path>
set SESSION 1           # the session number from "background"
run
```
- **Expected:** The post module gathers and prints information from the target. Capture the output. (Only run modules the room intends — do not dump credentials or alter the box beyond the room's scope.)

### Step 8 (awareness only) — what msfvenom does
You will **not** build or deploy a payload. As a class/instructor demo, observe that a command like the one below *generates* a standalone payload file:
```bash
# AWARENESS / read-only discussion — do NOT deploy anything outside the lab.
# msfvenom -p <payload> LHOST=<ip> LPORT=<port> -f <format> -o <file>
```
- In your journal, write **one sentence** on what msfvenom produces and **one sentence** on why a defender (EDR/antivirus) cares.

### Step 9 (optional) — simple SSH local port-forward (pivoting made concrete)
If the isolated lab supports it, demonstrate reaching a service that isn't directly reachable by tunneling through an SSH server:
```bash
# Forward your local port 8000 to an internal service (port 80) reachable from the SSH host:
ssh -L 8000:<internal-host-or-localhost>:80 user@<ssh-server-in-lab>
# Then, in another terminal/browser on your machine:
curl http://localhost:8000
```
- **Expected:** Visiting `localhost:8000` now reaches the internal service *through* the SSH server — that's the essence of **pivoting**: one machine becomes a stepping stone. Sketch the path in your journal: **you → SSH server → internal service**.

## Deliverables
- A completed **Metasploit session journal** (use the template below), including:
  - the full msfconsole workflow you used (`search` → `use` → `show options` → `set` → `exploit`),
  - your `RHOSTS` and `LHOST` values,
  - proof of a session (`sysinfo` + `getuid` output, session number),
  - one basic post-module output,
  - one awareness sentence each on msfvenom (what it makes / why defenders care).
- A short (5–6 sentence) **pivoting explanation in your own words**, plus a sketch of the pivot path.
- A one-line **defense** (detection/EDR/segmentation/patching) for the exploit you used.

### Lab journal template (copy into your journal)
```
Date: ____________   Room: ____________________
RHOSTS (target IP): ____________   LHOST (my IP): ____________

msfconsole workflow:
  search  -> _______________________________________________________________
  use     -> _______________________________________________________________
  payload -> _______________________________________________________________
  set     -> RHOSTS=__________  LHOST=__________  (other:________________)
  exploit -> result: ________________________________________________________

Session proof:
  sysinfo -> ________________________________________________________________
  getuid  -> ________________________________________________________________

Post module run: ____________________  output: ___________________________

msfvenom (awareness): makes _______________; defenders care because ________

Pivoting in my own words:
  __________________________________________________________________________
  __________________________________________________________________________
Pivot path sketch: me -> ____________ -> ____________

Defense for the exploit I used (detection/EDR/segmentation/patching):
  __________________________________________________________________________
```

## Stretch goals (optional)
- Research how the room's exploit works **manually** (no need to run it) and write 4–5 sentences contrasting the manual approach with the Metasploit one-liner.
- Write a short "**how would a defender detect this Meterpreter session?**" analysis (logs, EDR behavior, network signs).
- Explain in plain language the difference between **local**, **remote**, and **dynamic** port forwarding.
- Write 3–4 sentences on **why enterprises use Active Directory** and one reason it's a high-value target (concept only, no attack steps).

## Answer key (instructor only)

> Fill in the **exact** module paths, payload, and options for the specific room you assign after completing it yourself. Below is the general solution pattern and grading guide for a standard beginner Metasploit room.

**Typical solution pattern:**
1. `msfconsole` → `search <service/CVE>` → note the exploit path.
2. `use exploit/<path>` → `show options` → identify required fields (RHOSTS, and often payload/LHOST).
3. `set PAYLOAD <meterpreter payload>` (e.g., a `meterpreter/reverse_tcp` variant matching the target OS/arch).
4. `set RHOSTS <target>`; `set LHOST <attacker tun0/AttackBox IP>`; set `LPORT` if required.
5. `exploit` → `Meterpreter session opened`.
6. `sysinfo`, `getuid` confirm the session; `background` then a `post/` enumeration module with `set SESSION <n>` → `run`.

**The two most common failure points (and fixes):**
- **LHOST/RHOSTS swapped** or LHOST set to a wrong interface — fix LHOST to the VPN/AttackBox IP that the target can reach back to.
- **Payload mismatch** (wrong OS/architecture) — pick the payload matching the target.

**msfvenom (awareness):** generates a standalone payload artifact (e.g., an `.exe`, `.elf`, or script) that, when run on a victim, connects back to a listener. Defenders care because EDR/antivirus and detection rules are built to recognize exactly these artifacts and behaviors. **No student should build or deploy a payload** — read-only discussion only.

**SSH local port-forward demo (optional):** `ssh -L 8000:localhost:80 user@<lab-ssh-host>` then browse `localhost:8000`. Confirms the pivot concept: traffic to the local port is tunneled through the SSH host to an otherwise-unreachable internal service.

**Defenses to expect in student answers (any correct one per exploit):**
- **Detection/logging** — the exploit and session leave log entries and network signatures.
- **EDR** — endpoint software flags Meterpreter-style in-memory behavior.
- **Network segmentation** — isolating zones limits how far an attacker can pivot.
- **Patching** — installing updates removes the vulnerability the exploit module relies on.

**Grading guide (aligns to the lab-journal rubric in `instructor/grading-and-rubrics.md`):**
- Correct, ordered msfconsole workflow with right RHOSTS/LHOST: most of the credit.
- Proof of a working session (`sysinfo` + `getuid`) and one post module: required.
- A correct, specific defense for the exploit used: required.
- Pivoting explained clearly in the student's own words + a correct path sketch: required.
- Safety/authorization acknowledged; all work inside the authorized room/isolated lab: gate (no credit for out-of-scope activity).

**Common student errors:**
- Swapping RHOSTS and LHOST (see above).
- Choosing a payload that doesn't match the target OS/architecture.
- Forgetting to `background` before running a `post` module / not setting `SESSION`.
- Treating Metasploit as the whole skill — require the "why work manually" reflection.
