# Unit 02 Lab — Build and Verify Your Safe, Isolated Hacking Lab

- **Platform:** TryHackMe (Tier A, browser AttackBox) and/or VirtualBox + Kali Linux + a target VM (Tier B, local). See `instructor/lab-setup-guide.md`.
- **Time:** ~150 min across Days 3–5
- **Difficulty:** Intro / beginner

## 🔒 Safety & authorization reminder
You may only run offensive techniques inside the approved, isolated lab environments provided by your teacher, and only after your Acceptable Use & Ethics Agreement is **signed by you and your guardian** and on file. You may **never** use these techniques against any system, network, account, website, or device you do not own or have **explicit written permission** to test — including the school's systems, classmates' devices, and any website on the internet. Unauthorized access (even scanning or "just looking") is **illegal** under the CFAA and state law; **minors are not exempt.** In this lab you will only set up and test your own isolated environment and the pre-authorized practice targets your teacher provides. **The whole point of this unit is to make sure your lab cannot reach anything it shouldn't.**

## Objectives
- Set up your attack environment (Tier A AttackBox and/or Tier B Kali VM).
- Configure **host-only** networking for local VMs (Tier B).
- **Verify isolation:** reach the target but **not** the internet.
- Take a snapshot (Tier B) and complete an intro room (Tier A).
- Document everything with screenshots in your lab journal.

## Setup
1. Confirm your **AUP is signed and on file.** If not, you cannot start — do the reading alternative your teacher assigns.
2. Open your lab journal and start a new section titled "Unit 02 — Lab Setup." Copy the safety reminder above to the top.
3. Find out from your teacher which **tier(s)** your class is using, and do the matching part(s) below.

> Do **Part A** if you're on TryHackMe (browser). Do **Part B** if you're on local VirtualBox VMs. Some classes do both. Everyone does **Part C (verify) and Part D (document).**

---

## Part A — Tier A: TryHackMe AttackBox + intro room (browser)

### Step 1 — Create your account
1. Go to the TryHackMe site (the exact URL your teacher gives you; it must be allowlisted by IT).
2. Create an account using the school-appropriate details your teacher specifies. Do **not** use a personal password you use elsewhere.
3. **Screenshot to take:** your logged-in dashboard (no password visible).

### Step 2 — Launch the AttackBox
1. Open the intro room your teacher assigned (e.g., *Intro to Cyber Security*).
2. Click **Start AttackBox** (the in-browser machine). Wait for it to load in the split-screen view.
3. The AttackBox is a pre-isolated, sandboxed machine controlled from your browser — you do not install anything.
4. **Screenshot to take:** the AttackBox loaded next to the room.

### Step 3 — Work the room
1. Read each task and answer the room's questions in order.
2. When you finish a task, the platform marks it complete.
3. **Screenshot to take:** the room showing your completed tasks / badge.

> If the AttackBox session times out, just relaunch it — that is normal.

---

## Part B — Tier B: Install VirtualBox, import Kali, set host-only networking (local)

### Step 1 — Confirm prerequisites
1. Your machine has VirtualBox installed (your teacher may have pre-installed it).
2. **VT-x/AMD-V is enabled in BIOS** (your teacher confirms this). If Kali won't start or is painfully slow, this is the usual cause.

### Step 2 — Import the Kali appliance
1. In VirtualBox: **File → Import Appliance**, choose the official Kali VirtualBox image your teacher staged, and import it.
2. Wait for the import to finish; the Kali VM appears in your VM list.

### Step 3 — Set Kali's network to Host-Only
1. Select the Kali VM → **Settings → Network**.
2. Set **Adapter 1** to **Host-Only Adapter** (choose the host-only network your teacher created).
3. ❌ Do **not** select Bridged or NAT for attack labs.
4. Click **OK**.
5. **Screenshot to take:** the Network settings showing **Host-Only Adapter**.

> If you need to update tools first, your teacher may have you temporarily switch to **NAT**, update, then switch **back to Host-Only** and re-verify isolation. Only do this when supervised.

### Step 4 — Boot Kali and find its IP
1. Start the Kali VM and log in (use the credentials your teacher provides; change the default password if instructed).
2. Open a terminal and run:
   ```bash
   ip a
   ```
3. Find Kali's host-only IP address (often in the `192.168.56.x` range). **Write it in your journal.**
4. **Screenshot to take:** the terminal showing Kali's IP.

