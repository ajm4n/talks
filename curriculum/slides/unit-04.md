---
marp: true
theme: default
paginate: true
header: "Introduction to Offensive Security · Unit 04"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Linux & the Command Line
## Unit 04 — Technical Foundations

Almost every server you'll ever test, and almost every tool you'll ever use, runs on Linux. Time to learn to drive it.

<!-- Week 4, ~5 class periods. Goal: get students comfortable in a blank terminal. The big payoff is Bandit. Don't rush the ethics framing on Day 5. -->

---

# Learning objectives

By the end of this unit you can:

- **Explain** why Linux and the CLI matter in security.
- **Navigate** the filesystem with `pwd`, `ls`, `cd`.
- **Manage files**: `touch`, `cat`, `less`, `cp`, `mv`, `rm`, `mkdir`.
- **Find** files and text: `find`, `locate`, `which`, `grep`.
- **Read & change** permissions (`rwx`, `chmod`, `chown`); explain `sudo`/`root`.
- **Inspect** users & processes: `whoami`, `id`, `ps`, `top`, `kill`.
- **Combine** commands with pipes and redirection (`|`, `>`, `>>`, `<`).
- **Complete** OverTheWire Bandit levels 0–~12 and log each command.

---

# Why Linux? Why the command line?

- Most **servers** on the internet run Linux — so most **targets** do too.
- The pentester's toolkit (**Kali Linux**) is built on it.
- The CLI is **faster, scriptable, and repeatable** — perfect for automation.
- No mouse needed: you can work over a remote connection (**SSH**).

> You can't drive a security tool you can't drive the operating system under it.

<!-- Warm-up: "Ever controlled a computer without a mouse? What might be faster?" -->

---

# Shell, terminal, command line

| Term | What it is |
|------|-----------|
| **Terminal** | The window/app you type into |
| **Shell** | The program (e.g., **Bash**) that reads and runs your commands |
| **Command line (CLI)** | Controlling the computer by typing, not clicking |

You type a command → the shell runs it → you read the output → try again.

<!-- Normalize "type, read the output, try again." The blank terminal scares people. -->

---

# The filesystem hierarchy

Everything lives in one tree that starts at `/` (the **root**).

```
/
├── home/      your files live here
│   └── student/
├── etc/       system configuration
├── bin/       programs
└── tmp/       temporary files
```

- **Absolute path:** the full address from `/` → `/home/student/notes.txt`
- **Relative path:** from where you are right now → `notes.txt`

---

# Getting around

```bash
pwd            # print working directory — "where am I?"
ls             # list what's here
ls -la         # long format, including hidden files
cd /etc        # change directory (absolute)
cd ..          # go up one level
cd ~           # go to your home directory
```

> The **working directory** is the folder you're "in" right now.

<!-- Day 1 guided practice: scavenger walk from / into /home, /etc and back, calling out pwd at each stop. -->

---

# Working with files

```bash
touch notes.txt        # create an empty file
mkdir practice         # make a directory
cat notes.txt          # print a file to the screen
less bigfile.txt       # view one screen at a time (q to quit)
head / tail file.txt   # first / last lines
cp a.txt b.txt         # copy
mv b.txt c.txt         # move or rename
rm c.txt               # remove (DELETE)
```

⚠️ **`rm` has no recycle bin.** Deleted is gone. Read before you delete.

<!-- Have students practice deletes only inside a practice/ folder. -->

---

# Finding things

```bash
find / -name "flag.txt"   # live search by name
locate passwd             # fast search of an index
which python3             # where is this command's program?
grep "password" file.txt  # search INSIDE files for text
grep -r "flag" .          # recursive — search a whole folder
```

- `find` / `locate` find **files**.
- `grep` finds **text inside** files (or any input).

<!-- Day 2 mini-challenge: hide a word in one of several files, grep -r to find which. -->

---

# Permissions: the rwx model

`ls -l` shows them. Read left to right:

```
-rwxr-xr--   owner: rwx   group: r-x   other: r--
 │└┬┘└┬┘└┬┘
 │ │  │  └── other (everyone else)
 │ │  └───── group
 │ └──────── owner
 └────────── file type
```

- **r** = read · **w** = write · **x** = execute
- Three groups: **owner**, **group**, **other**

