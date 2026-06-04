# Unit 15 Lab — Linux Privilege Escalation (with optional Windows awareness)

- **Platform:** TryHackMe — a beginner Linux Privilege Escalation room (covers `sudo`, SUID, and cron), run from the TryHackMe **AttackBox** or a **Kali Linux** VM. Optional: a basic Windows PrivEsc room for awareness. Free tier.
- **Time:** ~3 class periods of lab work, spread across Days 2–5 (plus optional Windows on Day 4).
- **Difficulty:** Beginner

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment — the authorized
TryHackMe room or the isolated class lab. The target machines here are
**deliberately broken** so you can practice safely. Doing any of this to a
system you do not own or do not have **written permission** to test is illegal
under the CFAA and state law — even if you "only looked." The single line
between a penetration tester and a criminal is **authorization and scope**.
If you are ever unsure whether a target is in scope, stop and ask your
instructor. Never point LinPEAS, `find`, or any technique at a machine outside
this lab.

## Objectives
- Start from a **low-privilege** shell and confirm who you are (`whoami`, `id`).
- Enumerate the system with manual commands and with **LinPEAS**.
- Identify and exploit at least **two** Linux privilege-escalation vectors from: **sudo misconfiguration**, **SUID binary**, **cron job**, **weak/world-writable file permissions**, **readable sensitive file**.
- Reach **root** (`uid=0`) and capture proof.
- Document the full **privilege-escalation path** in your lab journal, and write the **defense** that would stop each vector.

