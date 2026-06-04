# Unit 10 Assessment — Introduction to Web Application Attacks

## Formative checks
- **Exit tickets** (Days 1–5): meaning of status code 404 and whose "fault" it is; one client-side vs one server-side example; two OWASP Top 10 categories in a sentence each; where Burp sits in the browser↔server conversation; "what surprised me about modifying a request."
- **Request/response labeling worksheet:** student correctly labels method, path, headers, body, and status code on a printed request/response.
- **URL-parts worksheet:** student splits a URL into scheme, host, path, query string, and parameters.
- **Dev Tools walk-around:** student opens Developer Tools and finds an HTML comment or hidden field and reads a request in the Network tab.
- **Instructor verification:** each student can intercept, read, and forward a request in Burp (the key skill gate).

## Quiz

1. In the client/server model of the web, which side usually makes the **request**?
   - A) The server  B) The database  C) The client (browser)  D) The router

2. Which HTTP method is normally used to **send form data** (like a login) in the body of the request?
   - A) GET  B) POST  C) HEAD  D) DELETE

3. A response with status code **404** means:
   - A) Success — here is the page
   - B) The resource was not found (a client-side address problem)
   - C) The server crashed
   - D) You were redirected

4. Which status code family means **server error**?
   - A) 2xx  B) 3xx  C) 4xx  D) 5xx

5. In the URL `https://shop.com/search?item=shoes&size=9`, what is `item=shoes`?
   - A) The scheme  B) The host  C) A parameter in the query string  D) The path

6. What is a **cookie** used for?
   - A) Encrypting the whole internet
   - B) A small piece of data the server has your browser store and send back, often to remember your session
   - C) Speeding up your CPU
   - D) Blocking all ads

7. Which statement about **client-side vs server-side** is the key security takeaway?
   - A) Client-side checks (JavaScript) can be bypassed, so real security must be enforced server-side
   - B) Server-side code is visible to the user, so never put logic there
   - C) Client-side and server-side are the same thing
   - D) The client can be fully trusted because it runs on the user's machine

8. The **OWASP Top 10** is:
   - A) The ten fastest hacking tools
   - B) A list of the ten most critical web application security risks
   - C) A programming language
   - D) A list of safe websites

9. An **intercepting proxy** like Burp Suite lets you:
   - A) Only speed up page loads
   - B) Pause, read, and **modify** a request before it reaches the server
   - C) Decrypt any website with no setup
   - D) Permanently delete a website

10. Which Burp tool is best for **resending and editing one request over and over** to compare responses?
    - A) Proxy  B) Repeater  C) HTTP history  D) Decoder

11. During content discovery, a tool like **gobuster** finds hidden pages by guessing path names and reading the:
    - A) Page colors  B) Status codes returned for each guessed path  C) Font sizes  D) Domain registrar

12. Pointing Burp Suite at your **bank's** real website "just to see the requests," changing nothing, is:
    - A) Fine, because you didn't change anything
    - B) Fine, because looking is always legal
    - C) Likely illegal and against the rules — you have no authorization or scope for that target
    - D) Required practice for the course

13. **Short answer:** Explain why "the website's JavaScript already checks my input, so it must be safe" is wrong. Use the words *client-side*, *server-side*, and *proxy*.

14. **Short answer:** Describe, in your own words, where Burp Suite sits and what an intercepting proxy lets a tester do. Name one ethical rule that must hold before you use it on any target.

## Project / performance task — Intercepted/Modified Request Journal
**Prompt:** Submit your **Intercepted/Modified Request Log** from the Unit 10 lab. It must document, against an **approved practice target only**, at least: (1) one request you intercepted and forwarded; (2) one request you **modified** (with from → to and the effect); and (3) two **Repeater** variations with their compared responses. Add a short reflection connecting one observation to an OWASP Top 10 category and to the ethics of using a proxy.

**Deliverable:** The completed request-log table + reflection in your lab journal. (This builds the proxy/HTTP skills the Module 3 web-vuln writeup project will rely on.)

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Technique & evidence | All required entries present and accurate (intercept, modify, 2× Repeater) with correct fields | Most entries present | Few entries / missing fields | Sparse or incorrect |
| Interpretation | Correctly explains client-side vs server-side from the modify result; links to a Top 10 item | Some correct interpretation | Vague | Missing/incorrect |
| Scope & ethics | Approved target only; scope statement present; ethics reflection clear | Scope stated | Vague scope | Missing or used a real site |
| Professionalism | Organized, correct vocabulary, readable | Solid | Rough | Hard to follow |

## Answer key
1: C — 2: B — 3: B — 4: D — 5: C — 6: B — 7: A — 8: B — 9: B — 10: B — 11: B — 12: C

13. JavaScript validation runs **client-side** (in the browser), and the user fully controls the browser — so it can be bypassed. Using a **proxy** like Burp, a tester can edit the request *after* the JavaScript "checked" it and before it reaches the server. Because of that, the real, trustworthy validation must happen **server-side**, where the user cannot tamper with it. (This is the central idea that sets up Unit 11.)

14. Burp Suite sits **between the browser (client) and the server**, acting as an intercepting **proxy**. It lets a tester pause, read, and **modify** requests (and responses) before they continue, and resend them with Repeater. Ethical rule (accept any one): only use it on targets you **own or have written permission to test** (authorization + scope); only the intentionally vulnerable practice apps in class — never a real site.
