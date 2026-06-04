# Unit 10 — Introduction to Web Application Attacks

- **Module:** Module 3 — Exploitation
- **Suggested week:** Week 10
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Introduction to Web Application Attacks (the web stack, HTTP, intercepting proxies / Burp Suite, content discovery, OWASP Top 10 awareness)

> Almost everything you use online is a web application — your school portal, your email, your games. Before you can find or fix a bug in one, you have to understand how the web actually works under the hood: the requests, the responses, and the conversation between your browser and a server. This unit opens the hood. You can't attack — or defend — a web app you don't understand.

## Learning objectives
By the end of this unit, students can:
- **Describe** the request/response model of HTTP and name the role of the client and the server.
- **Identify** the parts of an HTTP request (method, path, headers, body) and an HTTP response (status code, headers, body).
- **Match** common HTTP methods (GET, POST) and status codes (200, 301/302, 403, 404, 500) to their meanings.
- **Break down** a URL into its parts (scheme, host, path, query string, parameters).
- **Explain** the difference between **client-side** and **server-side**, and give one example of each.
- **Use** the browser's View Source and Developer Tools to inspect a page's HTML, requests, cookies, and headers.
- **Explain** what cookies and sessions are and why they matter for security.
- **List and describe** the categories of the **OWASP Top 10** at an awareness level.
- **Configure** Burp Suite Community Edition as an intercepting proxy and **intercept**, **read**, and **modify** an HTTP request.
- **Use** Burp **Repeater** to resend and tweak a request and compare responses.
- **Explain** the purpose of **directory/content discovery** (gobuster/dirb concept) and why hidden paths matter.

## Standards alignment
- **NICE Framework:** Knowledge of web application security risks (K0624); knowledge of system/application security threats (K0070); Task — assess the security of web applications (T0549). Work role exposure: Vulnerability Assessment Analyst, Cyber Defense Analyst.
- **CSTA / state CS standards:** 3A-NI-05 (network/application security and protocols), 3A-IC-24 (evaluate security implications of computing), 3B-NI-04 (mitigation of security risks).
- **Security+ domain(s):** 2.0 (Threats/vulnerabilities — web app attacks), 3.0 (Architecture — secure protocols), 4.0 (Security operations — tools).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Web application | A program you use through a browser, where most of the work happens on a remote server. |
| Client | The side that makes the request — usually your browser. |
| Server | The side that receives the request and sends back a response. |
| HTTP | The set of rules browsers and servers use to talk; the language of the web. |
| HTTPS | HTTP wrapped in encryption (TLS) so others can't read or change the traffic. |
| Request | The message a client sends asking for something (a page, an action). |
| Response | The message a server sends back, including a status code and content. |
| HTTP method | The "verb" of a request — GET (fetch), POST (send data), and others. |
| Status code | A 3-digit number that says how the request went (200 OK, 404 Not Found...). |
| Header | A name:value line carrying extra info about a request or response. |
| Body | The main content of a request or response (form data, the HTML page, etc.). |
| URL | The full address of a resource, like `https://site.com/search?q=cats`. |
| Query string | The part of a URL after `?` that holds parameters, like `q=cats`. |
| Parameter | A name=value pair of input sent to the server (`q=cats`, `id=5`). |
| Cookie | A small piece of data the server tells your browser to store and send back. |
| Session | A way the server remembers who you are between requests, often using a cookie. |
| Client-side | Code/work that runs in your browser (HTML, JavaScript). The user controls it. |
| Server-side | Code/work that runs on the server (databases, business logic). The user can't see it. |
| View Source | A browser feature that shows the raw HTML the server sent. |
| Developer Tools | Built-in browser tools to inspect HTML, network requests, cookies, and more. |
| OWASP | A nonprofit that publishes free web-security guidance, including the Top 10. |
| OWASP Top 10 | A famous list of the ten most critical web application security risks. |
| Proxy | A piece of software that sits between your browser and the server so you can see and change traffic. |
| Intercepting proxy | A proxy that can pause a request so you can read or edit it before it goes on. |
| Burp Suite | A popular web-testing toolkit; the Community Edition is free. |
| Repeater | A Burp tool for resending and editing one request over and over. |
| Content discovery | Finding hidden pages/folders on a site by guessing common names from a wordlist. |
| gobuster / dirb | Command-line tools that brute-force directory and file names to find hidden content. |

