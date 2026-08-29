# RetroPi

A build kit that turns a Raspberry Pi into a console: power on, it lands in a
game menu, your Bluetooth pad is already connected, and nothing wants a
keyboard ever again. The whole experience feels like a PS5 or Switch — black
boot, splash screen, controller auto-pairs, and you are playing.

## Getting it running

```bash
# 1. Flash Raspberry Pi OS Lite (64-bit) with Raspberry Pi Imager.
#    Set your username, Wi-Fi and enable SSH in Imager's settings screen.
# 2. On the Pi:
git clone <this repo> && cd retropi
sudo ./install.sh && sudo reboot
```

That is it. The install pulls down the frontend, cores and controller profiles,
so once it finishes the Pi needs no network to play anything local.

There is also `build-image.sh`, which drives pi-gen to produce a flashable
`.img.xz`. See *Status* below.

## What you get

| | |
|---|---|
| **Boot experience** | Silent boot with no kernel messages, a centered "Starting RetroPi..." splash, then straight into the ES-DE frontend. No desktop, no login prompt, no cursor. Like turning on a console. |
| **Controllers** | `retropi-btpair` scans, pairs, trusts and reconnects Bluetooth gamepads on its own. Hold the pad's pair button — that is the whole procedure. Aggressive 15-second reconnect on boot means your controller is ready before the menu appears. Works with 8BitDo, DualShock 4, DualSense, Xbox Wireless, Switch Pro, Razer, PowerA, Backbone, GuliKit, and more. |
| **Emulation** | RetroArch with a tuned console-grade config: integer scaling, rewind, auto save-states, notification suppression, sorted saves, and the libretro controller profiles so a pad works the second it connects. Cores from Debian, plus RetroArch's own online updater for the rest. |
| **Frontend** | ES-DE (EmulationStation Desktop Edition), pre-configured with dark theme, slide transitions, navigation sounds, and favorites support. Falls back to RetroArch's Ozone menu after 5 crashes. Shutdown and reboot from the menu work. |
| **Library** | Games on the SD card, on a USB stick (plug it in, it imports itself), or on a NAS share mounted on demand so they play over the network without filling the card. `~/ROMs` is also shared over SMB. |
| **Library portal** | Web UI at `http://retropi.local:8080` — drag game files in from any browser on your network, see what is installed, check BIOS status. Set `portal_token` if you want auth. |
| **Streaming** | Moonlight is wired into the frontend as its own "system". Point it at a PC running Sunshine and that PC's library shows up next to your emulated systems. |
| **First boot** | A styled on-screen wizard: Wi-Fi, controller pairing (with instructions for every major pad), where your games live, streaming host. Every answer can be pre-filled in `retropi.conf` on the boot partition. |

Hotkeys, in game, all held with **Select**: `Start` quit · `X` RetroArch menu ·
`R1`/`L1` save/load state · `R2` fast-forward · `L2` rewind.

## Controller auto-pairing

The BT daemon runs at all times. It:
1. On boot, aggressively reconnects any previously-paired controller within 15 seconds
2. If nothing reconnects, opens a pairing window and scans for new controllers
3. Recognises pads by BlueZ icon, device class, or name (covers 25+ brands)
4. Trusts on first pair so it auto-reconnects forever after
5. The session waits for a controller before launching the frontend, with a
   "Hold the pair button on your controller..." message if needed

Supported out of the box: **8BitDo**, **DualShock 4**, **DualSense**, **Xbox Wireless**,
**Switch Pro/Joy-Con**, **Stadia**, **Razer**, **PowerA**, **Backbone**, **GuliKit**,
**HyperKin**, **HORI**, **SteelSeries**, **GameSir**, **iPega**, and anything that
identifies as `input-gaming` via BlueZ or has a gamepad device class.

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
| `retropi-portal` | the library web UI (normally run by `retropi-portal@<user>.service`) |

## Testing

Four tiers, cheapest first:

```bash
./test/lint.sh            # syntax, systemd units, sudoers, XML, dangling paths
./test/unit/run.sh        # pairing logic, config, library, streaming - stubbed hardware
./test/container-test.sh  # install.sh puts the right things on disk, twice over
./test/run-qemu.sh        # a real VM: packages, systemd, X, samba, mounts
```

## Status

| | |
|---|---|
| Script logic (pairing, config, library, streaming, portal) | tested |
| `install.sh` file placement, ownership, idempotency | tested |
| Units, sudoers, XML, path consistency | tested |
| ES-DE download URL | verified - resolves via the release API |
| `build-image.sh` | fixed: qemu-arm symlink and binfmt handler check. Untested end-to-end on a normal host. |
| On real Pi hardware | **not verified.** Run `test/smoke-test.sh` after first boot. |

## Requirements

Raspberry Pi 4 or 5 (a 3B+ works for anything up to N64/PSX), 64-bit Raspberry
Pi OS **Bookworm Lite**, and a wired or Wi-Fi connection for the first boot's
downloads. Building an image needs a Debian/Ubuntu host, root, and roughly 10GB
of scratch space.

See `docs/` for the details.
