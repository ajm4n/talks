---
marp: true
theme: bootstrap
paginate: true
header: "Introduction to Offensive Security · Unit 06"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Python for Security
## Unit 06 — Technical Foundations

Last week you scripted in Bash. This week, same ideas — variables, loops, functions — in a language real security tools are written in.

<!-- Week 6, ~5 class periods. Builds straight on Unit 05. Big payoff is a working TCP port scanner. Scope check (host-only adapter) is the #1 safety pitfall — verify before Day 4. -->

---

# Learning objectives

By the end of this unit you can:

- **Explain** why Python is popular in security.
- **Run** Python two ways: interactive (`python3`) and a script (`python3 file.py`).
- **Use** variables and **types** (`str`, `int`, `float`, `bool`); convert between them.
- **Work with** strings, lists, and dictionaries.
- **Write** `if`/`elif`/`else` and `for`/`while` loops.
- **Define** a function with parameters and a `return`.
- **Import** a module (`socket`) and use `try`/`except`.
- **Build** a working **TCP port scanner** for the isolated lab target.

---

# Why Python?

- **Readable** — looks almost like English.
- **Huge library ecosystem** — networking, web, crypto, all built in.
- Real tools and exploit proof-of-concepts are written in it (Impacket, many PoCs).
- **Cross-platform** — same code on Kali, macOS, Windows.

> Bash glues commands together; Python builds the **tools** themselves.

<!-- Warm-up: "You learned Bash last week. Why would a security pro also learn Python?" -->

---

# Two ways to run Python

**Interactive (REPL)** — type one line, see the result instantly:

```python
python3
>>> 2 + 2
4
>>> print("hello")
hello
>>> exit()
```

**Script** — a `.py` file that runs top to bottom:

```bash
python3 hello.py
```

<!-- Exit ticket: "Name the two ways to run Python and one difference between them." -->

---

# Python is not Bash

| | Bash | Python |
|--|------|--------|
| Variable use | `$name` | `name` |
| Print | `echo` | `print(...)` |
| Indentation | cosmetic | **syntax!** |
| Version | — | use **`python3`** |

⚠️ Indentation **is the code** in Python. Mixed tabs/spaces → `IndentationError`. Pick spaces and stick with it.

<!-- teacher note: Python 3 only. Old tutorials show Python 2 (print without parens) — warn students. -->

---

# Variables & types

```python
name = "Jordan"      # str  (text)
port = 22            # int  (whole number)
timeout = 0.5        # float (decimal)
is_open = True       # bool (True / False)

print(type(port))    # <class 'int'>
```

Convert between them with `int()` and `str()`:

```python
int("22") + 1        # 23
str(22) + "1"        # "221"
```

<!-- Warm-up: predict print("22" + "1") vs print(22 + 1). Text join = 221, numbers add = 23. -->

---

# Strings & f-strings

```python
text = "22,80,443"
text[0]          # '2'  (index one character)
text[0:2]        # '22' (slice a piece)
text.split(",")  # ['22', '80', '443']

p = 80
print(f"Port {p} is open")   # f-string plugs values in
```

> An **f-string** lets you drop a variable straight into text with `{ }`.

⚠️ `"22"` (text) is **not** `22` (number) — this matters for ports later!

---

# Lists & dictionaries

```python
ports = [21, 22, 80, 443]      # ordered list
ports.append(8080)             # add to it
ports[0]                       # 21

services = {22: "ssh", 80: "http"}   # key: value pairs
services[22]                         # "ssh"
services.get(443, "unknown")         # safe lookup w/ fallback
```

- **List** `[ ]` — an ordered collection.
- **Dictionary** `{ }` — look things up by key.

<!-- Warm-up: "How would you store ports 22, 80, 443 together?" -> reveal lists. -->

---

# Conditionals & loops

```python
for port in ports:
    if port == 22:
        print(f"{port} is SSH")
    elif port == 80:
        print(f"{port} is HTTP")
    else:
        print(f"{port} is something else")
```

- `if` / `elif` / `else` — branch on a test.
- `for` loops over a collection; `while` loops while a condition holds.
- A port scanner is really just: **loop a list of ports → decide open or closed.**

