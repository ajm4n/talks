# Unit 10 Lab — Burp Suite Basics: Intercept, Modify, and Repeat

- **Platform:** TryHackMe "Burp Suite: The Basics" (free tier, browser-based via the AttackBox) and/or **Burp Suite Community Edition** + the embedded browser. Optional awareness room: TryHackMe "OWASP Top 10".
- **Time:** ~2 class periods (Days 4–5)
- **Difficulty:** intro

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment, and **only** against
the **intentionally vulnerable practice apps** your instructor approves — TryHackMe
rooms, PortSwigger Web Security Academy, or DVWA. These targets were **built to be
attacked** so you can learn safely. Pointing Burp at a real website you do not own
or have **written permission** to test — your school portal, a bank, a game, *any*
real site — is illegal under computer-crime laws like the CFAA, even if you "only
look" or "change nothing." A proxy lets you **see and modify** traffic, which makes
the temptation bigger and the line clearer: **authorization and scope** are the only
difference between testing and a crime. If you are not 100% sure a target is
approved, stop and ask your instructor.

## Objectives
- Configure Burp Suite Community as an intercepting proxy (embedded browser **or** AttackBox).
- Confirm your browser's traffic is flowing through Burp by viewing it in HTTP history.
- Intercept a live HTTP request, read its parts (method, path, headers, body), and **forward** it.
- **Modify** an intercepted request before forwarding and observe how the server's response changes.
- Send a request to **Repeater**, edit it, resend it, and compare the responses.
- Record each intercepted/modified request in your lab journal using the observation sheet.

## Setup
1. **Read the Safety & authorization reminder above out loud** with your partner. Write the approved target at the top of your lab journal and this scope statement: *"I am authorized to test only this intentionally vulnerable practice app provided by my instructor."*
2. Choose your path (your instructor will tell you which):
   - **Path A — TryHackMe AttackBox (simplest):** Start the "Burp Suite: The Basics" room, launch the AttackBox, and open Burp from inside it. Everything runs in your browser — no install, no proxy config.
   - **Path B — Local Burp:** Launch Burp Suite Community Edition. Go to **Proxy → Intercept → Open Browser** to launch Burp's **embedded browser**, which is already pointed through the proxy (no certificate install needed).
3. Open your lab journal / observation sheet and record the date, objective, target, and path.
4. Confirm Intercept is **OFF** to start (Proxy → Intercept → button reads "Intercept is off").

## Walkthrough

### Step 1 — Prove traffic flows through Burp
- With Intercept **off**, browse to the practice app in the Burp browser (or AttackBox browser).
- Open **Proxy → HTTP history**. You should see a list of requests your browser made.
- **Record:** pick one GET request from HTTP history. Write down its **method**, **path**, one **header**, and the **status code** of the response.
- *Expected:* a list of requests appears; a normal page load returns a `200 OK`.

### Step 2 — Intercept your first request
- Turn **Intercept ON** (Proxy → Intercept → button now reads "Intercept is on").
- In the Burp browser, click a link or submit a simple form on the practice app.
- The browser will appear to "hang" — that is normal. The request is **paused at Burp**, waiting for you.
- Read the paused request in the Intercept tab. Identify the **method**, **path/URL**, **headers**, and (if a form) the **body**.
- Click **Forward** to let it continue. Click Forward again for any follow-up requests until the page loads.
- **Record:** the method, path, and what was in the body (if anything) of the request you intercepted.

### Step 3 — Modify a request before forwarding
- Find a request on the practice app that contains a **parameter** you can change (e.g., a search box that sends `?q=cats`, or a form field). The TryHackMe room points you to a good one.
- Turn Intercept **ON**, trigger that request, and when it pauses, **edit a value** directly in the intercepted request (for example, change `q=cats` to `q=dogs`, or change a hidden `price`/`id` field).
- Click **Forward** and watch the page.
- **Record:** what you changed (from → to), and how the response was different. Note whether the change "worked," which tells you whether the check happens **client-side** (easy to bypass) or **server-side**.

