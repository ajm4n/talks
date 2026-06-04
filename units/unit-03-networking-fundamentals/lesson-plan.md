# Unit 03 — Networking Fundamentals

- **Module:** Module 1 — Technical Foundations
- **Suggested week:** Week 3
- **Estimated time:** 5 × ~50-min class periods
- **PEN-200 mapping:** Networking concepts that PEN-200 assumes; practical tools (Wireshark, tcpdump)

> PEN-200 expects you to already understand TCP/IP, ports, and how packets travel. This course does **not** assume that. Unit 03 teaches networking from zero so the rest of the course makes sense. You can't attack — or defend — a network you don't understand.

## Learning objectives
By the end of this unit, students can:
- **Define** what a computer network is and describe, in order, how data travels from one device to another.
- **Distinguish** an IP address from a MAC address and explain what each is used for.
- **Identify** an IPv4 address as public or private given the address (e.g., recognize `10.x`, `172.16–31.x`, `192.168.x` as private).
- **Match** at least 8 common ports to their services (20/21 FTP, 22 SSH, 23 Telnet, 25 SMTP, 53 DNS, 80 HTTP, 443 HTTPS, 445 SMB, 3389 RDP).
- **Explain** the difference between TCP and UDP and give one example use of each.
- **Diagram** the TCP three-way handshake (SYN, SYN-ACK, ACK) and label each step.
- **Describe** the four practical layers of the TCP/IP model and relate them to the OSI model.
- **Trace** a DNS lookup from a typed domain name to a returned IP address.
- **Capture** live traffic in Wireshark and **identify** the protocol, source/destination IP, and port for a packet.
- **Locate** the three handshake packets in a real capture of a web request.

## Standards alignment
- **NICE Framework:** Knowledge of network protocols and topologies (K0001, K0034, K0011); Task — analyze network traffic (T0291). Work role exposure: Cyber Defense Analyst.
- **CSTA / state CS standards:** 3A-NI-04 (model how data is transmitted), 3A-NI-05 (network security/protocols), 3B-NI-03 (network topology and protocols).
- **Security+ domain(s):** 1.0 (Networking basics, ports/protocols), 4.0 (security operations — packet analysis awareness).

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| Network | Two or more devices connected so they can share data. |
| Host | Any device on a network (computer, phone, printer, server). |
| IP address | A numeric address that identifies a device on a network so traffic can find it. |
| IPv4 | The common IP format written as four numbers, like `192.168.1.10`. |
| Public IP | An address reachable on the open internet. |
| Private IP | An address used only inside a local network; not directly reachable from the internet. |
| MAC address | A hardware ID burned into a network card, like `00:1A:2B:3C:4D:5E`. |
| Port | A numbered "door" on a host that a specific service listens on (like apartment numbers at one street address). |
| Service | A program that listens on a port and answers requests (a web server, mail server, etc.). |
| Protocol | An agreed set of rules for how two devices talk (HTTP, DNS, TCP...). |
| TCP | A connection-based protocol that confirms delivery; reliable but slower. |
| UDP | A connectionless protocol that just sends; fast but no delivery guarantee. |
| Three-way handshake | The SYN → SYN-ACK → ACK exchange that starts a TCP connection. |
| OSI model | A 7-layer reference map of how networking works, from cables to apps. |
| TCP/IP model | The practical 4-layer model (Link, Internet, Transport, Application) the internet actually uses. |
| Packet | A small chunk of data sent across a network, wrapped with addressing info. |
| DNS | The "phonebook" of the internet — turns names like `example.com` into IP addresses. |
| Firewall | A filter that allows or blocks traffic based on rules. |
| Router | A device that forwards packets between different networks. |
| Wireshark | A graphical tool for capturing and inspecting network packets. |
| tcpdump | A command-line tool for capturing packets. |

