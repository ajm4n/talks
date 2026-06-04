# Unit 06 Lab — Build a TCP Port Scanner in Python

- **Platform:** Kali Linux VM (from Unit 02), on the **host-only / isolated** lab network only
- **Time:** ~150 minutes total (spread across Days 1, 3, 4, and 5 of the lesson plan)
- **Difficulty:** Beginner

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment. Doing this to any
system you do not own or have written permission to test is illegal.

In this lab that means: the port scanner runs **only** against the single isolated
host-only lab target your instructor assigned (this lab assumes a target on
`192.168.56.0/24` — use whatever your instructor gives you). Writing the tool yourself
does **not** change the law: port scanning a host you do not own or have written
permission to test can violate the CFAA and state law. Before running any network code,
confirm with `ip addr` that your VM is on the host-only adapter. If you are not sure you
are on the right network or pointed at the right target, **stop and ask** first.

## Objectives
- Run Python both interactively (`python3`) and as a script (`python3 file.py`).
- Use variables, types, strings/f-strings, a list, and a dictionary.
- Write `if`/`else` conditionals and a `for` loop.
- Define and call a function with parameters and a return value.
- Import and use the `socket` module with a **timeout**, and catch errors with `try`/`except`.
- Build a working TCP port scanner with clean output, run **only** against the lab target.

## Setup
1. **Log the basics.** In your lab journal, write today's date, your name, the lab target IP your instructor assigned, and the safety reminder above restated in one sentence of your own words.
2. **Confirm your network (do this first, every day).**
   ```bash
   ip addr
   ```
   *Expected:* an address on the agreed lab subnet (e.g., `192.168.56.x`). If you do **not** see it, **stop** — you may be on the wrong adapter. Fix it before running any network code.
3. **Check Python and make a working folder.**
   ```bash
   python3 --version
   mkdir -p ~/unit06 && cd ~/unit06
   ```
   *Expected:* a `Python 3.x.x` line.
4. Open a text editor (`nano scanner.py` or VS Code). Keep the terminal open to run scripts.

## Walkthrough

### Part 1 — Hello, Python (Day 1–2)

**Step 1 — Try interactive mode.**
```bash
python3
```
At the `>>>` prompt, type each line and watch the result:
```python
print("hello")
2 + 2
print("22" + "1")      # text joined -> 221
print(22 + 1)          # numbers added -> 23
exit()
```
*Expected:* `hello`, then `4`, then `221`, then `23`. The third vs fourth line shows why **string** `"22"` is not the **number** `22`.

**Step 2 — Write a banner script.**
```bash
nano hello.py
```
```python
#!/usr/bin/env python3
# hello.py — operator banner
operator = "Jordan Lee"     # put your name
target = input("Target IP for this session: ")
print("==== Port Scanner ====")
print(f"Operator: {operator}")
print(f"Target:   {target}")
```
Run it:
```bash
python3 hello.py
```
*Expected:* it asks for a target (type a **lab** IP), then prints the banner using an **f-string**. If you get an `IndentationError`, check that your lines start at the left margin.

> Paste `hello.py` and a screenshot into your journal. That is **Part 1 complete**.

### Part 2 — The ports list and service dictionary (Day 3)

**Step 3 — Build the data the scanner uses.**
```bash
nano scanner.py
```
```python
#!/usr/bin/env python3
# scanner.py — simple TCP port scanner
# SAFETY: ISOLATED LAB TARGET ONLY. Do not point this anywhere else.

import socket

# Common ports to check
ports = [21, 22, 23, 25, 53, 80, 110, 139, 143, 443, 445, 3306, 3389, 8080]

# Map a port number to a friendly service name
services = {
    21: "ftp", 22: "ssh", 23: "telnet", 25: "smtp", 53: "dns",
    80: "http", 110: "pop3", 139: "netbios", 143: "imap",
    443: "https", 445: "smb", 3306: "mysql", 3389: "rdp", 8080: "http-alt",
}
```

**Step 4 — Loop and print (no network yet).**
Add:
```python
for port in ports:
    name = services.get(port, "unknown")
    print(f"Will check port {port} ({name})")
```
Run it:
```bash
python3 scanner.py
```
*Expected:* one line per port with its service name. `services.get(port, "unknown")` looks up the name and falls back to `"unknown"` if the port isn't in the dictionary.

> Paste the code and output into your journal. That is **Part 2 complete**. (Stopping here still earns full Part 2 credit.)

### Part 3 — Connect, with timeout and error handling (Day 4–5)

**Step 5 — Write the `check_port` function.**
At the top of `scanner.py` (after the `import` line), add a function:
```python
def check_port(ip, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(0.5)              # don't hang on closed ports
    try:
        result = s.connect_ex((ip, port))   # 0 means the port is OPEN
        return result == 0
    except socket.error:
        return False
    finally:
        s.close()
```
- `settimeout(0.5)` gives up after half a second so the scan stays fast.
- `connect_ex` returns **`0`** when the port is **open**; we turn that into `True`/`False`.
- `try`/`except` catches connection errors so one bad port doesn't crash the whole scan.
- `finally` always closes the socket.

**Step 6 — Ask for the target and scan.**
Replace the Step 4 print-loop with a real scan loop:
```python
target = input("Lab target IP to scan: ")
print(f"Scanning {target} (lab target only) ...")

open_ports = []
for port in ports:
    if check_port(target, port):
        name = services.get(port, "unknown")
        print(f"  [+] {port}/tcp open  ({name})")
        open_ports.append(port)

print(f"Done. {len(open_ports)} open port(s): {open_ports}")
```

