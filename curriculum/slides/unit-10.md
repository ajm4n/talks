---
marp: true
theme: bootstrap
paginate: true
header: "Introduction to Offensive Security · Unit 10"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Introduction to Web Application Attacks
## Unit 10 — How the Web Really Works

Almost everything you use online is a web app. Before you can find — or fix — a bug, you have to open the hood.

<!-- teacher note: Module 3 opener. Goal is understanding the HTTP conversation, not exploiting yet. Don't rush the proxy setup; it's the #1 failure point. -->

---

# Learning objectives

By the end of this unit you can:

- **Describe** the HTTP request/response model and the roles of **client** and **server**.
- **Identify** the parts of a request (method, path, headers, body) and a response (status code, headers, body).
- **Break down** a URL into scheme, host, path, query string, and parameters.
- **Explain** the difference between **client-side** and **server-side**.
- **Use** View Source and Developer Tools to inspect HTML, cookies, and requests.
- **Configure** Burp Suite as an intercepting proxy and **intercept, read, and modify** a request.
- **Explain** the OWASP Top 10 and content discovery at an awareness level.

---

# The web is a conversation

- A **client** (your browser) sends a **request**.
- A **server** receives it and sends back a **response**.
- The rules for that conversation are called **HTTP** (HTTPS = HTTP + encryption).

> You can't attack — or defend — a web app you don't understand.

<!-- teacher note: Warm-up — "When you hit Enter on a URL, what message does the browser send?" Have students sketch their guess first. -->

---

# Anatomy of a request

```http
GET /search?q=cats HTTP/1.1
Host: example.com
User-Agent: Firefox
Cookie: session=abc123
```

- **Method** — the verb: `GET` (fetch) or `POST` (send data)
- **Path** — what you're asking for (`/search`)
- **Headers** — extra info (`Host:`, `Cookie:`...)
- **Body** — the content sent (form data, often empty on a GET)

<!-- teacher note: This is a lab-only demonstration request. GET puts params in the URL; POST puts them in the body. Both are visible and editable in a proxy. -->

---

# Anatomy of a response

```http
HTTP/1.1 200 OK
Content-Type: text/html
Set-Cookie: session=abc123

<html>...the page...</html>
```

- **Status code** — how it went (200 OK)
- **Headers** — info about the response
- **Body** — the actual HTML/content sent back

---

# Status codes at a glance

| Family | Meaning | Examples |
|--------|---------|----------|
| **2xx** | Success | 200 OK |
| **3xx** | Redirect | 301 / 302 |
| **4xx** | Client error | 403 Forbidden, 404 Not Found |
| **5xx** | Server error | 500 |

> 404 means the **client** asked for something that isn't there. 500 means the **server** broke.

<!-- teacher note: Exit ticket — "What does 404 mean, and is it the client's or the server's fault?" -->

---

# Breaking down a URL

```
https://site.com/search?q=cats&id=5
\___/   \______/\_____/ \________/
scheme    host    path  query string
```

- **Query string** = everything after `?`
- **Parameter** = one `name=value` pair (`q=cats`, `id=5`)
- Parameters are **input you send to the server** — and input is where bugs live.

<!-- teacher note: Project a long URL; have students circle "the address part" vs "the input part." -->

---

# Cookies, sessions, client vs server

- **Cookie** — a small piece of data the server tells your browser to store and send back.
- **Session** — how the server remembers *who you are* between requests.
- **Client-side** — runs in your browser (HTML/JS). **The user controls it.**
- **Server-side** — runs on the server (database, logic). The user can't see it.

> **Never trust the client.** Anything client-side can be changed by the user. Real security must be enforced **server-side**.

<!-- teacher note: This is the takeaway that sets up Unit 11. JavaScript "validation" is bypassable. -->

---

# Seeing what the server sent

- **View Source** — the raw HTML the server delivered (secrets sometimes hide in comments!).
- **Developer Tools** — inspect live:
  - **Elements** — the HTML tree
  - **Network** — every request/response
  - **Storage / Cookies** — what's stored in your browser

<!-- teacher note: Warm-up — "Where could a website accidentally leave a secret in plain sight?" Then have students find an HTML comment or hidden field in Dev Tools. -->

---

# The OWASP Top 10 — the map

- **OWASP** = a nonprofit that publishes free web-security guidance.
- The **Top 10** = the ten most critical web app risks, including:
  - Broken Access Control
  - **Injection** (we attack this in Units 11–12)
  - Cryptographic Failures
  - Security Misconfiguration

