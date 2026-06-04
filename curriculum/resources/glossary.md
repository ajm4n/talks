# Glossary

Student-friendly definitions of key terms used throughout the course. Terms are introduced in context in their units; this is a one-stop reference.

## Foundations & ethics
- **Offensive security:** The practice of testing systems by attacking them (with permission) to find weaknesses before criminals do.
- **Penetration test (pentest):** An authorized, simulated attack on a system to evaluate its security.
- **Authorization / scope:** Written permission defining exactly what you're allowed to test. The line between legal testing and crime.
- **Ethical hacker / white hat:** Someone who uses hacking skills legally and with permission to improve security.
- **Black hat:** A criminal hacker acting without authorization.
- **Gray hat:** Someone who acts without clear authorization but without malicious intent — still legally risky.
- **CFAA:** Computer Fraud and Abuse Act — the main U.S. anti-hacking law.
- **Responsible/coordinated disclosure:** Privately reporting a vulnerability to the owner so it can be fixed before it's made public.
- **Bug bounty:** A program where organizations pay researchers to report security flaws legally.
- **Red team / blue team:** Attackers (red) vs. defenders (blue) in security exercises.
- **CTF (Capture the Flag):** A security competition where you solve challenges to find "flags" (secret strings).

## Networking
- **IP address:** A numeric label identifying a device on a network.
- **Port:** A numbered endpoint for a specific service on a device (e.g., 80 = web).
- **Protocol:** Rules for how computers communicate (e.g., HTTP, TCP, DNS).
- **TCP/UDP:** Two core transport protocols — TCP is reliable/ordered, UDP is fast/connectionless.
- **DNS:** The system that translates domain names (example.com) into IP addresses.
- **Packet:** A small unit of data sent over a network.
- **Firewall:** A device/software that filters network traffic by rules.

## Linux & scripting
- **Shell / command line / terminal:** A text interface for issuing commands to the OS.
- **Bash:** A common Linux shell and scripting language.
- **Kali Linux:** A Linux distribution preloaded with security tools; the "attack workstation."
- **Root:** The all-powerful administrator account on Linux.
- **Script:** A small program that automates a sequence of commands.
- **Python:** A beginner-friendly programming language widely used in security.

## Reconnaissance
- **Reconnaissance (recon):** Gathering information about a target.
- **Passive recon:** Collecting info without touching the target directly (e.g., public records, OSINT).
- **Active recon:** Directly interacting with the target (e.g., scanning).
- **OSINT:** Open-Source Intelligence — info gathered from publicly available sources.
- **Scanning:** Probing a target to discover hosts, ports, and services.
- **Enumeration:** Digging deeper to list users, shares, services, and versions.
- **nmap:** A popular network scanner.

## Vulnerabilities & exploitation
- **Vulnerability:** A weakness that could be exploited.
- **Exploit:** Code or a technique that takes advantage of a vulnerability.
- **Payload:** The part of an attack that performs the intended action (e.g., a reverse shell).
- **CVE:** Common Vulnerabilities and Exposures — a public catalog ID for a known vulnerability.
- **Exploit-DB:** A public archive of exploit code.
- **Reverse shell / bind shell:** Ways an attacker obtains command-line access to a target.
- **Payload vs. shell:** A payload may deliver a *shell* — interactive command access.

## Web attacks
- **OWASP Top 10:** A standard list of the most critical web app security risks.
- **SQL injection (SQLi):** Inserting malicious SQL to manipulate a database.
- **Cross-site scripting (XSS):** Injecting malicious scripts into web pages viewed by others.
- **Command injection:** Tricking an app into running OS commands.
- **File inclusion (LFI/RFI):** Forcing an app to load files it shouldn't.
- **Burp Suite:** A tool for intercepting and modifying web traffic.
- **DVWA:** Damn Vulnerable Web Application — a practice target.

## Passwords & post-exploitation
- **Hash:** A one-way scrambled representation of data (e.g., a password).
- **Brute force:** Trying many passwords until one works.
- **Dictionary/wordlist attack:** Trying passwords from a prepared list.
- **Hydra / John the Ripper / Hashcat:** Password-attack tools.
- **Privilege escalation:** Gaining higher permissions than you started with (e.g., user → root).
- **Lateral movement:** Moving from one compromised system to others.
- **Pivoting:** Using a compromised machine to reach networks you couldn't reach directly.
- **Metasploit:** A framework that automates exploitation and post-exploitation.
- **Persistence:** Techniques to keep access to a compromised system.

## Reporting & careers
- **Executive summary:** A short, non-technical overview of a report's findings for leadership.
- **Severity / risk rating:** How serious a finding is (often Low/Medium/High/Critical).
- **Remediation:** The recommended fix for a vulnerability.
- **OSCP:** Offensive Security Certified Professional — a hands-on pentesting certification (the goal of PEN-200).
- **Security+:** An entry-level, vendor-neutral security certification.