## Setup
1. Read the **Safety & authorization reminder** above out loud with a partner before touching a target.
2. Log in to TryHackMe and start the assigned **Linux PrivEsc** room. Click **Start AttackBox** (or boot your Kali VM and connect via the room's VPN/AttackBox as your instructor directs).
3. Start the **target machine** in the room and note its IP address. Wait until it is fully booted.
4. Open your lab journal (use the template at the bottom of this file). Write today's date, the room name, and the target IP.
5. Get the initial low-privilege shell exactly as the room instructs (often SSH with provided credentials, or a web/RCE foothold the room walks you through). This unit is about what happens **after** you get that shell.

## Walkthrough

> Run every command **on the target machine** (the intentionally vulnerable box), never on the AttackBox itself or any other system. Record each command and its result in your journal as you go.

### Step 1 — Confirm your foothold (who am I?)
Find out exactly which account you landed on and what it can do.

```bash
whoami
id
hostname
```

- **Expected:** A normal username (not `root`), and `id` showing a non-zero `uid` (for example `uid=1000(user)`). This is your **low-privilege** starting point — write it in your journal.

### Step 2 — First enumeration questions
Ask the three "first questions" from Day 1.

```bash
# What am I allowed to run as another user (often root)?
sudo -l

# Where are the SUID binaries (programs that run as their owner)?
find / -perm -4000 -type f 2>/dev/null

# What is scheduled to run automatically?
cat /etc/crontab
ls -la /etc/cron.d/ 2>/dev/null
```

- **Expected:** `sudo -l` may list one or more commands you can run as root (look for `NOPASSWD`). The `find` command prints a list of SUID programs. `crontab` shows scheduled tasks and which user runs them. **Anything unusual here is a lead** — write down every lead.

### Step 3 — Look up your leads on GTFOBins
For any program you can run via `sudo` or that appears as a SUID binary, look it up on **GTFOBins** (a reference site listing how common binaries can be abused). Do **not** memorize — learn to look up.

- In a browser, search GTFOBins for the binary name (for example `find`, `vim`, `less`, `nano`, `python`).
- If it has a **Sudo** or **SUID** section, that is your escalation method. Copy the suggested command into your journal and trace **why** it works before running it.

### Step 4 — Exploit Vector A: sudo misconfiguration (if present)
If `sudo -l` showed a command you can run as root, abuse it per GTFOBins. Example pattern (the exact command depends on the binary):

```bash
# Example only — use the GTFOBins command for the binary your box allows.
# (find is a classic: -exec runs a command as root)
sudo find . -exec /bin/sh \; -quit
```

- **Expected:** A new shell prompt. Immediately confirm with `id` — you want to see `uid=0(root)`.

### Step 5 — Exploit Vector B: SUID binary (if present)
If `find` listed an abusable SUID program, use its GTFOBins **SUID** method. Example pattern:

```bash
# Example only — replace with the actual abusable SUID binary on your box.
# Many SUID programs accept a flag/command that spawns a shell as the owner (root).
/usr/bin/<suid-binary> <gtfobins-payload>
id
```

- **Expected:** `id` shows `uid=0` (or `euid=0`), meaning you are running with root privileges.

### Step 6 — Exploit Vector C: cron job / weak permissions (if present)
If a cron job runs as root and calls a script you can write to (or a world-writable file/folder root uses):

```bash
# Check permissions on the script the cron job runs:
ls -la /path/to/scheduled-script.sh

# If you can write to it, append a command that gives you root.
# Example: copy a shell and make it SUID, or add yourself a reverse/bind shell.
echo 'cp /bin/bash /tmp/rootbash; chmod +s /tmp/rootbash' >> /path/to/scheduled-script.sh

# Wait for the cron interval to pass, then:
/tmp/rootbash -p
id
```

- **Expected:** After the cron job runs (watch the interval in `/etc/crontab`), your planted command executes as root. `/tmp/rootbash -p` gives a root shell; `id` shows `uid=0` or `euid=0`.

### Step 7 — Capture proof of root
Once you are root, capture evidence for your journal.

```bash
id
whoami
cat /root/root.txt 2>/dev/null   # the room's root flag, if it has one
```

- **Expected:** `whoami` prints `root`; `id` shows `uid=0`; the room flag (if any) is now readable. Save this output — it is your proof of full escalation.

### Step 8 — Run LinPEAS and compare to your manual work
Now run the automated helper and match its findings to what you found by hand.

```bash
# LinPEAS is usually staged in the room (or your instructor provides it).
# Run it from a writable directory, e.g.:
./linpeas.sh | tee linpeas-output.txt
```

- **Expected:** LinPEAS prints color-coded findings (red/yellow = likely privesc). Find the lines that match the vector(s) you exploited. In your journal, note **at least one** finding LinPEAS flagged that you also found manually — this proves LinPEAS *finds* issues but the human still decides.

### Step 9 (optional, awareness) — Windows privesc demo
If your class does the optional Windows portion, follow the instructor demo or basic room. You are only **observing the concept**: a normal user becoming Administrator/SYSTEM through a misconfiguration such as an **unquoted service path**, and what **WinPEAS** output looks like. No deep Windows/AD work this unit.

## Deliverables
- A completed **lab journal** documenting the full **privilege-escalation path** (use the template below), including:
  - your low-privilege starting account (`whoami` / `id`),
  - each enumeration step and what it revealed,
  - the vector(s) you exploited and the exact commands,
  - proof of root (`id` showing `uid=0`, plus the flag if any),
  - the LinPEAS finding(s) that matched your manual work,
  - a one-line **defense** for each vector you used.
- A short (5–6 sentence) plain-English explanation of how **one** vector escalated you to root.

### Lab journal template (copy into your journal)
```
Date: ____________   Room: ____________________   Target IP: ____________

Start as: ______________ (output of `id`): ______________________________

Enumeration findings:
  sudo -l    -> ___________________________________________________________
  SUID find  -> ___________________________________________________________
  cron/files -> ___________________________________________________________

Vector used: __________________________   GTFOBins lookup: ________________
Command(s):
  __________________________________________________________________________
  __________________________________________________________________________

Now I am: ____________ (proof / `id`): ___________________________________
Root flag (if any): ______________________________________________________

LinPEAS finding that matched my manual work: _____________________________

Defense for this vector (least privilege / hardening / patching): ________
  __________________________________________________________________________
```

## Stretch goals (optional)
- Find a **second, different** path to root on the same box and document it.
- Reproduce one LinPEAS red/yellow finding **entirely by hand** and explain what LinPEAS checked.
- Complete the optional **Windows PrivEsc** room and write a short Linux-vs-Windows privesc comparison.
- Research one real **CVE-based kernel privesc** story; summarize the root cause and the patch that fixed it (no attack instructions).

## Answer key (instructor only)

> Fill in the **exact** path for the specific room you assign after completing it yourself. Below is the general grading guide and the typical solution pattern for a standard beginner Linux PrivEsc room.

**Typical escalation paths (room-dependent):**

1. **sudo misconfiguration.** `sudo -l` reveals a `NOPASSWD` entry for a GTFOBins-abusable binary (e.g., `find`, `vim`, `less`, `nano`, `awk`, `python`).
   - Example: `sudo find . -exec /bin/sh \; -quit` → root shell.
   - Example: `sudo vim -c ':!/bin/sh'` → root shell.
   - **Defense:** least privilege — remove the broad/`NOPASSWD` sudo grant; only allow the specific, safe command actually needed.

2. **SUID binary.** `find / -perm -4000 -type f 2>/dev/null` lists an abusable SUID program; use its GTFOBins SUID method.
   - Example: a SUID `bash` → `/path/bash -p`. A SUID `find` → `find . -exec /bin/sh -p \; -quit`.
   - **Defense:** hardening — remove the SUID bit (`chmod u-s`) from binaries that don't need it; keep an inventory of SUID files.

3. **Cron job + weak permissions.** A root cron job runs a world-writable or user-writable script. Append a payload (e.g., make a SUID copy of bash), wait for the interval, then run it `-p`.
   - **Defense:** hardening — correct file permissions so only root can write the script; never run world-writable files from cron; least privilege on cron tasks.

4. **Weak/world-writable files or readable sensitive files.** A world-writable file root later uses, or a readable file leaking credentials/keys (e.g., a backup, a config, `/etc/passwd` writable, an SSH key with bad perms).
   - **Defense:** hardening — fix permissions; store secrets securely; remove readable credentials.

5. **Kernel exploit (awareness only — usually not required in beginner rooms).** Out-of-date kernel vulnerable to a public privesc exploit. Risky (can crash the box).
   - **Defense:** patching/updates — keep the kernel and packages current.

**Proof of success:** student's journal shows `id` → `uid=0(root)` and/or the room's `root.txt` flag, with the full command trail and a defense for each vector used.

**Grading guide (aligns to the lab-journal rubric in `instructor/grading-and-rubrics.md`):**
- Reproducible path documented start → root: most of the credit.
- Manual enumeration shown (not just LinPEAS output dumped): required for full marks.
- At least one LinPEAS finding matched to a manual finding: required.
- A correct, specific defense paired with each exploited vector: required.
- Safety/authorization reminder acknowledged; all work inside the authorized room/isolated lab: gate (no credit for any out-of-scope activity).

**Common student errors:**
- Pasting a GTFOBins command for the wrong binary — make sure they look up the binary *actually* present on their box.
- Forgetting `-p` on a SUID shell (drops privileges otherwise).
- Editing the cron script but not waiting for the interval.
- Treating LinPEAS as the answer instead of verifying findings — require the manual match.
