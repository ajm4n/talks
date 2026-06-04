# Unit 03 Assessment — Networking Fundamentals

## Formative checks
- **Daily exit tickets** (one per day from the lesson plan): public-vs-private IP, three ports, handshake ordering, DNS query/response, packet addresses.
- **Ports-matching game** (Day 2): students match all nine common ports to services within a time limit.
- **Handshake diagram check** (Day 3): each student draws and correctly labels SYN / SYN-ACK / ACK, with the arrows pointing the right direction (server sends the SYN-ACK).
- **Capture walk-around** (Days 4–5): instructor verifies each student can point to the protocol, source IP, destination IP, and port on a live packet.
- **OSI/TCP-IP worksheet:** students correctly place IP, port, and HTTP at the right layers.

## Quiz

**Part A — Multiple choice** (2 points each)

1. Which of these is a **private** IPv4 address?
   - A) `8.8.8.8`  B) `192.168.1.10`  C) `203.0.113.5`  D) `93.184.216.34`

2. What is the main difference between an IP address and a MAC address?
   - A) They are the same thing
   - B) An IP address is hardware and fixed; a MAC address is logical and changes
   - C) An IP address is logical and can change; a MAC address is a fixed hardware ID
   - D) MAC addresses only exist on the internet

3. Which port is used by **HTTPS**?
   - A) 22  B) 80  C) 443  D) 53

4. Which protocol is **connection-based and reliable**, confirming that data arrived?
   - A) UDP  B) TCP  C) ICMP  D) DNS

5. Put the TCP three-way handshake in the correct order:
   - A) ACK → SYN → SYN-ACK
   - B) SYN → SYN-ACK → ACK
   - C) SYN → ACK → SYN-ACK
   - D) SYN-ACK → SYN → ACK

6. What does **DNS** do?
   - A) Encrypts web traffic
   - B) Turns a domain name into an IP address
   - C) Blocks traffic by rules
   - D) Assigns MAC addresses

7. A **firewall** primarily:
   - A) Speeds up the network
   - B) Allows or blocks traffic based on rules
   - C) Stores web pages
   - D) Converts IPv4 to IPv6

8. Which service runs on port **22**, and is it encrypted?
   - A) FTP, not encrypted
   - B) Telnet, not encrypted
   - C) SSH, encrypted
   - D) RDP, encrypted

9. In a TCP web request, the **server's** port is well-known (like 80) and the **client's** port is:
   - A) Also 80
   - B) A random high "ephemeral" port
   - C) Always 443
   - D) The MAC address

10. Which tool is a **command-line** packet capture tool?
    - A) Wireshark  B) tcpdump  C) ipconfig  D) ping

**Part B — Short answer** (4 points each)

11. List the **three private IPv4 ranges** and explain in one sentence why private addresses can't be reached directly from the internet.

12. Match these ports to their services and mark each as **encrypted** or **not encrypted**: 21, 23, 53, 80, 443, 445.

13. In your own words, **trace what happens** from typing `example.com` in a browser to the page beginning to load. Use at least these terms: DNS, IP address, three-way handshake, port.

14. Explain the difference between **TCP and UDP** and give one real example that uses each.

**Part C — Applied / packet reading** (6 points)

15. You captured this packet info. Identify the **protocol**, which side is the **client** and which is the **server**, and **what the packet is doing**:

    ```
    Source: 192.168.1.23:50112   Destination: 93.184.216.34:80   Flags: [SYN]
    ```

## Project / performance task

**Prompt:** Capture live traffic of a single web-page load on your authorized lab interface, then write a short "packet story" explaining the connection from DNS lookup through the TCP three-way handshake. Restate the safety/authorization reminder at the top.

**Deliverable:** The annotated lab-journal page from `lab.md` — observation table (≥3 packets, ≥1 handshake packet), the DNS query/response, your device's IP + MAC labeled public/private, the TryHackMe completion screenshot, and a 3–5 sentence packet story.

**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| Safety/authorization restated | In own words, accurate, with the "authorization & scope" idea | Restated accurately | Restated but vague | Missing or copied incorrectly |
| Packet identification | All packets correctly labeled (protocol, IPs, ports) | Most correct | Some correct | Mostly incorrect/missing |
| Handshake understanding | Correctly finds & explains SYN/SYN-ACK/ACK and which side sends each | Finds all three, minor error | Finds some | Cannot locate handshake |
| DNS tracing | Clearly shows name → IP and connects it to the next step | Shows name → IP | Partial | Missing |
| Packet story clarity | Accurate, uses ≥6 vocab terms correctly | Clear, some vocab | Unclear | Incomplete |

## Answer key

**Part A**
1. B  2. C  3. C  4. B  5. B  6. B  7. B  8. C  9. B  10. B

**Part B**
11. `10.0.0.0/8`, `172.16.0.0/12` (172.16–172.31), `192.168.0.0/16`. Private addresses are not routable on the public internet, so routers won't forward them; devices reach the internet through NAT at the router, which translates the private IP to the network's public IP.
12.
   - 21 — FTP — **not encrypted**
   - 23 — Telnet — **not encrypted**
   - 53 — DNS — **not encrypted** (classic DNS; accept noting DoH/DoT as encrypted variants)
   - 80 — HTTP — **not encrypted**
   - 443 — HTTPS — **encrypted**
   - 445 — SMB — **not encrypted** by default (accept "can be signed/encrypted in modern versions")
13. Accept any answer that, in order: (1) browser does a **DNS** lookup to turn `example.com` into an **IP address**; (2) browser opens a TCP connection to that IP on **port** 80/443 via the **three-way handshake** (SYN, SYN-ACK, ACK); (3) browser then sends the HTTP/HTTPS request and the server responds.
14. **TCP** = connection-based, reliable, ordered, confirms delivery (handshake); example: loading a web page, SSH, file download. **UDP** = connectionless, fast, no delivery guarantee; example: DNS lookups, video/voice streaming, online games. (Accept any valid example for each.)

**Part C**
15. Protocol: **TCP**. `192.168.1.23:50112` is the **client** (private IP, random high ephemeral port). `93.184.216.34:80` is the **server** (port 80 = HTTP). The `[SYN]` flag means this is the **first packet of the three-way handshake** — the client asking to open a connection. (Full credit also if student notes the expected next packet is `[SYN, ACK]` from the server.)
