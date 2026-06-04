# Unit 04 Assessment — Linux & the Command Line

## Formative checks
- **Daily exit tickets** (one per day from the lesson plan): navigation commands, `cat` vs `less` / `rm` danger, what `sudo` does, what `|` and `>`/`>>` do.
- **Permission-decoding check** (Day 3): students translate `ls -l` strings like `-rwxr-xr--` into who can read/write/execute.
- **Pipeline-building check** (Day 4): each student builds a working `command | grep ...` pipeline and redirects output to a file.
- **Bandit walk-around** (Days 4–5): instructor verifies each student can connect via SSH and is logging real commands, not just passwords.
- **Command cheat sheet** completed from memory and self-checked.

## Quiz

**Part A — Multiple choice** (2 points each)

1. Which command shows your **current working directory**?
   - A) `ls`  B) `pwd`  C) `cd`  D) `whoami`

2. Which command **lists files**, including hidden ones?
   - A) `ls -a`  B) `cat`  C) `cd ..`  D) `mkdir`

3. You want to view a long file **one screen at a time**. Which command?
   - A) `cat`  B) `touch`  C) `less`  D) `rm`

4. Which command searches **inside files** for matching text?
   - A) `find`  B) `grep`  C) `which`  D) `ls`

5. In `-rwxr-xr--`, what can a member of the file's **group** do?
   - A) Read, write, execute
   - B) Read and execute
   - C) Read only
   - D) Nothing

6. What does `sudo` do?
   - A) Deletes a file permanently
   - B) Runs a command with administrator (root) privileges
   - C) Lists processes
   - D) Logs you into another computer

7. What does the pipe `|` do?
   - A) Sends the output of one command into the next command
   - B) Deletes a file
   - C) Overwrites a file with output
   - D) Shows the manual page

8. What is the difference between `>` and `>>`?
   - A) Nothing
   - B) `>` overwrites a file; `>>` appends to it
   - C) `>` appends; `>>` overwrites
   - D) Both read from a file

9. Which command **stops a running process** by its PID?
   - A) `top`  B) `ps`  C) `kill`  D) `id`

10. On Debian/Kali, which tool **installs software**?
    - A) `chmod`  B) `apt`  C) `grep`  D) `cat`

11. Which command connects to a remote machine over an **encrypted** connection?
    - A) `ssh`  B) `cat`  C) `find`  D) `mv`

12. The best way to learn what options a command has is to:
    - A) Guess
    - B) Use `man <command>` or `<command> --help`
    - C) Delete it
    - D) Reboot

**Part B — Short answer** (4 points each)

13. Explain why `rm` is dangerous compared to deleting a file in a graphical file manager.

14. Decode this permission string and say who can do what: `-rw-r--r--`. (Cover owner, group, and others.)

15. Write a single command line that lists all files in the current directory in long format and shows **only** the lines containing the text `txt`.

16. In your own words, explain the difference between **`root`** and a normal user, and why you shouldn't run everything as root (use the term *least privilege*).

**Part C — Applied / wargame** (6 points)

17. On a Bandit-style server you log in and `ls` shows several files. One has a name that is just a dash: `-`. You try `cat -` and it seems to hang. Explain **why** that happens and give a command that correctly reads the file.

## Project / performance task

**Prompt:** Complete OverTheWire Bandit levels 0 through ~10–12 and keep a progress log. Restate the safety/authorization reminder at the top, and explain (for at least one level) how you used `man` or `--help` to figure out a command.

**Deliverable:** The Bandit progress log from `lab.md` — one entry per level with the **command used** and one line on what it taught you, plus a closing reflection. Logs must show real commands and reasoning, not just passwords.

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Safety/authorization restated | In own words, accurate, ties to authorization & scope | Restated accurately | Restated but vague | Missing |
| Levels completed | 11+ levels logged | 8–10 levels | 4–7 levels | 0–3 levels |
| Command documentation | Correct command + clear reasoning every level | Mostly correct + some reasoning | Commands shown, little reasoning | Passwords only / missing commands |
| Use of help tools | Clearly shows learning a command via `man`/`--help` | Mentions using help | Implied | None |
| Reflection & professionalism | Thoughtful, original | Adequate | Minimal | Missing/copied |

## Answer key

**Part A**
1. B  2. A  3. C  4. B  5. B  6. B  7. A  8. B  9. C  10. B  11. A  12. B

**Part B**
13. `rm` deletes permanently and immediately — there is no recycle bin or undo on the command line. A mistyped or wildcard `rm` can erase files (or with `-rf`, whole directories) with no recovery. A GUI file manager usually moves files to a trash/recycle bin you can restore from.
14. `-rw-r--r--`: leading `-` = regular file. **Owner:** read + write (`rw-`). **Group:** read only (`r--`). **Others:** read only (`r--`). No one has execute.
15. `ls -l | grep txt` (accept `ls -la | grep txt`).
16. `root` is the administrator account with unrestricted power over the whole system; a normal user is limited to their own files and can't change system settings. You shouldn't run everything as root because mistakes or malicious commands have system-wide consequences; **least privilege** means using only the access you need (and `sudo` for just the commands that require it).

**Part C**
17. `cat -` treats `-` as "read from standard input," so it waits for keyboard input and appears to hang (press `Ctrl+C` or `Ctrl+D` to escape). The file is named `-`, so you must give a path that doesn't look like an option: `cat ./-` (also acceptable: `cat < -`). Full credit for explaining the dash-as-stdin behavior **and** giving a working command.