## Materials & prep
- Student laptops with **Wireshark** installed (free, [wireshark.org](https://www.wireshark.org)). On classroom-managed machines, capture may require admin rights — see prep notes.
- Free **TryHackMe** accounts (browser-based; free tier covers the recommended room).
- Projector/whiteboard for diagramming the handshake and DNS lookup.
- Handouts: "Common Ports" reference card; blank OSI/TCP-IP layer worksheet; packet-capture observation sheet (in `lab.md`).
- Optional: a small unmanaged switch or the school's lab network segment for live captures.
- **Instructor prep notes:**
  - Confirm Wireshark + Npcap (Windows) / appropriate capture driver is installed and that students can see at least loopback or a wired interface. If machines are locked down, fall back to capturing on **loopback** (`127.0.0.1`) which usually works without admin, or distribute a provided `.pcap` file so the analysis still happens.
  - Pre-download a sample capture (`web-request.pcap`) as a backup so the analysis lesson runs even if live capture fails.
  - Verify TryHackMe room access on the school network (it is browser-based; confirm the firewall allows it).
  - Decide which interface students capture on and write it on the board.

## ⚖️ Ethics & legal callout
Packet capture is **wiretapping** when done on traffic that is not yours. Capturing on a network you own or are authorized to test (this classroom lab, your own home network) is fine. Capturing other people's traffic — on public Wi-Fi, a friend's network, the school network outside this lab — can violate wiretap and computer-crime laws even if you "just looked." The dividing line, as always, is **authorization and scope**.

**Discussion prompt:** A student says, "I ran Wireshark at the coffee shop and saw other people's traffic — but I didn't *do* anything with it." Is that ethical? Is it legal? Does intent change the answer? Where is the line between "curiosity" and "interception"?

## Lesson sequence

### Day 1 — What is a network? IPs and MACs
- **Warm-up (5–10 min):** "How does a message you text actually reach your friend's phone?" Students sketch their best guess. Collect a few on the board — we'll revisit on Day 5.
- **Direct instruction (15–20 min):** Define network, host, router. Introduce IP addresses (IPv4 format), public vs private ranges, and MAC addresses. Analogy: IP = mailing address (can change), MAC = your name on the mailbox (fixed to the device).
- **Guided practice (15 min):** Students run `ipconfig` (Windows) / `ip addr` (Linux/macOS `ifconfig`) and record their device's IP and MAC. Class sorts sample IPs into public vs private.
- **Independent practice / lab:** Begin TryHackMe networking room — intro sections.
- **Closure / exit ticket (5 min):** "Is `192.168.0.42` public or private? How do you know?"

### Day 2 — Ports, services, and the models
- **Warm-up (5–10 min):** Apartment-building analogy review: one street address (IP), many apartment doors (ports).
- **Direct instruction (15–20 min):** Ports and the common-services table (FTP, SSH, Telnet, SMTP, DNS, HTTP, HTTPS, SMB, RDP). Introduce the OSI 7-layer and TCP/IP 4-layer models — kept practical: "what layer does an IP address live at vs a port vs HTTP?"
- **Guided practice (15 min):** Fill in the OSI/TCP-IP layer worksheet; match ports to services as a quick game.
- **Independent practice / lab:** Continue TryHackMe room — ports & protocols sections.
- **Closure / exit ticket (5 min):** "Name the port for HTTPS, SSH, and DNS."

### Day 3 — TCP vs UDP and the three-way handshake
- **Warm-up (5–10 min):** "Phone call vs dropping a postcard in the mail — which confirms the other side received it?" (TCP vs UDP.)
- **Direct instruction (15–20 min):** TCP (reliable, ordered, connection) vs UDP (fast, no guarantee). Walk the three-way handshake on the board: SYN → SYN-ACK → ACK. Examples: web/SSH use TCP; DNS lookups and video streaming often use UDP.
- **Guided practice (15 min):** Students diagram the handshake from memory and label each packet's flags.
- **Independent practice / lab:** TryHackMe room — TCP/UDP sections; finish room if time allows.
- **Closure / exit ticket (5 min):** "Put SYN, ACK, SYN-ACK in the right order."

### Day 4 — DNS, packets, firewalls, and a first capture
- **Warm-up (5–10 min):** "You type `example.com`. Your computer doesn't know what that means yet. What has to happen first?"
- **Direct instruction (15–20 min):** Trace a DNS resolution (stub resolver → recursive resolver → root/TLD/authoritative → answer). Anatomy of a packet (headers + payload). Firewalls as rule-based filters (allow/deny by port/IP). Introduce Wireshark and tcpdump conceptually.
- **Guided practice (15 min):** Instructor demo: open Wireshark, start a capture, run `ping` and load a web page, stop the capture, point out DNS, ICMP, and TCP packets.
- **Independent practice / lab:** Students begin the Wireshark capture lab (see `lab.md`) — first capture of a ping.
- **Closure / exit ticket (5 min):** "What does a DNS query ask for, and what does it get back?"

### Day 5 — Capture lab + putting it together
- **Warm-up (5–10 min):** Revisit Day-1 sketches: now redraw "how a text/web request travels" with the new vocabulary.
- **Direct instruction (10 min):** Read the **Safety & authorization reminder** in `lab.md` aloud; review the ethics callout (wiretapping). Quick review of display filters (`tcp`, `dns`, `ip.addr ==`).
- **Guided practice / independent lab:** Complete the Wireshark lab — capture a web page load, identify protocols/IPs/ports, and locate the three-way handshake. Annotate findings in the lab journal.
- **Closure / exit ticket (5 min):** Submit lab journal page; one-sentence "biggest surprise" reflection.
- **Assessment:** Unit quiz (`assessment.md`) may be given at end of Day 5 or start of Week 4.

## Differentiation
- **Support:** Provide the completed common-ports card and a pre-filled OSI/TCP-IP diagram to annotate rather than build from blank. Pair students for captures. Offer a provided `.pcap` so analysis isn't blocked by capture permissions. Sentence frames for journal entries ("This packet uses ___ protocol, from IP ___ to IP ___ on port ___ because ___.").
- **Extension:** Have students capture and decode an HTTPS handshake (note that contents are encrypted but the handshake/SNI is visible), explore `tcpdump` on the command line, or complete a second TryHackMe networking room. Challenge: filter the capture to show only the three handshake packets using a Wireshark display filter and explain the filter.

## Homework / independent work
- Finish the TryHackMe networking room if not completed in class (browser-based, free).
- Complete the common-ports table from memory and self-check against the card.
- Short write-up (½ page): "Trace what happens, step by step, from typing `school.edu` in your browser to seeing the page" — using at least 6 unit vocabulary terms.

## Assessment
- **Formative:** Daily exit tickets; ports-matching game; handshake diagram check; instructor walk-around during captures.
- **Summative:** Unit quiz + annotated packet-capture deliverable — see `assessment.md`.

## Instructor notes & common pitfalls
- **Capture permissions are the #1 failure point.** Test on the actual classroom machines before Day 4. Have the backup `.pcap` ready. Loopback capture is a reliable fallback.
- Students confuse **IP vs MAC** — reinforce: IP can change (it's logical/where you are), MAC is fixed (it's the hardware). Reinforce: routing across the internet uses IP; delivery on the local segment uses MAC.
- Students mix up **public vs private ranges** — memorize the three private blocks: `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`.
- Don't over-teach all 7 OSI layers — keep it to "which layer is this thing on?" The TCP/IP 4-layer model is what they'll actually use.
- The handshake direction trips students up: **SYN-ACK comes back from the server**, not a second packet from the client.
- Keep the wiretapping ethics point concrete and recurring — students are tempted to "just look" at other traffic. Name it as illegal interception.
