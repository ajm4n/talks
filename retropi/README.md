# RetroPi

A build kit that turns a Raspberry Pi into a console: power on, it lands in a
game menu, your Bluetooth pad is already connected, and nothing wants a
keyboard ever again.

Two ways to use it:

```bash
# A) build a flashable image on a Linux box (pi-gen under the hood)
sudo ./build-image.sh --hostname retropi --user pi --pass hunter2
# -> pi-gen/pi-gen/deploy/RetroPi-*-retropi.img.xz

# B) or provision a Pi you already have, on top of Raspberry Pi OS Lite (64-bit)
sudo ./install.sh && sudo reboot
```

## What you get

| | |
|---|---|
| **Controllers** | `retropi-btpair` scans, pairs, trusts and reconnects Bluetooth gamepads on its own. Hold the pad's pair button; that is the whole procedure. Known-good with 8BitDo, DualShock 4, DualSense, Xbox Wireless, Switch Pro. |
| **Emulation** | RetroArch with a tuned baseline config, integer scaling, rewind, auto save-states, and the libretro controller profiles so a pad works the second it connects. Cores from Debian, plus RetroArch's own online updater for the rest. |
| **Frontend** | ES-DE (EmulationStation Desktop Edition), auto-started on tty1 in a bare X session with no desktop behind it. If the download ever fails the session falls back to RetroArch's Ozone menu rather than dumping you at a console. |
| **Library** | Games on the SD card, on a USB stick (plug it in, it imports itself), or on a NAS share mounted on demand so they play over the network without filling the card. `~/ROMs` is also shared over SMB, so you can drag files across from your desktop. |
| **Streaming** | Moonlight is wired into the frontend as its own "system". Point it at a PC running Sunshine and that PC's library shows up next to your emulated systems and launches the same way. |
| **First boot** | A one-time on-screen wizard: Wi-Fi, controller, where your games live, streaming host. Every answer can be pre-filled by editing `retropi.conf` on the boot partition from any machine, in which case the wizard skips it. |

Hotkeys, in game, all held with **Select**: `Start` quit · `X` RetroArch menu ·
`R1`/`L1` save/load state · `R2` fast-forward · `L2` rewind.

## About the Vimm's Lair part

I did not build that, and I want to be straight with you about why rather than
quietly shipping something narrower than you asked for.

Vimm's Lair is a ROM distribution site. Automatically pulling commercial game
ROMs from it and streaming them onto a device is straightforward copyright
infringement, and wiring an "it just downloads the games" pipe into an image
you might hand to other people is the part I'm not willing to write. That is
the only thing I left out.

What is in here instead covers most of what I think you actually wanted out of
it — a library that fills itself without you managing files by hand:

- **USB import.** Drop a `ROMs/` folder on a stick, plug it in, walk away. Good
  for moving your own dumps across.
- **Network library.** Keep the collection on your NAS or desktop; the Pi
  mounts it on demand and plays straight off the share. Nothing is copied, so
  a 400GB library works on an 8GB card. This is the closest thing to "stream
  the games" that is actually yours to stream.
- **SMB share.** `\\retropi\ROMs` from any machine on the network.
- **Moonlight.** Real game streaming, from a PC you own, of games you own —
  including modern PC titles the Pi could never emulate.

If you want the classic library filled out legitimately: dumping your own carts
and discs is well-trodden (a Retrode or a flashcart for carts, any PC drive for
discs), and there is a large body of freely distributable homebrew and
public-domain material that drops straight into `~/ROMs` — the Internet
Archive's software collections, itch.io homebrew, and the libretro project's own
free content. Those all work with everything here as-is.

## Layout

```
build-image.sh              pi-gen wrapper -> flashable .img.xz
install.sh                  provision an existing Pi OS Lite install
config/retropi.conf.example settings, copied to the boot partition
overlay/opt/retropi/bin/    the tools (see below)
overlay/etc/                systemd units, udev rules, sudoers, X config
pi-gen/stage-retropi/       custom pi-gen stage used by build-image.sh
docs/                       controllers, library, streaming, troubleshooting
```

## Commands

| command | what it does |
|---|---|
| `retropi-setup` | re-run the first-boot wizard |
| `retropi-bt-pair pair [secs]` | open a pairing window now |
| `retropi-bt-pair status` \| `forget` | list connected pads / unpair all |
| `sudo retropi-library mount` \| `umount` \| `status` | attach or detach the network library |
| `retropi-stream pair <ip>` \| `list` \| `sync` | set up PC streaming, refresh the app list |
| `sudo retropi-update [--cores\|--frontend\|--autoconfig\|--streaming]` | fetch or refresh the online bits |

## Requirements

Raspberry Pi 4 or 5 (a 3B+ works for anything up to N64/PSX), 64-bit Raspberry
Pi OS **Bookworm Lite**, and a wired or Wi-Fi connection for the first boot's
downloads. Building an image needs a Debian/Ubuntu host, root, and roughly 10GB
of scratch space.

See `docs/` for the details.