### Step 5 — Start the target VM (if provided)
1. Start the intentionally-vulnerable target VM (e.g., Metasploitable 2). Confirm it is **also on the same host-only network**.
2. Find or note the target's host-only IP (your teacher may provide it).

---

## Part C — Verify isolation (everyone does this)

This is the most important step in the unit. You must prove your lab can reach its target but **cannot** reach the internet during attacks.

### Tier B verification
1. In the Kali terminal, ping the **target's** host-only IP (replace with your target's IP):
   ```bash
   ping -c 4 192.168.56.102
   ```
   - **Expected:** replies come back (the ping **succeeds**). This proves Kali can reach the lab target.
2. Now ping an **internet** address:
   ```bash
   ping -c 4 8.8.8.8
   ```
   - **Expected:** the ping **fails / times out** (no replies, 100% packet loss). **This failure is the correct, desired result** — it proves your attacks cannot reach the internet.
3. **Screenshots to take:** both results (the successful target ping AND the failed `8.8.8.8` ping).

> If `ping 8.8.8.8` *succeeds*, STOP — your VM is NOT isolated. Check that the adapter is Host-Only (not NAT/Bridged) and tell your teacher before doing anything else.

### Tier A verification
1. You are using the provided **AttackBox/sandbox**, which is already isolated and pre-authorized by the platform. You may only act on the in-scope target the room provides — nothing else.
2. Confirm you are working inside the room's target, not any outside address.
3. **Screenshot to take:** the AttackBox + room confirming you're in the sandboxed environment.

---

## Part D — Snapshot and document (everyone does this)

### Step 1 — Snapshot (Tier B)
1. With Kali in a clean, isolated state, take a snapshot: select the VM → **Snapshots → Take** → name it `clean-isolated`.
2. This is your "undo button." If your VM ever gets broken or "owned," restore this snapshot.
3. **Screenshot to take:** the Snapshots view showing `clean-isolated`.
   (Tier A: note in your journal how to **reset/relaunch** the AttackBox instead.)

### Step 2 — Journal entry
Write a complete setup entry in your lab journal:
- Which **tier(s)** you used.
- Your attack machine's **IP** and **network mode** (Tier B) or that you used the **AttackBox** (Tier A).
- Your **isolation test results** (target ping succeeded; `8.8.8.8` ping failed — or AttackBox/sandbox confirmation).
- Anything that went wrong and how you fixed it ("Try Harder" notes).

## Deliverables
- **Screenshot proof of a working, isolated lab:**
  - Tier A: logged-in dashboard, AttackBox loaded, intro room with completed tasks.
  - Tier B: Network settings showing Host-Only, Kali's IP (`ip a`), successful target ping, **failed `ping 8.8.8.8`**, and the `clean-isolated` snapshot.
- **Lab journal entry** (Part D, Step 2) with the safety reminder at the top.

## Stretch goals (optional)
- Switch Kali to **Internal Network** mode, re-verify isolation, and journal how it differs from host-only.
- Set up a second target (e.g., DVWA) on the same isolated network.
- Create a free **picoCTF** or **OverTheWire (Bandit)** account for later units and log into Bandit level 0 over SSH.
- Write a one-page "how to verify your lab is isolated" mini-guide for classmates.

## Answer key (instructor only)
- **Isolation is correct when:** the attack machine pings the **target successfully** AND `ping 8.8.8.8` **fails** (100% packet loss / timeout). A *successful* `8.8.8.8` ping means the VM is on NAT/Bridged or otherwise not isolated — must be fixed before any attacking.
- **Kali host-only IP:** typically `192.168.56.x` with the default VirtualBox host-only network; the exact value varies. Accept any address on the configured host-only subnet.
- **Network mode check:** Adapter must read **Host-Only Adapter** (or **Internal Network** for the stretch goal). Bridged or NAT is a fail for attack labs.
- **Snapshot:** a `clean-isolated` (or similarly named) snapshot should exist; confirms students can reset.
- **Tier A:** valid screenshots show the platform dashboard, a loaded AttackBox, and the assigned intro room with completed tasks. The platform's targets are pre-authorized and sandboxed; no local isolation steps required.
- **Common failure causes:** VT-x/AMD-V disabled (VM won't boot/very slow); wrong adapter; insufficient RAM; content filter blocking the platform (Tier A). See `instructor/lab-setup-guide.md`.
