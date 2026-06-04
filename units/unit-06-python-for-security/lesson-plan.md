# Unit 06 — Python for Security

- **Module:** Module 1 — Technical Foundations
- **Suggested week:** Week 6
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** PEN-200 assumes you can code; this unit teaches the Python basics PEN-200 takes for granted, aimed at security tasks.

## Learning objectives
By the end of this unit, students can:
- **Explain** why Python is popular in security and **give** two examples of security tasks Python automates.
- **Run** Python two ways: the **interactive** interpreter (`python3`) and a **script** (`python3 file.py`).
- **Create and use** variables of different **types** (string, integer, float, boolean) and **convert** between them.
- **Work with strings** (indexing, slicing, `.split()`, f-strings) and **build** lists and dictionaries.
- **Write** `if`/`elif`/`else` conditionals and `for`/`while` loops.
- **Define and call** a **function** with parameters and a return value.
- **Import** and use a module (e.g., `socket`), and **read/write** a file.
- **Use** `try`/`except` to handle errors instead of crashing.
- **Build** a working **TCP port scanner** that checks a list of ports on a single isolated lab target, with timeouts and clean output.
- **Apply** the safety rule: scanning runs **only** against the isolated lab target.

## Standards alignment
- **NICE Framework:** K0070 (scripting/programming languages); T0436 (perform analysis using scripting); Securely Provision (software development fundamentals) awareness.
- **CSTA / state CS standards:** 3A-AP-13 (combine control structures); 3A-AP-14 (use lists/collections to store and process data); 3A-AP-16 (design programs using procedures with parameters); 3A-AP-17 (decompose problems); 3A-AP-18 (create artifacts with practical/personal value); 3B-AP-21 (evaluate and refine code).
- **Security+ domain(s):** 4.0 Operations & Incident Response (scripting/automation) awareness.

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Python | A popular, readable programming language used widely in security for tools and automation. |
| Interpreter | The program (`python3`) that runs Python code line by line. |
| Interactive mode (REPL) | A live Python prompt where you type one line at a time and see the result instantly. |
| Script | A `.py` file full of Python code that runs top to bottom with `python3 file.py`. |
| Variable | A named box that holds a value. |
| Type | What kind of value something is: `str` (text), `int` (whole number), `float` (decimal), `bool` (True/False). |
| String | Text, written in quotes, e.g., `"22"` — note it is text, not the number 22. |
| f-string | A string with values plugged in, written `f"Port {p} is open"`. |
| List | An ordered collection in square brackets, e.g., `[22, 80, 443]`. |
| Dictionary | A collection of `key: value` pairs in curly braces, e.g., `{22: "ssh"}`. |
| Index / slice | Getting one item (`text[0]`) or a piece (`text[0:3]`) out of a string or list. |
| Conditional | Code that runs only `if` a test is true (`if`/`elif`/`else`). |
| Loop | Code that repeats: `for` over a collection, `while` as long as a condition holds. |
| Function | A named, reusable block of code defined with `def`, often taking inputs and returning a result. |
| Module | A bundle of ready-made code you bring in with `import` (e.g., `socket`, `sys`). |
| `socket` | The built-in module Python uses to make network connections. |
| Port | A numbered "door" on a host where a service listens (e.g., 22 = SSH, 80 = HTTP). |
| Timeout | A limit on how long to wait for a connection before giving up, so the program doesn't hang. |
| Exception | An error that happens while the program runs (e.g., connection refused). |
| `try`/`except` | A way to **catch** an exception and keep going instead of crashing. |
| Port scanner | A program that checks which ports on a host are open. |
| Host-only network | A virtual network connecting your VMs to each other but **not** the internet or school network — our safe sandbox. |

