# Unit 04 Lab — OverTheWire Bandit (Command-Line Wargame)

- **Platform:** OverTheWire **Bandit** — a free, pre-authorized SSH wargame at [overthewire.org/wargames/bandit](https://overthewire.org/wargames/bandit)
- **Time:** ~90 minutes total (about two class periods, split as the lesson plan describes)
- **Difficulty:** Intro / beginner

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment. Doing this to any
system you do not own or have written permission to test is illegal.

For this lab that means: Bandit is published by OverTheWire **specifically** so people
can practice on it — that is your written permission, and your scope is the Bandit
servers only. The *same* commands (`ssh`, `find`, `grep`, reading password files) would
be **illegal** if run against the school's servers, a classmate's account, or any machine
outside this lab. Authorization and scope are the dividing line. Never reuse these skills
on a system you weren't given permission to access.

## Objectives
- Connect to a remote Linux server using **SSH**.
- Use core command-line tools to find and read files: `ls`, `cd`, `cat`, `file`, `find`, `grep`, and more.
- Read permissions, follow paths, and use `man`/`--help` to learn unfamiliar commands.
- **Document the command you used** for each Bandit level (the skill matters more than the password).

## Setup
1. **Log the basics.** In your Bandit progress log, write today's date, your name, and the safety reminder above restated in one sentence of your own words.
2. **Find a terminal with SSH.** On Linux/macOS, open the Terminal. On Windows 10/11, open PowerShell or Command Prompt (`ssh` is built in); if it's missing, your instructor will provide PuTTY. On the TryHackMe AttackBox, just use its terminal.
3. **Know the connection details (read the Bandit page first):**
   - Host: `bandit.labs.overthewire.org`
   - **Port: `2220`** (not the usual 22 — this trips people up)
   - Level 0 username: `bandit0`, password: `bandit0`
4. **Read the level pages as you go.** Each level has its own page on the OverTheWire site that tells you what command(s) you'll need and links to their manuals. Reading the page *is* part of the lab.

## Walkthrough

### Step 0 — Connect (Level 0)
Connect with SSH on port 2220:

```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
```

When asked, the password is `bandit0`. (The first time, accept the host key by typing `yes`.)

*Expected:* you land at a prompt like `bandit0@bandit:~$`. You are now logged into the remote server.

> **How each level works:** every level's goal is to find the **password for the next level**. You read the current level's page, figure out which command finds the password on the server, run it, copy the password, then `exit` and SSH back in as the next user (`bandit1`, `bandit2`, …) using the password you found.

### Step 1 — Level 0 → 1: read a file in your home directory
Read the Bandit Level 0 page. The password for level 1 is in a file called `readme` in your home directory.

Try, in order: `ls` to see what's there, then read the file. **Log the command you used.** Then:

```bash
exit
ssh bandit1@bandit.labs.overthewire.org -p 2220
```

…and use the password you just found.

### Step 2 — Levels 1 through ~10–12: work the wargame
Continue level by level. For **each** level: read the level page, figure out the command, run it, **record it in your log**, then move to the next level. You will practice (concept per level — figure out the exact command yourself):

| Level | Concept it teaches (don't just look up the answer — reason it out) |
|-------|---------------------------------------------------------------------|
| 0 → 1 | Reading a normal file (`cat`). |
| 1 → 2 | A file with a tricky name (a single `-`) — paths matter (`./-`). |
| 2 → 3 | A filename with **spaces** — quoting or escaping. |
| 3 → 4 | A **hidden** file (starts with `.`) — `ls -a`. |
| 4 → 5 | The only **human-readable** file among many — `file` + `cat`. |
| 5 → 6 | Find a file by **size/properties** — `find` with options. |
| 6 → 7 | Find a file by **owner/group/size** across the whole system — `find / ...`. |
| 7 → 8 | Find a word inside a big file — `grep`. |
| 8 → 9 | Find the **only unique** line — `sort` piped to `uniq -u`. |
| 9 → 10 | Find readable strings in a binary — `strings` (+ `grep`). |
| 10 → 11 | Data encoded in **base64** — `base64 -d`. |
| 11 → 12 | A simple letter-rotation cipher (**ROT13**) — `tr`. |

For each level, your log entry should look like:

```
Level 3 → 4
Goal: read the hidden file in the inhere directory
Command I used: ls -a inhere   then   cat inhere/...hidden
What I learned: hidden files start with a dot; ls -a shows them
```

### Step 3 — Use help when stuck
Before asking for help, try:

```bash
man find        # full manual (press q to quit)
find --help     # quick options summary
grep --help
```

*Expected:* you can find the option you need yourself. Note in your log any command you learned from `man`/`--help`.

## Deliverables
Submit your **Bandit progress log** containing:
- The safety reminder restated in your own words.
- One entry **per level completed** (aim for 0 → ~10–12), each with: the level, the goal, **the command you used**, and one line on what it taught you.
- At least one note showing you used `man` or `--help` to figure something out.
- A closing reflection (1–2 sentences): the level you're proudest of solving and why.

> Note: log the **command and the reasoning**, not just the password. The passwords change and aren't the point — the skill is.

## Stretch goals (optional)
- Push past level 12 (the next levels add compression and SSH keys — great extensions).
- Solve one level **two different ways** and explain which is cleaner.
- Set up an **SSH key** so you don't retype passwords, and explain how key auth is more secure than passwords.
- Build a one-line pipeline that solves a level using `|`, `sort`, `uniq`, or `grep`.

## Answer key (instructor only)
> Bandit passwords rotate periodically; **do not hand these out**. The point is the command and reasoning. Below are the *intended techniques* per level so you can guide without giving answers.

- **0 → 1:** `cat readme`
- **1 → 2:** filename is `-`; can't `cat -` (that reads stdin). Use a path: `cat ./-` (or `cat < -`).
- **2 → 3:** filename has spaces; quote or escape: `cat "spaces in this filename"` or `cat spaces\ in\ this\ filename`. Tab-completion helps.
- **3 → 4:** hidden file in `inhere/`: `ls -a inhere`, then `cat inhere/...Hiding-From-You` (name varies; whatever the dotfile is).
- **4 → 5:** `cd inhere`; one file is human-readable. `file ./*` to find the ASCII one, then `cat` it. (Filenames like `-file00`…`-file09`, so use `./`.)
- **5 → 6:** human-readable, 1033 bytes, not executable, in `inhere/`. `find inhere -size 1033c ! -executable` then `cat` the match (or `find ... -readable -size 1033c`).
- **6 → 7:** somewhere on the whole server, owned by user `bandit7`, group `bandit6`, 33 bytes: `find / -user bandit7 -group bandit6 -size 33c 2>/dev/null` then `cat`. (Teach `2>/dev/null` to hide permission-denied noise.)
- **7 → 8:** password next to the word "millionth" in `data.txt`: `grep millionth data.txt`.
- **8 → 9:** the only line that occurs once in `data.txt`: `sort data.txt | uniq -u`.
- **9 → 10:** few human-readable strings in binary `data.txt`, password preceded by `=` signs: `strings data.txt | grep =`.
- **10 → 11:** base64-encoded in `data.txt`: `base64 -d data.txt`.
- **11 → 12:** ROT13-encoded in `data.txt`: `cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'`.
- **Connection issues:** wrong port is the most common error — it must be `-p 2220`. If outbound 2220 is blocked, use the TryHackMe AttackBox terminal or have IT allow it. Accepting the host key (`yes`) is needed on first connect.
- **Process tips:** if a student's session hangs, `Ctrl+C` to cancel, `Ctrl+D` or `exit` to log out. Remind them each new level requires a fresh `ssh banditN@... -p 2220`.
- **Grading focus:** logs should show real commands and reasoning; identical "password only" logs across students are a red flag for copying. Reward correct use of `man`/`--help` and elegant pipelines.
