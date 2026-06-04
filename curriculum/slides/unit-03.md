---
marp: true
theme: default
paginate: true
header: "Introduction to Offensive Security · Unit 03"
footer: "Curriculum by AJ Hammond — PNPT, CRTO, OSCP, BSCP"
---

<!-- _class: lead -->

# Unit 03 — Networking Fundamentals

You can't attack — or defend — a network you don't understand.

<!-- Week 3. We teach networking from zero; nothing is assumed. This makes the rest of the course make sense. -->

---

# Learning Objectives

By the end of this unit you can:

- **Describe** how data travels from one device to another.
- **Tell apart** an IP address and a MAC address.
- **Identify** an IPv4 address as public or private.
- **Match** 8+ common ports to their services.
- **Explain** TCP vs. UDP and give an example of each.
- **Diagram** the TCP three-way handshake (SYN → SYN-ACK → ACK).
- **Relate** the TCP/IP 4-layer model to the OSI model.
- **Trace** a DNS lookup; **capture** live traffic in Wireshark.

---

# What is a network?

- A **network** = two or more devices connected to share data.
- A **host** = any device on it (computer, phone, printer, server).
- A **router** forwards packets between different networks.

> Warm-up: how does a text you send actually reach your friend's phone? We'll answer it by Day 5.

---

# IP vs. MAC address

| | IP address | MAC address |
|--|-----------|-------------|
| **What** | Numeric network address | Hardware ID on the network card |
| **Example** | `192.168.1.10` | `00:1A:2B:3C:4D:5E` |
| **Changes?** | Yes — logical, *where you are* | No — fixed to the device |
| **Used for** | Routing across the internet | Delivery on the local segment |

> IP = your mailing address. MAC = your name on the mailbox.

<!-- Students confuse these constantly. Reinforce: IP can change, MAC is fixed. -->

---

# Public vs. private IPs

- **Public IP** — reachable on the open internet.
- **Private IP** — used only inside a local network.

**Memorize the three private blocks:**

- `10.0.0.0/8`
- `172.16.0.0/12`  (that's `172.16` – `172.31`)
- `192.168.0.0/16`

> Exit-ticket style: is `192.168.0.42` public or private? How do you know?

---

# Ports & services

A **port** is a numbered "door" on a host; one IP, many doors (like apartment numbers).

| Port | Service | Port | Service |
|------|---------|------|---------|
| 20/21 | FTP | 80 | HTTP |
| 22 | SSH | 443 | HTTPS |
| 23 | Telnet | 445 | SMB |
| 25 | SMTP | 3389 | RDP |
| 53 | DNS | | |

<!-- Day 2: run the ports-matching game. Exit ticket: name the port for HTTPS, SSH, and DNS. -->

---

# The two models

| TCP/IP (4 layers) | What lives here |
|-------------------|-----------------|
| **Application** | HTTP, DNS, the apps you use |
| **Transport** | TCP / UDP, **ports** |
| **Internet** | IP addresses, routing |
| **Link** | cables, Wi-Fi, **MAC** |

The **OSI model** is a 7-layer reference map. Keep it practical: *which layer is this thing on?*

---

# TCP vs. UDP

| | TCP | UDP |
|--|-----|-----|
| **Style** | Connection-based | Connectionless |
| **Reliable?** | Yes — confirms delivery | No guarantee |
| **Speed** | Slower | Fast |
| **Use** | Web, SSH | DNS, video streaming |

> Phone call (TCP) vs. dropping a postcard in the mail (UDP).

---

# The three-way handshake

How every TCP connection starts:

```
Client  ──  SYN      ──▶  Server
Client  ◀── SYN-ACK  ──   Server
Client  ──  ACK      ──▶  Server   ✅ connected
```

- **SYN** — client asks to connect.
- **SYN-ACK** — server agrees (one packet, from the server).
- **ACK** — client confirms.

<!-- Common error: students expect TWO SYNs. The SYN-ACK is a single packet back from the server. -->

---

# DNS — the internet's phonebook

You type `example.com`; your computer doesn't know what that means yet.

1. Your device asks a **recursive resolver**.
2. It walks **root → TLD → authoritative** servers.
3. The answer comes back: an **IP address** (an A record).
4. Your browser connects to that IP.

> A DNS query asks "what's the IP for this name?" and gets an address back. Usually **UDP port 53.**

---

<!-- _class: lead -->

# ⚖️ Ethics & Authorization

## Packet capture is **wiretapping** when the traffic isn't yours.

Capturing on a network you **own or are authorized to test** (this lab, your home network) is fine. Capturing other people's traffic — public Wi-Fi, the school network outside this lab — can be a **crime**, even if you "just looked."

> The line is always **authorization and scope.**

<!-- Discussion: "I ran Wireshark at the coffee shop but didn't DO anything with it." Ethical? Legal? Does intent change it? -->

---

# Key vocabulary

| Term | Quick definition |
|------|------------------|
| IP / IPv4 | Numeric device address, e.g. `192.168.1.10` |
| Public / Private IP | Reachable on the internet / local-only |
| MAC address | Fixed hardware ID on a network card |
| Port | Numbered "door" a service listens on |
| Service | A program that answers requests on a port |
| Protocol | Agreed rules for how devices talk |
| TCP / UDP | Reliable+slower / fast+no-guarantee |
| Three-way handshake | SYN → SYN-ACK → ACK |

---

# More vocabulary

| Term | Quick definition |
|------|------------------|
| Packet | A small chunk of data wrapped with addressing info |
| DNS | Turns names into IP addresses (the phonebook) |
| OSI / TCP-IP model | 7-layer reference / practical 4-layer model |
| Firewall | Filter that allows or blocks traffic by rules |
| Router | Forwards packets between networks |
| Wireshark | Graphical packet capture/inspection tool |
| tcpdump | Command-line packet capture tool |

---

# Lab launch — Capture & read traffic

**Platform:** **TryHackMe** networking room (browser) **and Wireshark** on your lab machine.

You will:

1. Finish the **TryHackMe networking room.**
2. Find **your own IP and MAC** (`ip addr` / `ipconfig /all`); label your IP public or private.
3. **Capture a ping** and filter `icmp`; record a request/reply pair.
4. **Capture a web load + DNS**; record name asked → IP returned.
5. **Find the three-way handshake** (`tcp.port == 80`) and annotate 3 packets.

> Capture **only** on the interface your instructor authorizes — never other people's traffic.

📄 Full instructions: `unit-03-networking-fundamentals/lab.md`

---

# Recap

- A **network** connects hosts; **routers** move packets between networks.
- **IP** can change (where you are); **MAC** is fixed (the device).
- Private blocks: `10`, `172.16–31`, `192.168`. Know the **common ports.**
- **TCP** = reliable; **UDP** = fast. Connections start with **SYN → SYN-ACK → ACK.**
- **DNS** turns names into IPs. Capturing others' traffic = **wiretapping.**

---

<!-- _class: lead -->

# Exit ticket / discussion

**Discuss:** A student says, "I ran Wireshark at the coffee shop and saw other people's traffic — but I didn't *do* anything with it." Ethical? Legal? Does intent change the answer?

**Write:**
- Put `SYN`, `ACK`, `SYN-ACK` in the right order.
- Name the port for HTTPS, SSH, and DNS.
- One-sentence "biggest surprise" from the capture lab.
