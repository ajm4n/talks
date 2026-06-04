---
marp: true
theme: bootstrap
paginate: true
header: "Introduction to Offensive Security · Unit 03"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Networking Fundamentals
## Unit 03 — Technical Foundations

You can't attack — or defend — a network you don't understand. This week we learn how data actually travels, from zero.

<!-- Week 3, ~5 class periods. PEN-200 assumes you know TCP/IP; this course does not. Teach it from scratch. Capture permissions are the #1 failure point — test machines before Day 4 and have a backup .pcap ready. -->

---

# Learning objectives

By the end of this unit you can:

- **Describe**, in order, how data travels from one device to another.
- **Distinguish** an IP address from a MAC address.
- **Identify** an IPv4 address as public or private.
- **Match** 8+ common ports to their services.
- **Explain** TCP vs. UDP and give a use of each.
- **Diagram** the TCP three-way handshake (SYN → SYN-ACK → ACK).
- **Describe** the 4-layer TCP/IP model and relate it to the OSI model.
- **Trace** a DNS lookup from a name to an IP.
- **Capture** live traffic in Wireshark and identify protocol, IPs, and ports.

---

# What is a network?

- A **network** = two or more devices connected to share data.
- A **host** = any device on it (computer, phone, printer, server).
- A **router** forwards packets between different networks.
- A **packet** = a small chunk of data wrapped with addressing info.

> Big picture: data is chopped into packets, each labeled with where it's from and where it's going, then forwarded hop by hop.

---

# IP vs. MAC address

