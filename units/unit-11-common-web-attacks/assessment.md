# Unit 11 Assessment — Common Web Attacks (XSS, Command Injection, File Inclusion)

## Formative checks
- **Exit tickets** (Days 1–5): reflected vs stored XSS in one sentence; how output encoding stops XSS; one command-injection defense + why; what `../` does and its name; the common root cause behind all three attacks.
- **XSS-types matching:** student correctly sorts scenarios into reflected / stored / DOM-based and names who is affected.
- **Attack↔Defense chart check:** chart is complete and each defense is correctly paired and explained (checked daily).
- **Instructor verification:** each student can trigger at least one attack at **low** security AND observe it **blocked** at a higher level.

## Quiz

1. What is the **common root cause** behind XSS, command injection, and file inclusion?
   - A) Slow servers  B) Untrusted/unvalidated input that the app trusts  C) Weak Wi-Fi  D) Too much HTTPS

2. **Cross-Site Scripting (XSS)** lets an attacker:
   - A) Run their JavaScript in another user's browser
   - B) Physically break the server
   - C) Speed up the website
   - D) Change the user's password directly with no other steps

3. Which type of XSS is **saved by the app and runs for every future visitor**?
   - A) Reflected  B) Stored  C) DOM-based  D) Encoded

4. Which type of XSS **bounces input straight back in the immediate response** (often via a URL parameter)?
   - A) Stored  B) Reflected  C) Persistent  D) Server-side

5. A primary defender fix for XSS is:
   - A) Output encoding (showing `<` as text, not code) and a Content Security Policy
   - B) Buying a faster server
   - C) Hiding the page from search engines
   - D) Using GET instead of POST

6. **Command injection** happens when:
   - A) The user uploads a photo
   - B) User input is passed into an operating-system command, letting an attacker add their own commands
   - C) Two users log in at once
   - D) The page loads slowly

7. Which is a real **defense** against command injection?
   - A) Pass the input straight to the shell faster
   - B) Avoid calling the shell; use a safe/parameterized API and allow-list the input
   - C) Trust the input because it came from a form
   - D) Hide the error messages only

8. In a file path, the sequence `../` is used to:
   - A) Move up one directory (directory traversal)
   - B) Encrypt the file
   - C) Delete the file
   - D) Comment out code

9. What is the difference between **LFI** and **RFI**?
   - A) LFI loads a file already on the server; RFI loads a file from a remote attacker-controlled URL
   - B) They are the same thing
   - C) LFI is remote; RFI is local
   - D) RFI only works on images

10. In DVWA, raising the **security level** generally blocks the attacks because it:
    - A) Turns the server off
    - B) Adds stronger input validation / encoding
    - C) Changes the page colors
    - D) Hides the login page

11. Why is **stored** XSS usually considered more dangerous than **reflected** XSS?
    - A) It is faster to type
    - B) It runs for many other users who never consented, not just whoever clicked one link
    - C) It only affects the attacker
    - D) It cannot be defended against

12. A **client-side attack** (awareness) is one that primarily targets:
    - A) The user's machine or browser (e.g., a malicious document/script)
    - B) The server's database only
    - C) The network router only
    - D) The domain registrar

13. **Short answer:** Explain in your own words why "untrusted input" is the shared root cause of XSS, command injection, and file inclusion — and name the shared idea that cures all three.

14. **Short answer:** Pick ONE attack from this unit. Describe what it does and give a specific **defensive fix**, explaining *why* that fix works.

## Project / performance task — Web-Vuln Observations (feeds the Module 3 writeup)
**Prompt:** Submit your **web-vuln observation sheet** and completed **Attack↔Defense chart** from the Unit 11 lab, against **DVWA only**. For each of the three attack classes (XSS, command injection, file inclusion) document: the page/input, the payload used, what happened at **low** security, what happened at a **higher** security level, and the matching **defensive fix** with a short *why*. Add a reflection naming the single shared root cause and the single shared cure.

**Deliverable:** Completed observation sheet + Attack↔Defense chart + reflection in your lab journal. **This is the source material for the Module 3 web-vuln writeup project**, so be thorough and accurate.

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Attacks demonstrated | All three classes triggered at low AND observed blocked at higher level, accurately documented | Most documented | Some / missing security-level comparison | Sparse or incorrect |
| Defenses paired | Correct, well-explained fix for every attack with *why* | Fixes present, light explanation | Some fixes / vague | Missing or wrong |
| Root-cause insight | Clearly connects all three to untrusted input + the validate/encode/isolate cure | Mostly connected | Partial | Not connected |
| Scope & ethics | DVWA-only, isolation/scope statement present, ethics noted | Scope stated | Vague scope | Missing or used a real site |
| Professionalism | Organized, correct vocabulary, readable | Solid | Rough | Hard to follow |

## Answer key
1: B — 2: A — 3: B — 4: B — 5: A — 6: B — 7: B — 8: A — 9: A — 10: B — 11: B — 12: A

13. All three bugs occur because the application takes **input from the user (untrusted input)** and uses it without checking it — XSS puts that input into a page where the browser runs it as code, command injection puts it into an OS command, and file inclusion puts it into a file path. The shared cure is to **validate, encode, and isolate untrusted input** (e.g., allow-list/validate it, output-encode it, and never hand it straight to a shell or file path) — ideally in layers (**defense-in-depth**) enforced **server-side**.

14. Accept any one attack done correctly. Examples:
   - **Reflected/Stored XSS** — injects attacker JavaScript that runs in a victim's browser (can steal sessions/deface). **Fix:** **output encoding** (render `<` as `&lt;` so it shows as text, not code) plus a **CSP** that restricts which scripts run; works because the browser never treats the input as executable code.
   - **Command injection** — user input is concatenated into an OS shell command, so adding `; whoami` runs extra commands. **Fix:** **don't call the shell / use a parameterized API** and **allow-list** input (e.g., only valid IP characters); works because input is treated as data, never as a command.
   - **LFI/RFI** — input chooses which file the app loads, so `../../etc/passwd` (traversal) or a remote URL is loaded. **Fix:** **validate/allow-list the file**, never build paths from raw input, and **disable remote includes**; works because the app only ever loads known-safe files.
