# Unit 05 — Bash Scripting Basics

- **Module:** Module 1 — Technical Foundations
- **Suggested week:** Week 5
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Bash Scripting

## Learning objectives
By the end of this unit, students can:
- **Explain** why automation matters in security and **give** two examples of repetitive tasks a script can do faster than a human.
- **Write** a runnable Bash script using a shebang (`#!/bin/bash`), make it executable with `chmod +x`, and **run** it with `./script.sh`.
- **Create and use** variables, **read** keyboard input, and **capture** the output of a command with command substitution.
- **Use** positional arguments (`$1`, `$@`, `$#`) to make a script flexible.
- **Write** conditionals with `if`, `test`, and `[ ]`, and **build** `for` and `while` loops.
- **Define and call** a function, and **explain** what an exit code (`$?`) tells you.
- **Combine** small tools with pipes (`|`) to build a useful result.
- **Build** a working **ping sweep** script that reports which hosts are alive on the isolated lab subnet.
- **Apply** the safety rule: scripts that touch a network are run **only** against the isolated lab subnet.

## Standards alignment
- **NICE Framework:** Task T0436 (perform analysis using scripting); K0070 (scripting languages); aligns to Analyze and Securely Provision (software development fundamentals) awareness.
- **CSTA / state CS standards:** 3A-AP-13 (create programs that combine control structures); 3A-AP-16 (design and iteratively develop programs using procedures/functions); 3A-AP-17 (decompose problems into smaller parts); 3B-AP-21 (evaluate and refine code).
- **Security+ domain(s):** 4.0 Operations & Incident Response (scripting/automation for security tasks) awareness.

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Script | A text file full of commands that the computer runs in order, like a recipe. |
| Automation | Letting the computer do a repetitive task for you instead of typing it by hand each time. |
| Bash | The most common Linux command-line shell, and the language we write scripts in this unit. |
| Shebang | The first line of a script (`#!/bin/bash`) that tells the system which program should run the file. |
| Executable | A file the system is allowed to run as a program. You turn this on with `chmod +x`. |
| `chmod` | The "change mode" command that sets file permissions, including whether a file can be run. |
| Variable | A named box that holds a value (text or a number) so you can reuse it. |
| Command substitution | Capturing the output of a command into a variable, written `$(command)`. |
| Argument | Extra information you pass to a script when you run it (the words after the script name). |
| Positional parameter | The numbered slots that hold arguments: `$1` is the first, `$2` the second, `$@` is all of them, `$#` is how many. |
| Conditional | Code that runs only `if` a test is true (`if`/`then`/`else`/`fi`). |
| Test / `[ ]` | The way Bash checks if something is true (e.g., is this number bigger, does this file exist). |
| Loop | Code that repeats: `for` repeats a set number of times, `while` repeats as long as a condition holds. |
| Function | A named, reusable block of code you can call by name. |
| Exit code | A number a command returns when it finishes: `0` means success, anything else means a problem. Stored in `$?`. |
| Pipe | The `|` symbol that sends one command's output straight into the next command's input. |
| Ping sweep | Pinging every address in a range to find out which hosts are alive. |
| Subnet (/24) | A block of 256 IP addresses that share the first three numbers, e.g., `192.168.56.0`–`192.168.56.255`. |
| Host-only network | A virtual network that connects your VMs to each other but **not** to the internet or the school network — our safe sandbox. |

## Materials & prep
- Kali Linux VM (from Unit 02), set on the **host-only / isolated** lab network.
- A second VM or two on the same host-only subnet to act as live targets (e.g., a Metasploitable or a second Linux VM). At least one address that is **down** so the sweep shows both states.
- Projector for live coding; students follow along in their own Kali terminal.
- Lab-journal (physical or digital), continued from earlier units.
- Handout: the Bash quick-reference table (vocabulary + syntax cheat sheet).
- **Instructor prep notes:**
  - Confirm every student VM is on the **host-only** adapter, not NAT/bridged. Verify with `ip addr` that they sit on the agreed lab subnet (this unit assumes `192.168.56.0/24` — change to match your lab and update the lab/answer key accordingly).
  - Record the lab subnet and a list of which addresses are live vs. down so you can check student results.
  - Pre-test the finished ping-sweep script on your own image; ping behavior and flags differ slightly across builds.
  - Re-send the reminder that all network activity stays inside the host-only sandbox; re-state the AUP.

## ⚖️ Ethics & legal callout
**A script does not change the law.** A ping sweep is a scanning technique, and scanning a network you do not own or have written permission to test can violate the CFAA and state law — automating it just means you can break the rules faster. The **only** legal target this week is the isolated host-only lab subnet your instructor assigned.

**Discussion prompt:** "A one-line loop can ping all 254 addresses on a network in seconds. Why does the speed and ease of automation make the authorization rule *more* important, not less? What could go wrong if a student pointed this script at the school Wi-Fi 'just to test it'?"

## Lesson sequence

### Day 1 — Why automate, and your first script
- **Warm-up (5–10 min):** Bell question: "What is a boring task on a computer you've done the same way 20 times in a row?" Share a few; connect to automation.
- **Direct instruction (15–20 min):** Why automation matters in security (consistency, speed, fewer mistakes, repeatability for reports). Anatomy of a script: the **shebang** `#!/bin/bash`, comments with `#`, and `echo`. How a script becomes runnable: `chmod +x script.sh` then `./script.sh`. Why `./` is needed.
- **Guided practice (15 min):** Live-code a "hello" script together. Students create `hello.sh` in a text editor (nano or VS Code), add the shebang, an `echo`, save, `chmod +x`, run it.
- **Independent practice / lab:** Begin **Lab Part 1** — a recon-banner script that prints the student's name, the date (using command substitution `$(date)`), and the machine's IP.
- **Closure / exit ticket (5 min):** "What two commands turn a text file into a program you can run?"