## Materials & prep
- Kali Linux VM (from Unit 02) on the **host-only / isolated** lab network. Python 3 is preinstalled (`python3 --version`).
- One lab **target** VM on the same host-only subnet with a couple of known open ports (e.g., Metasploitable, or a Linux VM running SSH on 22 and a web server on 80). Record which ports are open vs closed so you can check student output.
- Projector for live coding; students follow along in their own terminal.
- Lab journal (continued from earlier units).
- Handout: Python quick-reference (vocabulary + syntax cheat sheet).
- **Instructor prep notes:**
  - Confirm `python3` runs for every student; we use **Python 3** (`python3`, not `python`).
  - Confirm every VM is on the **host-only** adapter; verify with `ip addr` on the agreed lab subnet (this unit assumes `192.168.56.0/24` — change to match your lab and update the lab/answer key).
  - Stand up and record the target's IP and its open/closed ports for cross-checking results.
  - Pre-run the finished port scanner against your target so you know the expected output.
  - Re-send the reminder that all network activity stays inside the host-only sandbox; re-state the AUP.

## ⚖️ Ethics & legal callout
**A port scanner is a real scanning tool, and the language doesn't matter.** Writing it in Python instead of running `nmap` does not make scanning a network you don't own or have permission to test any more legal — port scanning without authorization can violate the CFAA and state law. The **only** legal target this week is the single isolated lab host your instructor assigned.

**Discussion prompt:** "In about 20 lines of Python you can check every port on a host. Why does making a tool *yourself*, from scratch, not change anything about who you're allowed to point it at? What's the difference between writing a scanner and *running* it against a target?"

## Lesson sequence

### Day 1 — Why Python, and running it
- **Warm-up (5–10 min):** Bell question: "You learned Bash last week. Why might a security pro also learn Python?" Quick share.
- **Direct instruction (15–20 min):** Why Python in security (readable, huge library ecosystem, used by real tools like Impacket and many exploit PoCs, cross-platform). Two ways to run it: **interactive** (`python3`, type and see results live) vs a **script** (`python3 scan.py`). `print()`. Comments with `#`. The difference from Bash (indentation matters; no `$` on variables).
- **Guided practice (15 min):** Open `python3`, do live math and `print("hello")` in the REPL. Then create `hello.py` and run it as a script. Show that indentation errors are real errors.
- **Independent practice / lab:** Begin **Lab Part 1** — `hello.py` that prints a banner with the operator's name and a target (entered with `input()`).
- **Closure / exit ticket (5 min):** "Name the two ways to run Python and one difference between them."

### Day 2 — Variables, types, and strings
- **Warm-up (5–10 min):** Predict-the-output of `print("22" + "1")` vs `print(22 + 1)`. Discuss why one is `221` and one is `23`.
- **Direct instruction (15–20 min):** Variables and **types** (`str`, `int`, `float`, `bool`); `type()`; converting with `int()`/`str()`. Strings: indexing/slicing, `.split()`, `.strip()`, and **f-strings** (`f"Port {p}"`). Why `"22"` (text) is different from `22` (number) — important for ports later.
- **Guided practice (15 min):** In the REPL, slice a string, split `"22,80,443"` into a list, and build an f-string status message.
- **Independent practice / lab:** Extend `hello.py` to print a formatted f-string summary using variables. Journal each new piece of syntax.
- **Closure / exit ticket (5 min):** "Write an f-string that prints `Scanning <target>` using a variable named `target`."

### Day 3 — Lists, dictionaries, conditionals, and loops
- **Warm-up (5–10 min):** "How would you store the ports 22, 80, and 443 together in one variable?" Share guesses, then reveal lists.
- **Direct instruction (15–20 min):** **Lists** (create, index, append, loop over). **Dictionaries** (`{22: "ssh", 80: "http"}`, look up by key). `if`/`elif`/`else`. `for` loops over a list; `while` loops. How a port scanner is really just "loop over a list of ports and decide open/closed."
- **Guided practice (15 min):** Build a list of common ports, loop over it with `for`, and use `if` to print a different message for port 22 vs the rest. Add a dictionary mapping ports to service names.
- **Independent practice / lab:** Begin **Lab Part 2** — define the `ports` list and the port→service dictionary the scanner will use, and loop/print them. **No network yet.**
- **Closure / exit ticket (5 min):** "Write the line that gets the service name for port 80 out of a dictionary named `services`."

