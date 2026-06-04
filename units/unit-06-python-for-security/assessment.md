# Unit 06 Assessment — Python for Security

## Formative checks
- **Daily exit tickets** (one per day from the lesson plan): the two ways to run Python; an f-string with a variable; getting a value out of a dictionary; what `try`/`except` does; one thing that makes the scanner reliable + one illegal place to run it.
- **Predict-the-output warm-ups** (Days 2 & 4): `"22" + "1"` vs `22 + 1`; a short loop.
- **Debugging participation** (Days 4–5): the class fixes a deliberately broken scanner (e.g., a string port or a missing timeout).
- **Checkpoint check of each lab part:** instructor verifies a working `hello.py`, the ports list/dictionary, and the full `scanner.py` before moving on.
- **Scope check** (before Day 4): instructor confirms each student's `ip addr` shows the host-only lab subnet.

## Quiz

**Part A — Multiple choice** (2 points each)

1. What are the **two ways** to run Python from this unit?
   - A) Compile it, then double-click
   - B) Interactive interpreter (`python3`) and a script (`python3 file.py`)
   - C) `run.py` and `start.py`
   - D) Bash and PowerShell

2. What does `print("22" + "1")` output?
   - A) `23`  B) `221`  C) `22 1`  D) An error

3. Which is a **list** of ports?
   - A) `{22, 80, 443}`  B) `(22; 80; 443)`  C) `[22, 80, 443]`  D) `"22 80 443"`

4. Given `services = {22: "ssh", 80: "http"}`, what does `services[80]` give you?
   - A) `80`  B) `"http"`  C) `"ssh"`  D) An error

5. What is an **f-string**?
   - A) A file format
   - B) A string with variables plugged in, like `f"Port {p} open"`
   - C) A function
   - D) A type of loop

6. Why do we call `s.settimeout(0.5)` on the socket?
   - A) To make the scan illegal
   - B) So it gives up after a short wait instead of hanging on closed ports
   - C) To encrypt the connection
   - D) To open the port

7. When scanning a TCP port, `connect_ex((ip, port))` returns **`0`** when the port is:
   - A) Closed  B) Filtered  C) Open  D) Unknown

8. What does `try`/`except` let your program do?
   - A) Run faster
   - B) Catch an error and keep running instead of crashing
   - C) Skip indentation rules
   - D) Connect without a socket

9. Which line correctly **imports** the networking module used in this lab?
   - A) `include socket`  B) `import socket`  C) `using socket`  D) `socket.import()`

10. A port value came from `input()` and a `.split()`, so it is the **string** `"22"`. Before passing it to `connect_ex`, you must:
    - A) Add quotes around it
    - B) Convert it to an integer with `int()`
    - C) Uppercase it
    - D) Nothing — strings work fine

**Part B — Short answer** (4 points each)

11. Explain the difference between the **string** `"22"` and the **integer** `22`, and why it matters for a port scanner.

12. In your own words, what does it mean when `connect_ex` returns **`0`** for a port, and why do we also use a **timeout**?

13. The scanner below is supposed to print open ports, but it prints a port as open only when it is actually **closed**. Find the bug and fix the line.
    ```python
    result = s.connect_ex((ip, port))
    if result != 0:
        print(f"{port} open")
    ```

14. A classmate says, "I *wrote* the port scanner myself, so I can test it on any website." Correct them in two or three sentences, using the words **authorization** and **scope**.

**Part C — Applied / write code** (6 points)

15. Write a short Python function `check_port(ip, port)` that:
    - creates a TCP socket,
    - sets a timeout,
    - tries to connect and returns `True` if the port is open (else `False`),
    - uses `try`/`except` so an error returns `False` instead of crashing.

    (Any example target you mention must be a **lab** IP.)

## Project / performance task

**Prompt:** Build and document a working **TCP port scanner** that checks a list of common ports on your assigned isolated lab target. Restate the safety/authorization reminder at the top of your journal page. Run it against the lab target only, report the open ports, save results to a file, and annotate your script line by line.

**Deliverable:** The lab-journal pages from `lab.md` — the working `hello.py` and `scanner.py`, a screenshot of the scanner running, the open-port list cross-checked against the lab target's known ports, the `scan_results.txt` contents, the line-by-line annotation, and the reflection sentence (one reliability feature + one illegal place to run it).

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Safety/authorization restated | In own words, accurate, names the lab target and the authorization/scope idea | Restated accurately | Restated but vague | Missing or copied incorrectly |
| Scanner runs correctly | Scans the lab target and reports open ports correctly | Runs with minor issues | Partial functionality | Does not run / major errors |
| Python concepts used | Correct function, list, dictionary, loop, `socket` with timeout, and `try`/`except` | Most used correctly | Some used correctly | Mostly incorrect/missing |
| Results accuracy | Open-port list matches the target's known ports; results saved to file | Mostly correct | Partial | Missing/incorrect |
| Annotation & reflection | Clear line-by-line annotation + thoughtful legal/illegal reflection | Mostly clear | Partial | Missing |

## Answer key

**Part A**
1. B  2. B  3. C  4. B  5. B  6. B  7. C  8. B  9. B  10. B

**Part B**
11. `"22"` is **text** (type `str`); `22` is a **number** (type `int`). The `socket` module's `connect_ex` needs an **integer** port; passing the string causes a `TypeError`. Also, text joins (`"22" + "1"` -> `"221"`) while numbers add (`22 + 1` -> `23`), so mixing them gives wrong results. (Accept equivalent explanations.)
12. `connect_ex` returning **`0`** means the TCP connection **succeeded**, i.e., the port is **open** and something is listening there. A **timeout** sets a maximum wait so that closed or filtered ports — which never answer — don't make the program hang; it gives up after a fraction of a second and moves on, keeping the scan fast.
13. The test is inverted: `connect_ex` returns `0` for **open**, so checking `result != 0` prints exactly the **closed** ports as "open." Fix:
    ```python
    if result == 0:
        print(f"{port} open")
    ```
14. Writing the tool yourself changes nothing about who you may point it at. You may only scan systems you own or have **written permission (authorization)** to test, and only within the agreed **scope** (here, the single isolated lab target). Building a scanner and *running* it against someone else's host without permission can still violate the law. (Accept equivalent wording using both terms.)

**Part C**
15. Accept any working equivalent of:
```python
import socket

def check_port(ip, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(0.5)
    try:
        return s.connect_ex((ip, port)) == 0
    except socket.error:
        return False
    finally:
        s.close()
```
Full credit requires: creating a TCP socket; a timeout (`settimeout`); a connect attempt returning `True`/`False` based on `connect_ex(...) == 0`; and `try`/`except` so an error returns `False` rather than crashing. Closing the socket (`finally`/`s.close()`) is expected but minor deductions only if missing.
