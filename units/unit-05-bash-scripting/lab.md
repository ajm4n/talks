# Unit 05 Lab — Build a Ping Sweep in Bash

- **Platform:** Kali Linux VM (from Unit 02), on the **host-only / isolated** lab network only
- **Time:** ~150 minutes total (spread across Days 1, 3, 4, and 5 of the lesson plan)
- **Difficulty:** Beginner

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment. Doing this to any
system you do not own or have written permission to test is illegal.

In this lab that means: every network command (`ping`, the ping sweep) runs **only**
against the isolated host-only lab subnet your instructor assigned (this lab assumes
`192.168.56.0/24` — use whatever your instructor gives you). A script does **not** change
the law: scanning a network you do not own or have written permission to test can violate
the CFAA and state law, and automation just lets you break the rules faster. Before any
network command, confirm with `ip addr` that your VM is on the host-only adapter. If you
are not sure you are on the right network, **stop and ask** before running anything.

## Objectives
- Write a runnable Bash script with a shebang, make it executable, and run it.
- Use variables, keyboard input (`read`), and command substitution (`$(...)`).
- Use a positional argument (`$1`) and check it was provided.
- Use an `if` conditional on a command's **exit code** to make a decision.
- Build `for`/`while` loops and a **function**, and combine them into a working ping sweep.
- Apply the safety rule: run network scripts **only** against the isolated lab subnet.