### Day 4 — Functions, the socket module, and exceptions
- **Warm-up (5–10 min):** "Last week's Bash sweep checked if a host was *up*. This week we check if a *port* is open. What's the difference?" Quick share (host alive vs a specific service door open).
- **Direct instruction (15–20 min):** **Functions** with `def`, parameters, and `return`. **Importing modules** (`import socket`, `import sys`). The `socket` basics: create a socket, `settimeout()` (so it doesn't hang), `connect_ex((ip, port))` returns `0` if the port is **open**. **`try`/`except`** to catch connection errors so the program keeps going instead of crashing.
- **Guided practice (15 min):** Live-code a `check_port(ip, port)` function that returns `True`/`False`, wrapped in `try`/`except`, with a timeout. Test it against the lab target on one known-open port.
- **Independent practice / lab:** Begin **Lab Part 3** — assemble the scanner: loop the port list, call `check_port`, print open ports with their service names. **Target: the single lab host only.**
- **Closure / exit ticket (5 min):** "What does `try`/`except` let your program do when an error happens?"

### Day 5 — Finish, harden, and document the scanner
- **Warm-up (5–10 min):** Restate the safety rule in one sentence: which host, and why only that one.
- **Direct instruction (10–15 min):** Clean output (counts, sorted ports, f-strings); reading the target from `input()` or `sys.argv`; saving results to a **file** with `open(...)`. Why timeouts and `try`/`except` make the tool reliable.
- **Guided practice (15 min):** Class compares results against the known open/closed ports of the lab target. Troubleshoot common bugs (string vs int ports, missing timeout, wrong indentation).
- **Independent practice / assessment:** Finalize the scanner, run it against the **lab target only**, record the open-port list in the journal, write results to a file. Complete the Unit 06 quiz (see `assessment.md`).
- **Closure / exit ticket (5 min):** "Name one thing your scanner does that makes it reliable, and one place it would be illegal to run it."

## Differentiation
- **Support:** Provide a fill-in-the-blank `scanner.py` skeleton with the tricky lines (the `socket` setup, the `try`/`except`, the function header) pre-written and blanks to complete. Tape a Python syntax cheat-sheet into the journal. Allow pair programming. Offer a "single-port checker" stopping point that still earns full Part 2/3 credit before the full loop. Give a Python-vs-Bash translation table (variables, loops, if) since they just learned Bash.
- **Extension:** Read the port list from a file or `sys.argv`; let the user enter a port **range**; time the scan and print how long it took; show banner-grabbing (read a few bytes the service sends back) and discuss what that reveals; reimplement with concurrency (`threading`) and explain the speed/ordering trade-off; add input validation that rejects a non-IP target.

## Homework / independent work
- Finish any unfinished lab part; paste the code and a screenshot of it running into the lab journal.
- Journal prompt: "Explain in your own words what `connect_ex` returning `0` means, and why we use a timeout."
- Annotate the finished `scanner.py` line by line in the journal.

## Assessment
- **Formative:** Daily exit tickets; predict-the-output warm-ups; in-class debugging participation; checkpoint check of each working lab part.
- **Summative:** Unit 06 quiz, the working port scanner, and the annotated lab journal — see `assessment.md`.

## Instructor notes & common pitfalls
- **Python 3 only.** Use `python3` and `print(...)` with parentheses. Some old tutorials show Python 2 (`print` without parens) — warn students.
- **Indentation is syntax** in Python (not cosmetic like Bash). Mixed tabs/spaces cause `IndentationError`. Pick spaces and stick to it.
- **String vs int ports** is the #1 logic bug: `socket` needs an **int** port. If a port came from `input()` or a `split()`, it's a string and must be `int()`-converted.
- **Missing timeout** makes the scanner hang on filtered/closed ports — always `settimeout()` (e.g., `0.5`–`1.0` seconds).
- `connect_ex` returns **`0` for open**; a non-zero value (or an exception) means closed/unreachable. Students often expect `True`/`False` — clarify.
- Wrap socket calls in `try`/`except` so one bad port doesn't crash the whole scan.
- **Scope is the most important pitfall:** confirm everyone's VM is on the host-only adapter (`ip addr`) before Day 4. A student on NAT/bridged could scan a real host. Stop and fix before any network code runs.
- Have the answer-key scanner ready for stuck students so they can still run it against the lab target and analyze results.
- Remind students this builds directly on Bash week — same ideas (variables, loops, functions, conditionals), new language.