<!-- Day 3 independent: decode three permission strings into who can do what. Drill the 3 groups x 3 bits. -->

---

# Changing permissions & power

```bash
chmod +x script.sh     # make a file executable
chmod 644 notes.txt    # set rw-r--r--
chown student file.txt # change the owner
```

- **root** = the all-powerful administrator account.
- **sudo** = "superuser do" — run **one** command as administrator.

> Use `sudo` only when you truly need it. That's **least privilege**.

<!-- Exit ticket: "What does sudo do, and why shouldn't you run everything as root?" -->

---

# Users & processes

```bash
whoami     # which user am I?
id         # my user and group IDs
ps         # list my processes
top        # live view of processes & resource use (q to quit)
kill 1234  # stop the process with PID 1234
```

A **process** is just a running program. Each has a **PID** (process ID).

---

# Pipes & redirection

```bash
ls -l | grep txt        # send ls output INTO grep
cat data.txt | head     # chain commands together

echo "hi" > out.txt     # > overwrite a file
echo "more" >> out.txt  # >> append to a file
sort < names.txt        # < take input from a file
```

- **Pipe `|`** = output of one command becomes input of the next.
- This is how small tools combine into powerful workflows.

<!-- Warm-up: "How could you show only the files containing 'flag'?" -> pipe into grep. -->

---

# Getting help (the most important skill)

```bash
man find       # full manual (press q to quit)
grep --help    # quick options summary
apt --help
```

- **`man`** and **`--help`** let you figure out *any* command on your own.
- Package basics: `sudo apt update`, `sudo apt install <tool>` — a **package manager** installs and updates software.

> When stuck: read the manual *before* asking. That's the pro habit.

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

## Bandit is authorized. Your school network is not.

OverTheWire publishes **Bandit** *specifically* so you can practice — that's your written permission, and your scope is the Bandit servers only.

The **same** `ssh`, `find`, and `grep` commands would be **illegal** pointed at the school's file server, a classmate's account, or any machine outside this lab.

<!-- Slow down here. Discussion: "Same commands, different target — why is one a game and one a crime?" Authorization + scope is the line. -->

---

# Key vocabulary

| Term | Meaning |
|------|---------|
| **Shell / Terminal** | The program that runs commands / the window you type in |
| **Path** | A file's address (**absolute** from `/`, or **relative**) |
| **Permissions (rwx)** | Read / write / execute for owner, group, other |
| **root / sudo** | The admin account / run one command as admin |
| **Process / PID** | A running program / its ID number |
| **Pipe `\|`** | Feeds one command's output into the next |
| **SSH** | Encrypted remote login to another machine |

---

# Lab launch: OverTheWire Bandit

**Platform:** OverTheWire **Bandit** — a free, pre-authorized SSH wargame.

```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
# password: bandit0   (note: port 2220, NOT 22)
```

**Goal of each level:** find the password for the *next* level using the right command. Then log in as `bandit1`, `bandit2`, …

You'll use: `cat`, `ls -a`, `file`, `find`, `grep`, `sort | uniq -u`, `strings`, `base64 -d`, `tr` (ROT13).

> **Log the command and your reasoning — not just the password.** The skill is the point.

<!-- SSH connectivity is the #1 failure point. Confirm port 2220 is open before Day 4, or use the AttackBox. -->

---

# Recap

- Linux runs the servers and the tools — the CLI is the foundation.
- **Navigate:** `pwd`, `ls`, `cd` · **Files:** `cat`, `cp`, `mv`, `rm`, `mkdir`
- **Find:** `find`, `grep` · **Permissions:** `rwx`, `chmod`, `sudo`
- **Inspect:** `whoami`, `ps`, `top`, `kill`
- **Combine:** pipes `|` and redirection `>`, `>>`, `<`
- **Get help:** `man` and `--help` — figure anything out
- Same skills, different target = the line between **practice** and **crime**.

---

<!-- _class: lead -->

# Exit ticket & discussion

1. What command tells you **where you are**, and what lists **what's there**?
2. What's the difference between `cat` and `less`? Why is `rm` dangerous?
3. What does the `|` symbol do? `>` vs `>>`?

**Discuss:** On Bandit you hunt for a password file and that's allowed. Run the *exact same commands* on the school server — what changes, and why is one a crime?

*Submit your Bandit progress log: one entry per level (goal, command, what you learned).*
