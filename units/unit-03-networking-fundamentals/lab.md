# Unit 03 Lab — Capturing and Reading Network Traffic

- **Platform:** TryHackMe (Intro to Networking / Network Fundamentals room, browser-based, free tier) **and** Wireshark on your lab machine
- **Time:** ~90 minutes total (about two class periods, split as the lesson plan describes)
- **Difficulty:** Intro

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment. Doing this to any
system you do not own or have written permission to test is illegal.

In this lab that means: capture **only** traffic on the classroom lab network or your
own device's loopback/test traffic, exactly as your instructor directs. **Do not** run
Wireshark or tcpdump on the school's general network, public Wi-Fi, or anyone else's
network to view their traffic — intercepting other people's communications can be a
crime (wiretapping) even if you never use what you see. Authorization and scope are the
dividing line.

## Objectives
- Complete a guided TryHackMe networking room to lock in the concepts.
- Capture live network traffic with Wireshark.
- Identify, for chosen packets, the **protocol**, **source IP**, **destination IP**, and **port(s)**.
- Locate the **TCP three-way handshake** (SYN, SYN-ACK, ACK) for a web request.
- Record annotated observations in your lab journal.

## Setup
1. **Log the basics.** In your lab journal, write today's date, your name, the network/interface you are authorized to capture on (your instructor will give this), and copy the safety reminder above in one sentence of your own words.
2. **TryHackMe:** Log in at tryhackme.com, open the assigned networking room, and join it. Work through the room's tasks in order, answering the in-room questions.
3. **Wireshark:** Open Wireshark. You should see a list of network interfaces. Your instructor will tell you which interface to use (often a wired/Ethernet interface, the Wi-Fi interface for the lab network, or **loopback** for local test traffic).
4. Have a terminal/command prompt open as well — you'll generate traffic with `ping`.

## Walkthrough