## Materials & prep
- Free **TryHackMe** accounts (browser-based; the recommended "Burp Suite: The Basics" and "OWASP Top 10" rooms are on the free tier).
- **Burp Suite Community Edition** (free, [portswigger.net](https://portswigger.net/burp/communityedition)) — installed locally **or** used through the TryHackMe in-browser AttackBox (no install needed).
- A modern browser (Firefox or Chrome) for View Source and Developer Tools.
- Projector for live demos of Dev Tools and Burp.
- Handouts: "Anatomy of an HTTP request/response" reference; "HTTP status codes" cheat card; OWASP Top 10 one-pager; lab journal observation sheet (in `lab.md`).
- **Instructor prep notes:**
  - Decide the delivery path: TryHackMe AttackBox (everything in-browser, simplest for locked-down machines) **or** local Burp install. The AttackBox path avoids install/proxy headaches.
  - If installing Burp locally, pre-test the **proxy + browser** chain on a classroom machine: Burp listens on `127.0.0.1:8080` by default, and the browser must be pointed at that proxy. The cleanest route is Burp's built-in **embedded browser** (Proxy → Open Browser), which is pre-configured — strongly recommend this for students.
  - If using the system browser with Burp, students must install Burp's CA certificate to avoid HTTPS warnings. The embedded browser sidesteps this. Test beforehand.
  - Confirm TryHackMe is reachable through the school firewall.
  - Pre-stage the OWASP Top 10 one-pager so the awareness lesson runs even if labs lag.

## ⚖️ Ethics & legal callout
An intercepting proxy lets you **see and change** the traffic between a browser and a server — including data the website never meant you to edit. That is a powerful capability, and it is exactly the kind of thing that crosses from "testing" to "crime" the moment the target isn't yours. Running Burp against a real website you don't own or have **written permission** to test — even just to "look at the requests" — can violate computer-crime law (like the CFAA). In this unit, every target is an **intentionally vulnerable practice app** (TryHackMe rooms, DVWA) built to be attacked. The dividing line, as always, is **authorization and scope**.

**Discussion prompt:** A student points Burp at their bank's login page "just to see what the request looks like" and changes nothing. Is that ethical? Is it legal? Compare it to the Wireshark "I just looked" question from Unit 3 — what's the same, and what's different now that you can *modify* the request?

## Lesson sequence

### Day 1 — How the web works: requests, responses, methods, status codes
- **Warm-up (5–10 min):** "When you type a URL and hit Enter, what message does your browser actually send, and what comes back?" Students sketch their guess.
- **Direct instruction (15–20 min):** The client/server request–response model. Anatomy of a request (method, path, headers, body) and a response (status code, headers, body). GET vs POST. Status code families: 2xx success (200), 3xx redirect (301/302), 4xx client error (403, 404), 5xx server error (500).
- **Guided practice (15 min):** Using the "Anatomy of HTTP" handout, students label a printed request and response and decode a list of status codes.
- **Independent practice / lab:** Begin TryHackMe "Burp Suite: The Basics" intro tasks (concept sections, no interception yet).
- **Closure / exit ticket (5 min):** "What does status code 404 mean, and is it the client's or the server's fault?"

### Day 2 — URLs, parameters, cookies & sessions, client vs server
- **Warm-up (5–10 min):** Project a long URL with a query string; ask students to circle "the address part" vs "the input part."
- **Direct instruction (15–20 min):** URL anatomy (scheme, host, path, query string, parameters). What cookies and sessions are and how a server "remembers" you. Client-side vs server-side: what the user controls (HTML/JS in the browser) vs what they can't see (server code, database). Key security idea: **never trust the client** — anything client-side can be changed by the user.
- **Guided practice (15 min):** Students take a sample URL apart into its parts on a worksheet and label which work happens client-side vs server-side for a login form.
- **Independent practice / lab:** Continue the TryHackMe room.
- **Closure / exit ticket (5 min):** "Give one example of something that happens client-side and one server-side."

### Day 3 — View Source, Dev Tools, and the OWASP Top 10
- **Warm-up (5–10 min):** "Where could a website accidentally leave a secret in plain sight?" (Comments in the HTML, hidden form fields...)
- **Direct instruction (15–20 min):** View Source vs Developer Tools (Elements, Network, Storage/Cookies tabs). How to read a request in the Network tab. Then a tour of the **OWASP Top 10** at an awareness level — what OWASP is, and a one-line description of each category (e.g., Broken Access Control, Injection, Cryptographic Failures, Security Misconfiguration...). Emphasis: this is the "map" of what we'll study in Units 11–12.
- **Guided practice (15 min):** On an approved practice page, students open Dev Tools, find an HTML comment or hidden field, and inspect a request in the Network tab.
- **Independent practice / lab:** Begin TryHackMe "OWASP Top 10" room intro tasks (awareness).
- **Closure / exit ticket (5 min):** "Name two OWASP Top 10 categories and one sentence about each."

### Day 4 — Burp Suite: proxy & intercept
- **Warm-up (5–10 min):** "If you could pause a letter in the mail, read it, edit it, then let it continue — what could go wrong for the sender?" (Intro to interception.)
- **Direct instruction (15–20 min):** What an intercepting proxy is and where it sits (browser → Burp → server). Burp's layout: Proxy tab, Intercept on/off, HTTP history, and the embedded browser. Demo: turn Intercept on, trigger a request, read it, **forward** it, and watch it appear in HTTP history.
- **Guided practice (15 min):** Read the **Safety & authorization reminder** in `lab.md` aloud. Students set up Burp (embedded browser or AttackBox), confirm traffic flows through Burp, and intercept their first request.
- **Independent practice / lab:** Begin the Unit 10 lab (`lab.md`) — Steps 1–3.
- **Closure / exit ticket (5 min):** "Where does Burp sit in the conversation between your browser and the server?"

### Day 5 — Burp Repeater + content discovery + lab finish
- **Warm-up (5–10 min):** "You changed a value in a request and the page reacted differently. What did that tell you about where the check happens?"
- **Direct instruction (10–15 min):** Burp **Repeater** — send a request to Repeater, edit it, resend, and diff the responses. Concept of **content discovery** (gobuster/dirb): guessing hidden directories/files from a wordlist and reading the status codes (200 vs 404 vs 403) to find what's there. (We discuss the concept; an optional stretch tries it.)
- **Guided practice / independent lab:** Finish the Unit 10 lab — intercept and **modify** a request, then use **Repeater** to send variations. Record each intercepted/modified request in the lab journal.
- **Closure / exit ticket (5 min):** Submit lab journal page; one-sentence "what surprised me about modifying a request."
- **Assessment:** Unit quiz (`assessment.md`) at end of Day 5 or start of Week 11.

## Differentiation
- **Support:** Provide the completed "Anatomy of HTTP" handout and a status-code cheat card to reference rather than memorize. Use the TryHackMe AttackBox so there is no install/proxy setup. Pair students for the Burp lab. Give sentence frames for journal entries ("I intercepted a ___ request to ___. I changed ___ to ___. The response changed because ___."). Pre-mark the exact button to click for "Intercept on/off."
- **Extension:** Students try **content discovery** for real against an approved practice target with `gobuster`/`dirb` and interpret the status codes. Explore Burp's **Decoder** and **Comparer**. Complete the full "OWASP Top 10" room and write a one-paragraph summary linking three Top 10 items to upcoming Unit 11/12 topics. Investigate how `HttpOnly` and `Secure` cookie flags protect sessions.

## Homework / independent work
- Finish the TryHackMe "Burp Suite: The Basics" room if not completed in class (browser-based, free).
- Complete the HTTP status-code cheat card from memory and self-check.
- Short write-up (½ page): "Trace one request from your browser, through Burp, to the server and back" — using at least 6 unit vocabulary terms.
- Read the OWASP Top 10 one-pager and pick the category you think is most dangerous; write 2–3 sentences defending your pick.

## Assessment
- **Formative:** Daily exit tickets; request/response labeling worksheet; URL-parts worksheet; Dev Tools walk-around check; instructor verification that each student can intercept and forward a request in Burp.
- **Summative:** Unit quiz + lab-journal deliverable (intercepted/modified request log) — see `assessment.md`.

## Instructor notes & common pitfalls
- **Burp proxy setup is the #1 failure point** (just like Wireshark capture in Unit 3). Strongly prefer the **embedded browser** (Proxy → Intercept → Open Browser) or the **TryHackMe AttackBox** — both avoid manual proxy config and CA-certificate installs. Test on the real classroom machines first.
- Students forget Intercept is **on** and think the browser is "frozen/broken" — it's just waiting at Burp. Teach the on/off toggle and the **Forward** button early and put it on the board.
- Students confuse **GET vs POST**: GET puts parameters in the URL/query string (visible, shareable); POST puts them in the body (used for sending data/logins). Reinforce that *both* can be read and changed in a proxy — visibility is not security.
- Students confuse **client-side vs server-side**. Hammer the security takeaway: client-side checks (JavaScript validation) can always be bypassed; real security must be enforced server-side. This sets up Unit 11.
- Keep the OWASP Top 10 at **awareness** depth here — don't try to teach all ten attacks. It's the map; Units 11 and 12 do the driving.
- Reinforce the ethics point hard: now that students can **modify** traffic, the temptation to "test" a real site is bigger than in Unit 3. Name it: only the intentionally vulnerable practice targets, only with authorization.
