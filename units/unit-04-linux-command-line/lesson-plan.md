# Unit 04 — Linux & the Command Line

- **Module:** Module 1 — Technical Foundations
- **Suggested week:** Week 4
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Linux Basics (the command line, filesystem, permissions, processes, package management)

> Almost every security tool you'll use runs on Linux, and almost every server you'll ever test is Linux. PEN-200 assumes you can already move around a Linux shell. This course teaches it from zero. If you can drive the command line, the rest of the course opens up.

## Learning objectives
By the end of this unit, students can:
- **Explain** why Linux and the command line matter in security (servers, tools like Kali, automation).
- **Describe** what a shell/terminal is and **navigate** the filesystem hierarchy using `pwd`, `ls`, and `cd`.
- **Create, view, copy, move, and delete** files and directories using `touch`, `cat`, `less`, `head`, `tail`, `cp`, `mv`, `rm`, and `mkdir`.
- **Find** files and content using `find`, `locate`, `which`, and `grep`.
- **Read and change** Linux permissions (`rwx`, owner/group/other) using `chmod` and `chown`, and **explain** what `sudo` and `root` mean.
- **Inspect** users and processes with `whoami`, `id`, `ps`, `top`, and `kill`.
- **Install** software with `apt` (basics) and **explain** what a package manager does.
- **Combine** commands using pipes and redirection (`|`, `>`, `>>`, `<`).
- **Get help** for any command using `man` and `--help`.
- **Complete** OverTheWire Bandit levels 0 through ~10–12 and **document** the command used for each level.

## Standards alignment
- **NICE Framework:** Knowledge K0060 (operating systems / command-line); Skill S0073 (using virtual machines); aligns to Cyber Defense Analyst / Systems Administration awareness.
- **CSTA / state CS standards:** 3A-CS-02 (compare levels of abstraction and interactions between application software, system software, and hardware); 3B-CS-01 (categorize the roles of operating system software); 3A-AP-13 (use tools/methods to design and iteratively develop solutions — applied to shell workflows).
- **Security+ domain(s):** 4.0 awareness — using OS command-line tools securely; least privilege (`sudo`/permissions) ties to 1.0 / 3.0 concepts.

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Linux | A free, open-source operating system that runs most servers and security tools. |
| Shell | The program that reads the commands you type and runs them (e.g., Bash). |
| Terminal | The window/app where you type into the shell. |
| Command line (CLI) | Controlling the computer by typing commands instead of clicking. |
| Filesystem hierarchy | The tree of folders starting at `/` (root) that holds everything on the system. |
| Path | The address of a file or folder, like `/home/student/notes.txt`. |
| Absolute path | A path starting from `/` (the full address). |
| Relative path | A path starting from where you currently are. |
| Working directory | The folder you are "in" right now (shown by `pwd`). |
| `pwd` | "Print working directory" — shows where you are. |
| `ls` | Lists the contents of a directory. |
| `cd` | "Change directory" — moves you to another folder. |
| `cat` | Prints a file's contents to the screen. |
| `less` | Views a file one screen at a time (press `q` to quit). |
| `head` / `tail` | Shows the first / last lines of a file. |
| `cp` / `mv` / `rm` | Copy / move (or rename) / remove (delete) files. |
| `mkdir` / `touch` | Make a directory / create an empty file (or update its timestamp). |
| `find` / `locate` | Search the filesystem for files (live search / fast index search). |
| `grep` | Search *inside* files (or input) for matching text. |
| `which` | Show the full path of a command's program. |
| Permissions (rwx) | Read / Write / eXecute rights, set for owner, group, and others. |
| `chmod` / `chown` | Change a file's permissions / change its owner. |
| `root` | The all-powerful administrator account on Linux. |
| `sudo` | "Superuser do" — run a single command with administrator rights. |
| Process | A running program. |
| `ps` / `top` | List processes / show live process and resource usage. |
| `kill` | Stop a process by its process ID (PID). |
| `whoami` / `id` | Show who you're logged in as / your user and group IDs. |
| Package manager | A tool that installs/updates software (e.g., `apt` on Debian/Kali). |
| `apt` | The package manager used by Debian, Ubuntu, and Kali Linux. |
| Pipe (`\|`) | Sends the output of one command as the input to the next. |
| Redirection (`>`, `>>`, `<`) | Send output to a file (`>` overwrite, `>>` append) or input from a file (`<`). |
| `man` / `--help` | The manual page / quick help for a command. |
| SSH | Secure Shell — encrypted remote login to another machine over the network. |

