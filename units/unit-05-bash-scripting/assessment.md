# Unit 05 Assessment — Bash Scripting Basics

## Formative checks
- **Daily exit tickets** (one per day from the lesson plan): the two commands that make a file runnable; storing the date in a variable; where the exit code lives and what success is; a `for` line for 1–254; one legal and one illegal place to run the sweep.
- **Predict-the-output warm-ups** (Days 2 & 4): students write what a short variable/loop snippet prints before running it.
- **Debugging participation** (Day 2): the class fixes a deliberately broken script (e.g., a space around `=`).
- **Checkpoint check of each lab part:** instructor verifies each student has a working `banner.sh`, `pingone.sh`, and `sweep.sh` before moving on.
- **Scope check** (before Day 3): instructor confirms each student's `ip addr` shows the host-only lab subnet.

## Quiz

**Part A — Multiple choice** (2 points each)

1. What does the **shebang** line `#!/bin/bash` do?
   - A) Adds a comment B) Tells the system which program runs the file C) Makes the file executable D) Pings a host

2. Which two steps turn a text file into a program you can run?
   - A) `chmod +x script.sh` then `./script.sh`
   - B) `run script.sh` then `start`
   - C) `python script.sh` then `go`
   - D) `cd script.sh` then `ls`

3. Which line correctly creates a variable?
   - A) `name = "Kali"`  B) `name ="Kali"`  C) `name="Kali"`  D) `$name = Kali`

4. What does `$(date)` do?
   - A) Prints the word "date"
   - B) Runs the `date` command and gives back its output (command substitution)
   - C) Creates a file named date
   - D) Nothing — it's a syntax error

5. In `./sweep.sh 192.168.56`, what is `$1` inside the script?
   - A) The script name  B) `192.168.56`  C) The number of arguments  D) The exit code

6. After a command runs, where is its **exit code** stored, and which value means success?
   - A) `$@`, and `1` means success
   - B) `$#`, and `0` means success
   - C) `$?`, and `0` means success
   - D) `$1`, and `1` means success

7. Which loop repeats the numbers **1 through 254**?
   - A) `for i in 1 254`
   - B) `for i in $(seq 1 254)`
   - C) `while 1 to 254`
   - D) `loop 1 254`

8. What is a **function** in Bash?
   - A) A built-in Linux command you can't change
   - B) A named, reusable block of code you can call by name
   - C) A type of variable
   - D) The first line of a script

9. What does the **pipe** `|` do in `ping ... | grep "up"`?
   - A) Runs the two commands in two terminals
   - B) Sends the first command's output into the second command's input
   - C) Saves output to a file
   - D) Comments out the line

10. Why do we use `ping -c 1 -W 1` in the sweep instead of plain `ping`?
    - A) It pings forever
    - B) It sends one ping and waits at most one second, so the sweep doesn't hang on dead hosts
    - C) It encrypts the ping
    - D) It is required by law

**Part B — Short answer** (4 points each)

11. Explain **command substitution** in your own words and give one example line.

12. What is the difference between hard-coding one IP inside a script and passing the IP as an **argument** (`$1`)? Why is the argument version better?

13. The line below is supposed to print "UP" when a host replies. A student wrote it so that it prints "UP" when the host is **down** instead. Explain the bug and how the exit code (`$?`) should be used.
    ```bash
    ping -c 1 -W 1 "$target" > /dev/null 2>&1
    if [ $? -eq 1 ]; then
        echo "$target is UP"
    fi
    ```

14. A classmate says, "Once it's a script, ping sweeping any network is fine — it's just automation." Correct them in two or three sentences, using the words **authorization** and **scope**.

**Part C — Applied / write code** (6 points)

15. Write a short Bash script (5–8 lines) that:
    - has a shebang,
    - takes one IP as `$1`,
    - prints a usage message and exits if no argument is given,
    - pings that one IP once with a 1-second timeout and prints `UP` or `DOWN` based on the exit code.

    (Targets in any example must be a **lab** address.)

## Project / performance task

**Prompt:** Build and document a working **ping sweep** of your assigned isolated lab `/24`. Restate the safety/authorization reminder at the top of your journal page. Run the sweep against the lab subnet only, report the live hosts, and annotate your script line by line.

**Deliverable:** The lab-journal pages from `lab.md` — the three working scripts (`banner.sh`, `pingone.sh`, `sweep.sh`), a screenshot of each running, the list of live hosts cross-checked against the lab inventory, the line-by-line annotation of `sweep.sh`, and the reflection sentence (one task you could automate + one place running it would be illegal).

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Safety/authorization restated | In own words, accurate, names the lab subnet and the authorization/scope idea | Restated accurately | Restated but vague | Missing or copied incorrectly |
| Scripts run correctly | All three scripts run and produce correct output | Two run correctly | One runs correctly | None run / major errors |
| Bash concepts used | Correct shebang, variables, `$1`, `if`/exit code, loop, and function | Most used correctly | Some used correctly | Mostly incorrect/missing |
| Sweep results | Live-host list correct and matches lab inventory | Mostly correct | Partial | Missing/incorrect |
| Annotation & reflection | Clear line-by-line annotation + thoughtful legal/illegal reflection | Mostly clear | Partial | Missing |

## Answer key

**Part A**
1. B  2. A  3. C  4. B  5. B  6. C  7. B  8. B  9. B  10. B

**Part B**
11. Command substitution runs a command and gives you back its output so you can store or use it, written `$(command)`. Example: `today=$(date)` stores the current date in `today`. (Accept any correct `$(...)` example such as `myip=$(hostname -I)`.)
12. A hard-coded IP only ever works on that one address; to use a different target you must edit the script. Passing the IP as `$1` makes the script **flexible/reusable** — the same script works on any (lab) address the user supplies at run time, with no editing. The argument version is better for reuse, fewer mistakes, and not having to change code.
13. The bug is the test value: the script checks `[ $? -eq 1 ]`, but `ping` returns exit code **0** when the host **replies** (is up) and non-zero when it does not. So the script prints "UP" exactly when the host is actually down. It should test `[ $? -eq 0 ]` for UP. Also note `$?` must be read immediately after the `ping` line, before any other command overwrites it.
14. Making something a script does not change the law — a ping sweep is still active scanning. The only legal targets are systems you own or have **written permission (authorization)** to test, and only within the agreed **scope** (here, the isolated lab subnet). Automating it just means you could break the law faster. (Accept equivalent wording that uses both terms.)

**Part C**
15. Accept any working equivalent of:
```bash
#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Usage: ./pingone.sh <ip>"
    exit 1
fi
ping -c 1 -W 1 "$1" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "$1 is UP"
else
    echo "$1 is DOWN"
fi
```
Full credit requires: shebang; a check for a missing argument (`$#` or `[ -z "$1" ]`) with a usage message and `exit`; a single, time-limited ping; and an `if` on the exit code (`$?`) choosing UP vs DOWN. Minor style differences (e.g., `[ -z "$1" ]` instead of `[ $# -eq 0 ]`) are fine.