### Step 4 — Send to Repeater and experiment
- Find your modified (or any interesting) request in **Proxy → HTTP history**, right-click it, and choose **Send to Repeater**.
- Switch to the **Repeater** tab. Click **Send** to resend the original request and read the response on the right.
- Now **edit** the request (change a parameter, a header, or the method) and click **Send** again.
- Compare the two responses. Repeater lets you tweak-and-resend without re-doing the whole browser action.
- **Record:** at least two Repeater variations — what you changed each time and how the response differed.

### Step 5 — (Concept) Content discovery
- Discuss with your partner: tools like **gobuster** and **dirb** request many guessed paths from a wordlist (`/admin`, `/backup`, `/login`...) and read the **status codes** to find hidden pages (`200`/`403` = something's there; `404` = not found).
- **Record:** in 2–3 sentences, explain why a `403 Forbidden` is actually a *useful* result to an attacker doing content discovery. (Optional hands-on version is in Stretch goals.)

## Deliverables
- **Lab journal — Intercepted/Modified Request Log:** one row per request, with columns:
  | # | Method | Path/URL | What I changed (from → to) | Status code | What the response told me |
  |---|--------|----------|----------------------------|-------------|---------------------------|
  Include at least: 1 intercepted-and-forwarded request (Step 2), 1 modified request (Step 3), and 2 Repeater variations (Step 4).
- A 2–3 sentence reflection: "What surprised me about being able to modify a request, and which OWASP Top 10 idea does it connect to?"
- Your one-sentence content-discovery explanation (Step 5).

## Stretch goals (optional)
- Run real **content discovery** against an approved practice target with `gobuster dir -u http://TARGET -w /usr/share/wordlists/dirb/common.txt` and interpret the status codes you get back.
- Explore Burp's **Decoder** (URL/Base64 encode-decode) and **Comparer** (diff two responses).
- Complete the full TryHackMe "OWASP Top 10" room and write a one-paragraph summary linking three Top 10 categories to upcoming Unit 11/12 topics.
- Find an **HTTP-only** vs **Secure** cookie flag in the Storage/Cookies view and explain what each protects against.

## Answer key (instructor only)
*(Exact values depend on the room/app you assign. Below maps to the standard TryHackMe "Burp Suite: The Basics" flow and DVWA.)*
- **Step 1:** Students should correctly read a request's method (GET), path, a header (e.g., `Host:`, `User-Agent:`, `Cookie:`), and a `200 OK` response. Full credit = all four fields identified correctly from a real captured request.
- **Step 2:** Common confusion — the "frozen browser" is just Intercept waiting; teach the **Forward** button. Verify each student can pause, read, and forward a request. A page load is often **multiple** requests (HTML, then CSS/JS/images) — students must Forward several times.
- **Step 3:** The teaching payoff is **client-side vs server-side**. Example (DVWA): changing a hidden field or a `q=` parameter and seeing it reflected proves input reaches the server unmodified. If a value the browser "validated" can be changed in Burp and still accepted, that proves the validation was client-side only and is **bypassable** — the central lesson that sets up Unit 11. Full credit = student states from→to AND interprets where the check lives.
- **Step 4:** Look for two genuine variations with comparison, e.g., changing a parameter value, swapping `GET`↔`POST`, or editing a header. Reinforce that Repeater = "edit and resend one request fast" — the testers' workhorse.
- **Step 5:** A `403 Forbidden` means the resource **exists** but access is denied — so it confirms a hidden path is there (more useful than a plain `404 Not Found`). Accept any answer expressing "403/200 = it exists; 404 = it doesn't."
- **Common errors / re-teach triggers:**
  - Any sign a student pointed Burp at a **real** site — STOP and re-teach scope immediately.
  - Forgetting to turn Intercept **off** when done (browsing then "breaks").
  - HTTPS certificate warnings = student used the system browser instead of the embedded browser/AttackBox; switch them over.
  - Confusing GET (params in URL) vs POST (params in body) — both are visible/editable in Burp; visibility is not security.