## Materials & prep
- Student access to a Linux shell: the **Kali VM** from Unit 02, the TryHackMe **AttackBox**, or any Linux terminal. (Free.)
- **OverTheWire Bandit** access — a free, pre-authorized SSH wargame at [overthewire.org/wargames/bandit](https://overthewire.org/wargames/bandit). Students connect via SSH; no account signup needed.
- An SSH client: built into Linux/macOS terminals and modern Windows (`ssh` command); PuTTY as a fallback on locked-down Windows.
- Slides: why Linux, the filesystem tree, the rwx permission model, pipes/redirection.
- Printed **command cheat sheet** (the vocabulary table commands) and a **Bandit progress log** template.
- **Instructor prep notes:**
  - Confirm outbound **SSH (TCP 2220)** to `bandit.labs.overthewire.org` is allowed through the school firewall. Bandit uses port **2220**, not the default 22 — test this before class. If blocked, file the request with IT early or use the AttackBox (which has outbound access).
  - Play through Bandit levels 0–12 yourself first; keep the answer key (`lab.md`) handy but don't hand it out.
  - Reinforce that students log the **command they used**, not just the password — the goal is the skill, not the flag.
  - Decide your fallback if SSH is blocked: a local terminal practice set covering the same commands.

## ⚖️ Ethics & legal callout
**Bandit is explicitly authorized — your school network is not.** OverTheWire publishes Bandit *specifically* so people can practice on it; that's written permission. The same `ssh`, `find`, and `grep` skills used on Bandit would be **illegal** if pointed at a server you don't own or weren't given permission to access. Practice freely on Bandit; never on the school's systems, a classmate's account, or any machine outside this lab. Authorization and scope are the line.

**Discussion prompt:** "On Bandit, you log in to a server and hunt for a password file. That's the whole game and it's allowed. If you did the *exact same commands* on the school's file server, what changes? Why is one a game and the other a crime?"

## Lesson sequence

### Day 1 — Why Linux? The shell, and getting around
- **Warm-up (5–10 min):** "Have you ever controlled a computer without a mouse? What might be faster about typing commands?"
- **Direct instruction (15–20 min):** Why Linux matters in security (most servers + tools like Kali run on it). What a shell/terminal is. The filesystem hierarchy starting at `/`; absolute vs. relative paths. Navigation: `pwd`, `ls` (with `-l`, `-a`), `cd` (including `cd ..` and `cd ~`).
- **Guided practice (15 min):** Instructor-led "scavenger walk" — class navigates from `/` into `/home`, `/etc`, and back, calling out `pwd` at each stop.
- **Independent practice / lab:** Students explore their own home directory: `pwd`, `ls -la`, `cd` into subfolders, and back. Record three paths they visited.
- **Closure / exit ticket (5 min):** "What command tells you where you are, and what command lists what's there?"

### Day 2 — Working with files & finding things
- **Warm-up (5–10 min):** Quick recall race: name the command to (a) list files, (b) change folders, (c) show where you are.
- **Direct instruction (15–20 min):** Creating and managing files: `touch`, `mkdir`, `cp`, `mv`, `rm` (and the danger of `rm` — no recycle bin). Viewing: `cat`, `less`, `head`, `tail`. Finding: `find`, `locate`, `which`, and `grep` (search inside files). Emphasize reading before deleting.
- **Guided practice (15 min):** Students create a `practice/` folder, make a few files, copy/rename/delete them, and `grep` for a word inside a file they created.
- **Independent practice / lab:** Mini-challenge: hide a known word in one of several files, then `grep -r` to find which file contains it.
- **Closure / exit ticket (5 min):** "What's the difference between `cat` and `less`? Why is `rm` dangerous?"

### Day 3 — Permissions, users & processes
- **Warm-up (5–10 min):** "Should every user be able to change every file? Why might that be dangerous?" (Least privilege.)
- **Direct instruction (15–20 min):** The `rwx` model for owner/group/other; reading `ls -l` output. `chmod` and `chown`. What `root` and `sudo` mean (administrator power, used sparingly). Users/processes: `whoami`, `id`, `ps`, `top`, `kill` (by PID).
- **Guided practice (15 min):** Students run `ls -l` and decode permissions for several files; change a file's permissions with `chmod` and confirm with `ls -l`. Run `whoami`, `id`, `ps`, and open `top`.
- **Independent practice / lab:** Decode three permission strings (e.g., `-rwxr-xr--`) into who can do what. Find their own user's running processes.
- **Closure / exit ticket (5 min):** "What does `sudo` do, and why shouldn't you run everything as root?"

### Day 4 — Pipes, redirection, package basics & getting help
- **Warm-up (5–10 min):** "How could you take a long list of files and only show the ones containing the word 'flag'?" (Pipe into grep.)
- **Direct instruction (15–20 min):** Pipes (`|`) chaining commands; redirection (`>`, `>>`, `<`). Combining: `ls -l | grep txt`, `cat file | head`. Package basics: what a package manager is, `apt update` / `apt install` (concept + careful use; needs `sudo`). Getting help: `man` and `--help` — the most important skill of all (how to figure out *any* command).
- **Guided practice (15 min):** Students build a pipeline (`ls -la | grep <something>`), redirect output to a file (`> out.txt`), append (`>>`), and read a `man` page to find an option they didn't know.
- **Independent practice / lab:** Begin **OverTheWire Bandit** (`lab.md`) — connect via SSH and complete levels 0–3.
- **Closure / exit ticket (5 min):** "What does the `|` symbol do? What's the difference between `>` and `>>`?"

### Day 5 — Bandit wargame + putting it together
- **Warm-up (5–10 min):** Read the **Safety & authorization reminder** in `lab.md` aloud; one student restates why Bandit is legal but the school server is not.
- **Direct instruction (10 min):** Review SSH login and the "read the level page → figure out the command → log it" workflow. Quick `man`/`--help` reminder for unfamiliar commands.
- **Guided practice / independent lab:** Continue **Bandit** through level ~10–12, logging the command used at each level in the Bandit progress log. Encourage using `man` and `--help` before asking.
- **Closure / exit ticket (5 min):** Submit the Bandit progress log; one-sentence "command I'm most proud of figuring out."
- **Assessment:** Unit quiz (`assessment.md`) at end of Day 5 or start of Week 5.

## Differentiation
- **Support:** Provide the command cheat sheet and let students keep it open. Pair students for SSH setup (the trickiest step). Pre-make the `practice/` files for Day 2 so the focus is on commands, not setup. Offer the Bandit level pages with key vocabulary pre-highlighted. Sentence frames for the log ("To solve level N, I used `____` because `____`.").
- **Extension:** Have students push past level 12 in Bandit, learn a new command from `man` and teach it to a partner, write a one-line pipeline that solves a small text-processing task, or explain SSH keys vs. passwords. Challenge: solve a Bandit level two different ways and explain which is better.

## Homework / independent work
- Finish Bandit levels 0–~10–12 if not completed in class (browser/SSH; can be done from any machine with SSH).
- Complete the command cheat sheet from memory, then self-check.
- Short write-up (½ page): "Three command-line tasks that would be tedious with a mouse but fast in the shell," using at least 6 unit vocabulary terms.

## Assessment
- **Formative:** Daily exit tickets; permission-decoding check; pipeline-building check; instructor walk-around during Bandit; the Bandit progress log.
- **Summative:** Unit quiz + the Bandit progress-log deliverable (levels completed + command used for each) — see `assessment.md`.

## Instructor notes & common pitfalls
- **SSH connectivity is the #1 failure point.** Bandit uses port **2220** — confirm the firewall allows it *before* Day 4, or use the AttackBox. Have a local-terminal fallback ready.
- Students fear the blank terminal. Normalize "type, read the output, try again." Celebrate using `man`/`--help` over memorizing.
- `rm` has no undo and no recycle bin. Stress this; consider having students practice deletes only inside a `practice/` folder.
- Permissions confuse students — drill the three groups (owner/group/other) and the three bits (rwx). Use `ls -l` repeatedly.
- Don't let Bandit become a password-copying race. **The deliverable is the command and the reasoning**, not the flag. Spot-check that logs show real commands.
- Reinforce the ethics point daily: same skills, different target = legal vs. illegal. Bandit is the authorized playground.
- Watch for students running everything with `sudo`. Use it to teach least privilege: only when truly needed.