### Day 2 — Variables, input, and command substitution
- **Warm-up (5–10 min):** Predict-the-output: show a 3-line script with a variable and `echo`; students write what it prints.
- **Direct instruction (15–20 min):** Variables (`name="value"`, no spaces around `=`), using them with `$name` and `"${name}"`, why quotes matter. Reading input with `read`. **Command substitution** `$(...)` to store a command's result. The difference between a variable and a literal.
- **Guided practice (15 min):** Build a script that asks the user's name with `read`, stores `$(hostname)` in a variable, and greets them. Debug a deliberately broken version together (e.g., a space around `=`).
- **Independent practice / lab:** Extend the recon-banner to ask for and store input. Save journal notes on each new piece of syntax.
- **Closure / exit ticket (5 min):** "Write the line that stores today's date in a variable named `today`."

### Day 3 — Arguments and conditionals
- **Warm-up (5–10 min):** "Why is it better to pass an IP *to* a script than to hard-code one IP inside it?" Quick share.
- **Direct instruction (15–20 min):** Positional parameters: `$1`, `$2`, `$@`, `$#`. Conditionals: `if`/`then`/`else`/`fi`, the `test` command and `[ ]`, comparing numbers (`-eq`, `-lt`, `-gt`) and checking results. **Exit codes**: every command returns one, `0` = success; `ping` returns `0` if a host replied. Reading `$?`.
- **Guided practice (15 min):** Together, write a script that takes one argument and uses an `if` to check it was provided (`if [ $# -eq 0 ]`) before continuing.
- **Independent practice / lab:** Begin **Lab Part 2** — a script that takes an IP as `$1`, pings it once, and uses `if` on the exit code to print "UP" or "DOWN." **Targets: lab subnet only.**
- **Closure / exit ticket (5 min):** "After a command runs, where is its exit code stored, and what number means success?"

### Day 4 — Loops, functions, and pipes
- **Warm-up (5–10 min):** Predict-the-output of a short `for i in 1 2 3` loop.
- **Direct instruction (15–20 min):** `for` loops (including `for i in $(seq 1 254)`), `while` loops. **Functions**: define once, call by name; passing arguments to a function. **Pipes**: chaining commands, e.g., `ping ... | grep ...`. How the ping-sweep logic comes together: loop over the last octet, ping each, test the result, print live hosts.
- **Guided practice (15 min):** Live-code a loop that prints `192.168.56.1` through `192.168.56.5`. Then wrap the "ping one host" logic from Day 3 into a function.
- **Independent practice / lab:** Begin **Lab Part 3** — assemble the **ping sweep** over the lab /24 using the loop + function + conditional. **Targets: lab subnet only.**
- **Closure / exit ticket (5 min):** "Write a `for` line that loops the numbers 1 through 254."

### Day 5 — Finish, test, and document the ping sweep
- **Warm-up (5–10 min):** Restate the safety rule in one sentence: which subnet, and why only that one.
- **Direct instruction (10–15 min):** Making output clean and readable; adding comments; using a faster ping (`-c 1 -W 1`) so the sweep doesn't hang on dead hosts; a quick note on running ping checks in the background for speed (extension only).
- **Guided practice (15 min):** Class compares results: which addresses came back live? Cross-check against the known lab inventory. Troubleshoot common bugs (quoting, exit-code logic, the wrong subnet).
- **Independent practice / assessment:** Finalize the ping-sweep script, run it against the lab subnet, and record the live-host list in the journal. Complete the Unit 05 quiz (see `assessment.md`).
- **Closure / exit ticket (5 min):** "Name one task from this week you could now automate, and one place it would be illegal to run it."

## Differentiation
- **Support:** Provide a fill-in-the-blank script skeleton for each lab part with the tricky lines (`#!/bin/bash`, the `if [ ... ]` line) pre-written and a blank to complete. Give a syntax cheat-sheet taped into the journal. Allow pair programming. Offer a "one-host pinger" stopping point that still earns full Part 2 credit before attempting the full sweep.
- **Extension:** Have advanced students add command-line arguments to choose the subnet, count live hosts at the end, write results to a file, run pings in parallel (`&` + `wait`) and explain the speed difference, or pipe the live list into a follow-up command. Challenge: add input validation that rejects anything that isn't a valid IP.

## Homework / independent work
- Finish any unfinished lab part; paste the script text and a screenshot of it running into the lab journal.
- Journal prompt: "Explain command substitution in your own words and give one example."
- Annotate the finished ping-sweep script line by line in the journal (what each line does).

## Assessment
- **Formative:** Daily exit tickets; predict-the-output warm-ups; in-class debugging participation; checkpoint check of each working lab part.
- **Summative:** Unit 05 quiz, the three working scripts, and the annotated lab journal — see `assessment.md`.

## Instructor notes & common pitfalls
- **The space-around-`=` bug** is the #1 beginner error: `name = "x"` fails, `name="x"` works. Expect it and teach it early.
- Quoting trips students up: encourage `"$var"` with quotes to avoid surprises.
- `ping` flags differ: on Kali use `ping -c 1 -W 1 <ip>` (count 1, 1-second timeout). Without a timeout the sweep hangs on dead hosts and students think it's broken.
- Watch for students who hard-code one IP instead of using `$1` — push them to use the argument.
- The most important pitfall is **scope**: confirm everyone's VM is on the host-only adapter before Day 3. A student on NAT/bridged could accidentally sweep a real network. Check `ip addr` output. If anyone is on the wrong adapter, stop and fix it before any network command runs.
- Have the backup script in the answer key ready for students who get stuck so they can still complete and analyze the sweep.
- Remind students that a script is just typed commands — everything they learned in Unit 04 still applies.