**Step 7 — Run it against the lab target.**
```bash
python3 scanner.py
```
Enter the **lab target IP** your instructor gave you.
*Expected:* it lists each open port with its service name, then a count and the list. Compare against the known open/closed ports of the lab target. **Lab target only.**

**Step 8 — Save results to a file.**
Add this at the end so results are written out:
```python
with open("scan_results.txt", "w") as f:
    f.write(f"Target: {target}\n")
    f.write(f"Open ports: {open_ports}\n")
print("Saved to scan_results.txt")
```
Run again, then check the file:
```bash
cat scan_results.txt
```
*Expected:* the file contains the target and the open-port list.

> Paste the finished `scanner.py`, a screenshot of it running, the open-port list, and the `scan_results.txt` contents into your journal. Annotate the script line by line. That is **Part 3 complete**.

## Deliverables
Submit your **lab journal pages** containing:
- The safety reminder restated in your own words, and your assigned lab target IP.
- The working `hello.py` and `scanner.py` as pasted text.
- A screenshot of the scanner running.
- The list of **open ports** found, cross-checked against the lab target's known ports.
- The `scan_results.txt` contents.
- A line-by-line annotation of `scanner.py`.
- One reflection sentence: one thing that makes your scanner reliable, and one place it would be **illegal** to run it.

## Stretch goals (optional)
- Read the target from `sys.argv` (command line) instead of `input()`: `python3 scanner.py 192.168.56.10`.
- Let the user enter a port **range** (e.g., 1–1024) using `range()`.
- Time the scan with `time.time()` and print how long it took.
- **Banner grab:** after connecting to an open port, `recv()` a few bytes and print what the service announced. Discuss what that reveals to an attacker.
- Speed it up with `threading` and explain the trade-off (faster, but output can arrive out of order).
- Validate that the target looks like an IP before scanning; reject anything else.

## Answer key (instructor only)

**Finished `hello.py`:**
```python
#!/usr/bin/env python3
# hello.py — operator banner
operator = "Jordan Lee"
target = input("Target IP for this session: ")
print("==== Port Scanner ====")
print(f"Operator: {operator}")
print(f"Target:   {target}")
```

**Finished `scanner.py`:**
```python
#!/usr/bin/env python3
# scanner.py — simple TCP port scanner
# SAFETY: ISOLATED LAB TARGET ONLY. Do not point this anywhere else.

import socket

ports = [21, 22, 23, 25, 53, 80, 110, 139, 143, 443, 445, 3306, 3389, 8080]

services = {
    21: "ftp", 22: "ssh", 23: "telnet", 25: "smtp", 53: "dns",
    80: "http", 110: "pop3", 139: "netbios", 143: "imap",
    443: "https", 445: "smb", 3306: "mysql", 3389: "rdp", 8080: "http-alt",
}


def check_port(ip, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(0.5)
    try:
        result = s.connect_ex((ip, port))   # 0 means OPEN
        return result == 0
    except socket.error:
        return False
    finally:
        s.close()


target = input("Lab target IP to scan: ")
print(f"Scanning {target} (lab target only) ...")

open_ports = []
for port in ports:
    if check_port(target, port):
        name = services.get(port, "unknown")
        print(f"  [+] {port}/tcp open  ({name})")
        open_ports.append(port)

print(f"Done. {len(open_ports)} open port(s): {open_ports}")

with open("scan_results.txt", "w") as f:
    f.write(f"Target: {target}\n")
    f.write(f"Open ports: {open_ports}\n")
print("Saved to scan_results.txt")
```

**`sys.argv` variant for the stretch goal:**
```python
import sys
target = sys.argv[1] if len(sys.argv) > 1 else input("Lab target IP: ")
```

**Teaching notes / expected results:**
- **Python 3 only:** `python3`, `print(...)` with parentheses. Python 2 examples online will mislead students.
- **Indentation is syntax:** mixed tabs/spaces -> `IndentationError`. Standardize on spaces. The function body, `try`/`except`, and loop body must be consistently indented.
- **String vs int ports** is the #1 bug. The `ports` list here is already ints. If students build it from `input()`/`.split()`, those are **strings** and `connect_ex` needs an **int** — convert with `int(p)`. Symptom: a `TypeError` from `connect_ex`.
- **`connect_ex` returns `0` for OPEN** (not `True`). Non-zero or an exception = closed/filtered. Students often invert this; if every port shows "open" or none do, check the `== 0` comparison.
- **Missing/too-long timeout:** without `settimeout`, the scan hangs on closed/filtered ports and looks frozen. `0.5`–`1.0` s is reasonable on a host-only LAN.
- **`try`/`except`:** keeps the scan going if a port refuses or errors. `finally: s.close()` prevents leaking sockets across hundreds of ports.
- **Expected output:** against a Metasploitable-style target you'll typically see ports like 21, 22, 23, 25, 53, 80, 139, 445, 3306 open; against a minimal Linux target maybe just 22 and 80. Cross-check against the inventory you recorded. Closed ports correctly produce no line.
- **Scope check:** before Day 4, verify every VM is on the host-only adapter via `ip addr`. A student on NAT/bridged could scan a real host — stop and fix before any network code.
- Have this finished `scanner.py` ready for stuck students so they can still run it against the lab target and analyze results.