> Today this is the **map**. Units 11 and 12 do the driving.

<!-- teacher note: Keep this at awareness depth. Don't teach all ten attacks here. -->

---

# Burp Suite: the intercepting proxy

- A **proxy** sits between your browser and the server.
- An **intercepting proxy** can **pause** a request so you can read or edit it.

```
Browser  →  [ BURP ]  →  Server
            pause / read / edit
```

- Key tools: **Proxy** (intercept + HTTP history) and **Repeater** (resend & tweak one request).

<!-- teacher note: Use the embedded browser (Proxy > Open Browser) or the THM AttackBox — both avoid proxy config and CA-cert headaches. Teach the Intercept on/off toggle and Forward button EARLY and write them on the board. -->

---

# Defense mindset: visibility is not security

- A proxy proves the user can **see and change** any request — even hidden fields and "validated" forms.
- **If your only check runs in the browser, it can be bypassed.**

**Defense (server-side):**
- Re-check and **validate every input on the server**.
- Mark session cookies `HttpOnly` and `Secure`.
- Never rely on hidden fields or JavaScript to enforce rules.

<!-- teacher note: Connect to the Step 3 lab payoff — if a client-side check can be changed in Burp and still accepted, the validation was bypassable. -->

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

A proxy lets you **modify** real traffic — that makes the temptation bigger and the line clearer.

Targets are **intentionally vulnerable practice apps ONLY** — TryHackMe rooms, PortSwigger Academy, DVWA. **Never** your school portal, a bank, a game, or *any* real site — even just to "look."

Unauthorized testing is a crime under the **CFAA**. Authorization and scope are the only difference.

<!-- teacher note: Discussion — a student points Burp at their bank's login "just to see the request" and changes nothing. Ethical? Legal? Compare to the Wireshark "I just looked" question — what changed now that you can MODIFY? -->

---

# Key vocabulary

| Term | Meaning |
|------|---------|
| HTTP / HTTPS | Language of the web (HTTPS = encrypted) |
| Method / Status code | The request verb / the 3-digit result |
| Header / Body | Extra info / the main content |
| Query string / Parameter | After `?` / one `name=value` input |
| Cookie / Session | Stored data / how the server remembers you |
| Proxy / Intercepting proxy | Sits between / can pause & edit traffic |
| Repeater | Burp tool to resend & tweak one request |
| Content discovery | Guessing hidden paths from a wordlist |

---

# 🧪 Lab launch

**Platform: Burp Suite Community + OWASP Top 10 (TryHackMe)**

- **Path A** — THM "Burp Suite: The Basics" AttackBox (all in-browser).
- **Path B** — local Burp → **Proxy → Intercept → Open Browser**.

You will: prove traffic flows through Burp → **intercept** a request → **modify** a parameter → send it to **Repeater** and compare responses.

> Write your scope statement first: *"I am authorized to test only this intentionally vulnerable practice app."*

<!-- teacher note: Pair students. Page loads = multiple requests; they'll Forward several times. Turn Intercept OFF when done or browsing "breaks." -->

---

# Content discovery (concept)

- Tools like **gobuster** / **dirb** request many guessed paths from a wordlist.

```
gobuster dir -u http://TARGET -w common.txt
```

- Read the **status codes** to find hidden pages:
  - `200` / `403` → something is **there**
  - `404` → nothing there

> A `403 Forbidden` is *useful*: it means the path **exists** but is locked.

<!-- teacher note: Optional hands-on for the extension group, against an approved practice target only. -->

---

# Recap

- The web is a **request → response** conversation over **HTTP**.
- A request has a **method, path, headers, body**; a response adds a **status code**.
- **Client-side is controllable** by the user — enforce security **server-side**.
- **Burp** lets you intercept, modify, and **Repeater** lets you resend & compare.
- The **OWASP Top 10** is the map for Units 11–12.

---

<!-- _class: lead -->

# Exit ticket & discussion

1. Where does Burp sit in the conversation between your browser and the server?
2. Give one example of something that happens **client-side** and one **server-side**.
3. **Discuss:** Why is "I only looked, I changed nothing" still a problem when the target is a real site?

**Next — Unit 11:** Common Web Attacks: XSS, Command Injection & File Inclusion

<!-- teacher note: Collect the lab journal request log. Quiz at end of Day 5 or start of Week 11. -->