## Setup
1. **Log the basics.** In your lab journal, write today's date, your name, the lab subnet your instructor assigned, and the safety reminder above restated in one sentence of your own words.
2. **Confirm your network (do this first, every day).** In a Kali terminal:
   ```bash
   ip addr
   ```
   *Expected:* an address on the agreed lab subnet (e.g., `192.168.56.x`). If you do **not** see a `192.168.56.x` (or your instructor's) address, **stop** — you may be on the wrong adapter. Fix it before running any network command.
3. **Make a working folder** so your scripts stay together:
   ```bash
   mkdir -p ~/unit05 && cd ~/unit05
   ```
4. Open a text editor for writing scripts. `nano hello.sh` works everywhere; VS Code is fine too. Keep the terminal open to run what you write.

## Walkthrough

### Part 1 — A recon-banner script (Day 1–2)

**Step 1 — Create the file and add a shebang.**
```bash
nano banner.sh
```
Type the following:
```bash
#!/bin/bash
# banner.sh — prints a simple recon banner
echo "==== Recon Banner ===="
echo "Operator: <put your name here>"
```
Save and exit (in nano: `Ctrl+O`, `Enter`, then `Ctrl+X`).

**Step 2 — Make it executable and run it.**
```bash
chmod +x banner.sh
./banner.sh
```
*Expected output:* the two banner lines print. If you get `Permission denied`, you forgot `chmod +x`. If you get `command not found`, you forgot the `./` in front.

**Step 3 — Add the date with command substitution.**
Edit `banner.sh` and add a line that captures the date into a variable, then prints it:
```bash
today=$(date)
echo "Date: $today"
```
Run it again. *Expected:* a `Date:` line with the current date and time.

**Step 4 — Add the machine's IP and ask for input.**
Add these lines:
```bash
myip=$(hostname -I)
echo "This machine: $myip"
read -p "What target are you working on today? " target
echo "Target for this session: $target"
```
Run it. *Expected:* it prints your IP, then pauses and waits for you to type a target, then echoes it back. Type a **lab** address only.

> Save `banner.sh` and paste the script text + a screenshot of it running into your journal. That is **Part 1 complete**.

### Part 2 — Ping one host (Day 3)

**Step 5 — Take the IP as an argument.**
```bash
nano pingone.sh
```
```bash
#!/bin/bash
# pingone.sh — ping one lab host given as the first argument
# SAFETY: lab subnet only.

if [ $# -eq 0 ]; then
    echo "Usage: ./pingone.sh <ip>"
    exit 1
fi

target=$1
echo "Pinging $target ..."
```
`$#` is how many arguments you gave; `$1` is the first one. The `if` stops the script with `exit 1` (a non-zero exit code = problem) when no IP was given.

**Step 6 — Ping it and check the exit code.**
Add:
```bash
ping -c 1 -W 1 "$target" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "$target is UP"
else
    echo "$target is DOWN"
fi
```
- `-c 1` sends **one** ping; `-W 1` waits at most **1 second** so the script doesn't hang on dead hosts.
- `> /dev/null 2>&1` throws away ping's own output so we only see our message.
- `$?` is the exit code of the last command. `ping` returns `0` when the host replied.

**Step 7 — Run it against the lab.**
```bash
chmod +x pingone.sh
./pingone.sh 192.168.56.1      # a known-live lab address from your instructor
./pingone.sh 192.168.56.250    # a known-down lab address
```
*Expected:* the first prints `UP`, the second `DOWN` (after about a 1-second pause). **Lab addresses only.**

> Paste the script and both runs into your journal. That is **Part 2 complete**. (Stopping here still earns full Part 2 credit.)

### Part 3 — The ping sweep (Day 4–5)

**Step 8 — Turn "ping one" into a function.**
```bash
nano sweep.sh
```
```bash
#!/bin/bash
# sweep.sh — ping sweep of a lab /24, reports live hosts
# SAFETY: ISOLATED LAB SUBNET ONLY. Do not point this anywhere else.

subnet="192.168.56"     # change only to your assigned lab subnet

check_host() {
    ping -c 1 -W 1 "$1" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$1 is UP"
    fi
}
```
A **function** lets you name the "ping one host" logic and reuse it. `$1` inside the function is the argument **passed to the function**.

**Step 9 — Loop over the /24.**
Add a loop that calls the function for every address `1`–`254`:
```bash
echo "Sweeping $subnet.0/24 (lab only) ..."
for host in $(seq 1 254); do
    check_host "$subnet.$host"
done
echo "Sweep complete."
```
`seq 1 254` produces the numbers 1 through 254; the loop builds each full address like `192.168.56.7` and checks it.

**Step 10 — Run the sweep against the lab subnet.**
```bash
chmod +x sweep.sh
./sweep.sh
```
*Expected:* after a short wait it lists only the **UP** hosts on the lab subnet, then `Sweep complete.` Compare the live list to the inventory your instructor gave you.

> Paste the finished `sweep.sh`, a screenshot of it running, and the **list of live hosts** into your journal. Annotate the script line by line in your own words. That is **Part 3 complete**.

## Deliverables
Submit your **lab journal pages** containing:
- The safety reminder restated in your own words, and your assigned lab subnet.
- The three working scripts (`banner.sh`, `pingone.sh`, `sweep.sh`) as pasted text.
- A screenshot of each script running.
- The list of **live hosts** your sweep found, cross-checked against the lab inventory.
- A line-by-line annotation of `sweep.sh` explaining what each line does.
- One reflection sentence: one task you could now automate, and one place it would be **illegal** to run this script.

## Stretch goals (optional)
- Add an argument so the user picks the subnet: `./sweep.sh 192.168.56` instead of hard-coding it. Validate that the argument looks like the first three octets of an IP.
- Count and print the **total number of live hosts** at the end (hint: a counter variable).
- Write the live-host list to a file with `>` and timestamp it with `$(date)`.
- Speed it up by backgrounding each ping with `&` and using `wait`. Explain why it's faster and one downside (output can arrive out of order).
- Reject input that isn't a valid IP before pinging it.

## Answer key (instructor only)

**Finished `banner.sh`:**
```bash
#!/bin/bash
# banner.sh — prints a simple recon banner
echo "==== Recon Banner ===="
echo "Operator: Jordan Lee"
today=$(date)
echo "Date: $today"
myip=$(hostname -I)
echo "This machine: $myip"
read -p "What target are you working on today? " target
echo "Target for this session: $target"
```

**Finished `pingone.sh`:**
```bash
#!/bin/bash
# pingone.sh — ping one lab host given as the first argument
# SAFETY: lab subnet only.

if [ $# -eq 0 ]; then
    echo "Usage: ./pingone.sh <ip>"
    exit 1
fi

target=$1
echo "Pinging $target ..."
ping -c 1 -W 1 "$target" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "$target is UP"
else
    echo "$target is DOWN"
fi
```

**Finished `sweep.sh`:**
```bash
#!/bin/bash
# sweep.sh — ping sweep of a lab /24, reports live hosts
# SAFETY: ISOLATED LAB SUBNET ONLY. Do not point this anywhere else.

subnet="192.168.56"     # change only to your assigned lab subnet

check_host() {
    ping -c 1 -W 1 "$1" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$1 is UP"
    fi
}

echo "Sweeping $subnet.0/24 (lab only) ..."
for host in $(seq 1 254); do
    check_host "$subnet.$host"
done
echo "Sweep complete."
```

**Faster (parallel) variant for the stretch goal:**
```bash
for host in $(seq 1 254); do
    check_host "$subnet.$host" &
done
wait
```

**Teaching notes / expected results:**
- **Space-around-`=` bug** is the #1 error: `subnet = "..."` fails; it must be `subnet="..."`. Expect it.
- **Quoting:** `"$target"` and `"$1"` should be quoted; teach why even if it "works" unquoted in the lab.
- **Exit-code logic:** `ping` returns `0` on reply. If a student inverts the `if` (treats `0` as down), every result will be backwards — a good debugging lesson. `$?` must be read **immediately** after the command, before any other command overwrites it.
- **The hang:** without `-W 1`, dead hosts make the sweep crawl and students think it froze. Confirm everyone uses `-c 1 -W 1`.
- **Scope check:** before Day 3, verify every VM is on the host-only adapter via `ip addr`. A student on NAT/bridged could sweep a real network — stop and fix before any network command.
- **Expected sweep output:** only the live lab addresses appear (e.g., the gateway `.1`, plus the target VMs you stood up). Down addresses correctly produce no line. Cross-check against your recorded lab inventory.
- **`hostname -I`** prints the IP(s); on some images it has a trailing space — harmless. `hostname -i` may differ; `-I` (capital) is preferred.
- Have these finished scripts ready to hand to any student who is stuck so they can still run and analyze the sweep against the lab subnet.