### Step 1 — Finish the TryHackMe networking room
Work through the room. As you go, copy these answers into your journal (in your own words, not just the room's exact text):
- What an IP address is, and the difference between **public** and **private** IPs.
- What a **MAC address** is and how it differs from an IP.
- Three port→service pairs you learned (e.g., 22/SSH).
- The difference between **TCP** and **UDP**.

*Expected:* you finish the room with all task questions answered. Take a screenshot of the completed room banner for your journal.

### Step 2 — Find your own addresses
In a terminal, run the command for your system and record your IP and MAC:

```bash
# Linux / macOS
ip addr        # (or: ifconfig)

# Windows
ipconfig /all
```

*Expected output:* an IPv4 address (e.g., `192.168.1.23`) and a physical/hardware
address (the MAC, e.g., `00:1A:2B:3C:4D:5E`). Note in your journal whether your IP is
public or private and how you can tell.

### Step 3 — Capture a ping
1. In Wireshark, double-click your assigned interface to **start capturing**.
2. In the terminal, ping a target your instructor approves (e.g., the lab gateway or `8.8.8.8` if allowed):
   ```bash
   ping -c 4 8.8.8.8        # Linux/macOS: send 4 pings
   ping -n 4 8.8.8.8        # Windows
   ```
3. Back in Wireshark, click the red square to **stop the capture**.
4. In the display-filter bar at the top, type `icmp` and press Enter.

*Expected:* you see `ICMP` packets — "Echo (ping) request" and "Echo (ping) reply" pairs.
Click one. In the details pane, find the **source IP**, **destination IP**, and the
protocol. Record one request/reply pair in your journal (which IP asked, which answered).

### Step 4 — Capture a web page load and a DNS lookup
1. Start a new capture in Wireshark.
2. In a browser, load a simple page your instructor approves (e.g., `http://example.com` — using **http** here so traffic is visible; HTTPS would be encrypted).
3. Stop the capture.
4. Apply the display filter `dns`.

*Expected:* you see a DNS **query** for the domain and a DNS **response** containing one
or more IP addresses. Record: what name was looked up, and what IP came back. This is
DNS resolution happening live.

### Step 5 — Find the three-way handshake
1. Clear the filter, then filter to the web server's traffic. Use the IP you saw in the
   DNS response:
   ```
   ip.addr == <the IP DNS returned>
   ```
   Or filter by port: `tcp.port == 80`.
2. Find the **first three TCP packets** of the connection. Look at the **Info** column:
   - Packet 1: `[SYN]` — your machine asking to connect.
   - Packet 2: `[SYN, ACK]` — the server agreeing.
   - Packet 3: `[ACK]` — your machine confirming. Connection established.

*Expected:* three packets in SYN → SYN-ACK → ACK order. Record the source IP, destination
IP, and **port** of each. Note which side (client vs server) sent each packet.

### Step 6 — Annotate
For **three** packets of your choice (include at least one handshake packet), fill in the
observation table in your journal:

| Packet # | Protocol | Source IP | Dest IP | Port(s) | What this packet is doing |
|----------|----------|-----------|---------|---------|---------------------------|

## Deliverables
Submit your **lab journal page** containing:
- The safety reminder restated in your own words.
- Screenshot of the completed TryHackMe room.
- Your device's IP + MAC, labeled public or private.
- The annotated observation table (≥3 packets, ≥1 from the handshake).
- The DNS query/response you captured (name asked → IP returned).
- One reflection sentence: something that surprised you or a question you still have.

## Stretch goals (optional)
- Capture an **HTTPS** request to `https://example.com`. Find the TLS handshake. Note: you can see the handshake and (sometimes) the server name, but the page contents are encrypted — explain why that matters for privacy and for attackers.
- Try the same capture from the command line with **tcpdump**:
  ```bash
  sudo tcpdump -i <interface> -c 20 -nn
  ```
  Explain what `-c`, `-nn`, and `-i` do.
- Write a Wireshark display filter that shows **only** the three handshake packets and explain how it works (hint: TCP flag filters like `tcp.flags.syn == 1`).
- Complete a second free TryHackMe networking room as an extension.

## Answer key (instructor only)
- **Step 2 — public vs private:** Private if in `10.0.0.0/8`, `172.16.0.0/12` (i.e., `172.16`–`172.31`), or `192.168.0.0/16`. Lab machines on a `192.168.x.x` or `10.x.x.x` network are private; they reach the internet via NAT at the router. Loopback is `127.0.0.1`.
- **Step 3 — ping/ICMP:** Echo request goes from the student's private IP to the target; echo reply comes back from the target to the student. ICMP is **not** TCP or UDP — it rides directly on IP. Good teaching moment: there are no ports in ICMP.
- **Step 4 — DNS:** Query is typically UDP port **53** to the configured resolver; response carries an **A record** (IPv4) and/or **AAAA** (IPv6). The returned IP is what the browser then connects to. For `example.com` the A record is in the `93.184.x` range (it changes; accept whatever the live response shows).
- **Step 5 — handshake:** Client sends `[SYN]` (src = student IP, dst = web server IP, dst port = **80** for HTTP, ephemeral high source port like 49xxx/50xxx). Server replies `[SYN, ACK]` (src/dst swapped). Client sends `[ACK]`. The server's port is 80 (or 443 for HTTPS); the client's port is a random high port. Common student error: expecting two SYNs — only one. The SYN-ACK is a single packet.
- **Step 6 — table:** Accept any correct mapping. Verify the source/destination IPs swap appropriately between request and reply, and that the well-known port is on the server side, the high ephemeral port on the client side.
- **Common pitfalls:** If no packets appear, the wrong interface is selected or capture permissions are missing — switch to loopback or hand out the backup `web-request.pcap`. If HTTPS shows no readable content, that's correct (encrypted) — don't let students think the capture "failed."
- **Stretch filter answer:** `tcp.flags.syn == 1 || (tcp.flags.syn == 0 && tcp.flags.ack == 1 && tcp.seq == 1)` is overkill for HS; accept the simpler `tcp.flags.syn == 1` to catch SYN and SYN-ACK, with discussion that the bare ACK is harder to isolate. The point is understanding flags, not a perfect filter.