---

# Functions

```python
def check_port(ip, port):
    # ... do the work ...
    return True       # hand a result back

if check_port("192.168.56.10", 22):
    print("open!")
```

- `def` defines a reusable, named block.
- **Parameters** (`ip`, `port`) are inputs; `return` hands a value back.
- Define once, call as many times as you like.

<!-- Builds on Bash functions from last week — same idea, new syntax. -->

---

# The socket module & try/except

```python
import socket

def check_port(ip, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(0.5)                  # don't hang on closed ports
    try:
        result = s.connect_ex((ip, port))  # 0 == OPEN
        return result == 0
    except socket.error:
        return False
    finally:
        s.close()
```

- `import` brings in ready-made code (`socket` = network connections).
- `connect_ex` returns **`0`** when the port is **open**.
- `try`/`except` **catches errors** so one bad port doesn't crash the scan.

<!-- teacher note: String-vs-int port is the #1 logic bug — connect_ex needs an int. Missing settimeout makes it hang. connect_ex returns 0 for open, not True. -->

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

## Writing the tool yourself does not change the law.

A port scanner is a **real scanning tool** — building it in Python instead of running `nmap` makes no legal difference.

Port scanning a host you don't own or have written permission to test can violate the **CFAA** and state law.

**The only legal target this week: the single isolated host-only lab target.** Confirm with `ip addr` *before every* network run.

<!-- Discussion: "In ~20 lines you can check every port. Why does making the tool yourself NOT change who you may point it at?" What's the difference between writing a scanner and running it on a target? -->

---

# Key vocabulary

| Term | Meaning |
|------|---------|
| **Interpreter / REPL** | `python3` runs code / live one-line prompt |
| **Type** | `str`, `int`, `float`, `bool` |
| **f-string** | Text with values plugged in: `f"Port {p}"` |
| **List / Dictionary** | `[22, 80]` / `{22: "ssh"}` |
| **Function** | Reusable block via `def`, takes inputs, `return`s |
| **Module** | Ready-made code you `import` (e.g., `socket`) |
| **Port / Timeout** | A service's numbered door / limit before giving up |
| **Exception / `try`-`except`** | A runtime error / catch it and keep going |

---

# Lab launch: build a port scanner

**Platform:** your **Kali VM** on the **host-only / isolated** lab network.

First, every day:

```bash
ip addr            # confirm you're on the lab subnet (192.168.56.x)
python3 --version  # Python 3.x.x
mkdir -p ~/unit06 && cd ~/unit06
```

You'll build, in parts:
1. **`hello.py`** — operator banner (variables, `input()`, f-strings)
2. **`scanner.py` data** — the `ports` list + `services` dictionary
3. **`scanner.py` scan** — `check_port()` + loop → list open ports, save to file

> If `ip addr` doesn't show your lab subnet, **stop and ask** before running anything.

<!-- Scope check before Day 4: a student on NAT/bridged could scan a real host. Have the answer-key scanner ready for stuck students. -->

---

# The scanner, assembled

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

> Loop the ports → call the function → collect & print the open ones.

---

# Recap

- Python runs **interactively** or as a **script** — `python3`, indentation is syntax.
- **Types** matter: `"22"` (str) ≠ `22` (int). Convert with `int()`/`str()`.
- **Lists** `[ ]` and **dictionaries** `{ }` hold your data.
- **Functions** (`def` … `return`) + `if`/`for` build the logic.
- `socket` + **timeout** + `try`/`except` = a reliable scanner.
- Same skills as Bash week, new language — and **authorization still rules.**

---

<!-- _class: lead -->

# Exit ticket & discussion

1. Name the two ways to run Python and one difference.
2. What does `connect_ex` returning `0` mean — and why use a timeout?
3. What does `try`/`except` let your program do when an error happens?

**Discuss:** Name one thing your scanner does that makes it **reliable** — and one place it would be **illegal** to run it.

*Submit `hello.py`, `scanner.py`, a screenshot running, your open-port list, and `scan_results.txt`.*