| | IP address | MAC address |
|--|-----------|-------------|
| Looks like | `192.168.1.10` | `00:1A:2B:3C:4D:5E` |
| What it is | Logical address — *where* you are | Hardware ID burned into the card |
| Changes? | Yes (it's where you are now) | No (fixed to the device) |
| Used for | Routing across the internet | Delivery on the local segment |

<!-- The classic mix-up. IP = mailing address (can change); MAC = your name on the mailbox (fixed). -->

---

# Public vs. private IPs

These three blocks are **private** — used inside a local network, not directly reachable from the internet:

- `10.0.0.0/8` → `10.x.x.x`
- `172.16.0.0/12` → `172.16.x` through `172.31.x`
- `192.168.0.0/16` → `192.168.x.x`

Everything else routable is **public**. Loopback is `127.0.0.1`.

<!-- Memorize the three private blocks — students mix these up constantly. Quick game: sort sample IPs public vs private. -->

---

# Ports & services

One host (one IP) can run many services — each listens on a numbered **port** (like apartment doors at one street address).

| Port | Service | Port | Service |
|------|---------|------|---------|
| 20/21 | FTP | 80 | HTTP |
| 22 | SSH | 443 | HTTPS |
| 23 | Telnet | 445 | SMB |
| 25 | SMTP | 3389 | RDP |
| 53 | DNS | | |

<!-- Run ports-to-services as a quick matching game. A protocol is the agreed rules; a service is the program answering on the port. -->

---

# TCP/IP & OSI models

| TCP/IP (4 layers) | Example | OSI (rough) |
|-------------------|---------|-------------|
| **Application** | HTTP, DNS, SSH | 5–7 |
| **Transport** | TCP, UDP (**ports**) | 4 |
| **Internet** | IP (**IP addresses**) | 3 |
| **Link** | Ethernet (**MAC**) | 1–2 |

> Don't memorize all 7 OSI layers — just answer "which layer is this thing on?" The 4-layer model is what you'll actually use.

---

# TCP vs. UDP

| | TCP | UDP |
|--|-----|-----|
| Connection? | Yes — confirms delivery | No — just sends |
| Speed | Slower, reliable, ordered | Fast, no guarantee |
| Use it for | Web, SSH, file transfer | DNS lookups, video/voice streaming |

> Analogy: TCP is a **phone call** (you confirm the other side hears you). UDP is **dropping a postcard** in the mail.

---

# The TCP three-way handshake

```
Client  ──── SYN ────▶  Server     (1) "Can we talk?"
Client  ◀── SYN-ACK ──  Server     (2) "Yes — can you hear me?"
Client  ──── ACK ────▶  Server     (3) "Yes. Connected."
```

- **SYN-ACK comes back from the server** — it's **one** packet, not two SYNs.
- After ACK, the connection is established and data flows.

<!-- The direction trips students up: there is only ONE SYN from the client. The SYN-ACK is a single packet from the server. -->

---

# DNS: the internet's phonebook

1. You type `example.com` — your computer doesn't know its IP yet.
2. **Stub resolver** asks a **recursive resolver**.
3. Resolver walks **root → TLD → authoritative** servers.
4. An **A record** (the IPv4 address) comes back.
5. Your browser connects to that IP.

> DNS queries usually ride **UDP port 53**. A query asks "what's the IP for this name?"; the response carries the answer.

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

## Packet capture is wiretapping when the traffic isn't yours.

Capturing on a network you **own or are authorized to test** (this classroom lab, your own home network) is fine. Capturing **other people's** traffic — public Wi-Fi, a friend's network, the school network outside this lab — can break wiretap and computer-crime laws **even if you "just looked."**

The dividing line, as always, is **authorization and scope.**

<!-- Discussion: "I ran Wireshark at the coffee shop and saw other people's traffic — but I didn't DO anything." Legal? Ethical? Does intent change it? Where's the line between curiosity and interception? -->

---

# Reading packets: Wireshark & tcpdump

- **Wireshark** = a graphical tool to capture and inspect packets.
- **tcpdump** = the command-line version.
- **Display filters** let you focus the view:

| Filter | Shows |
|--------|-------|
| `icmp` | Ping (echo request/reply) packets |
| `dns` | DNS queries and responses |
| `tcp.port == 80` | HTTP traffic |
| `ip.addr == <IP>` | All traffic to/from one host |

<!-- A firewall is just a rule-based filter (allow/deny by port/IP). ICMP has no ports — it rides directly on IP. -->

---

# Key vocabulary

| Term | Meaning |
|------|---------|
| **IP / MAC address** | Logical (changeable) address / fixed hardware ID |
| **Public / Private IP** | Reachable on the internet / local-network only |
| **Port / Service** | A numbered door / the program answering on it |
| **Protocol** | Agreed rules for two devices talking (HTTP, DNS, TCP) |
| **TCP / UDP** | Reliable & connection-based / fast & connectionless |
| **Three-way handshake** | SYN → SYN-ACK → ACK to start a TCP connection |
| **DNS** | Turns names like `example.com` into IP addresses |
| **Packet / Wireshark / tcpdump** | Chunk of data / GUI capture tool / CLI capture tool |

---

# Lab launch

**Platform:** TryHackMe networking room (browser, free tier) **and** Wireshark on your lab machine.

- Finish the **TryHackMe networking room** to lock in concepts.
- Find your own **IP + MAC** (`ip addr` / `ipconfig /all`); label public or private.
- **Capture** a ping (`icmp`), then a web page load + DNS lookup.
- **Locate the three-way handshake** (SYN → SYN-ACK → ACK) and annotate 3 packets.

→ Full walkthrough in this unit's **`lab.md`**. Capture **only** on the interface your teacher authorizes.

<!-- Backup: if live capture fails (permissions/wrong interface), hand out the provided web-request.pcap or use loopback. -->

---

# Recap

- Data travels as **packets**; **IP** routes them, **MAC** delivers locally.
- Three **private** blocks: `10`, `172.16–31`, `192.168`.
- **Ports** map to services; **TCP** is reliable, **UDP** is fast.
- TCP starts with **SYN → SYN-ACK → ACK**.
- **DNS** turns names into IPs.
- Capturing others' traffic without authorization is **wiretapping**.

---

<!-- _class: lead -->

# Exit ticket & discussion

**Exit ticket:** Put `SYN`, `ACK`, and `SYN-ACK` in the correct order — and say which side sends each.

**Discuss:** Where exactly is the line between "I was just curious and looked at the packets" and "I intercepted someone's communications"? What makes the classroom lab capture legal when a coffee-shop capture isn't?

<!-- Submit the annotated lab journal page. Next module: reconnaissance — finding information, the legal way. -->
