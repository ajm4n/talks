# Testing

Four tiers, cheapest first. The honest summary: **a VM tests all of the
software and none of the hardware.** Everything except Bluetooth pairing and
GPU rendering can be verified without a Pi.

| tier | command | seconds | what it proves |
|---|---|---|---|
| 1 static | `./test/lint.sh` | ~5 | syntax, unit files, sudoers, XML, no dangling paths |
| 2 unit | `./test/unit/run.sh` | ~60 | the pairing state machine, config parsing, library and streaming logic — against stubbed hardware |
| 3 container | `./test/container-test.sh` | ~90 | `install.sh` puts the right things on disk, and is safe to run twice |
| 4 VM | `./test/run-qemu.sh` | minutes | the whole stack: packages, systemd, X, samba, mounts |

Tiers 1–3 need no Pi, no root, no VM. Run them before you flash anything.

## Tier 2: how the hardware is faked

`test/stubs/bluetoothctl` is a working fake of the parts of `bluetoothctl` that
`retropi-bt-pair` uses. Devices are declared in a text file:

```
MAC|Name|Icon|Class|paired|connected|appears_after_seconds
```

That last field models a pad that only shows up once scanning starts, which is
the case the real pairing loop exists to handle. The stub records every command
issued, so tests can assert on behaviour rather than just outcome — for example
that an already-paired pad is reconnected and *not* re-paired, and that the pad
is `trust`ed, which is the thing that makes it reconnect by itself forever after.

The suite covers a pad recognised by name, by BlueZ icon, and by device class;
a headset and a keyboard being correctly ignored; a pad that refuses to pair;
and `forget` removing pads while leaving other devices alone.

## Tier 4: what a VM can and cannot do

```bash
./test/run-qemu.sh                  # Debian VM, x86 with KVM, fast
./test/run-qemu.sh --arch arm64     # emulated arm64, slower, closer to a Pi
./test/run-qemu.sh --image out.img  # boot a real built image on an emulated Pi 4
```

The default mode boots a plain Debian VM with this repo shared in over 9p.
Inside it:

```bash
mkdir -p /mnt/retropi
mount -t 9p -o trans=virtio,version=9p2000.L retropi /mnt/retropi
cd /mnt/retropi && ./install.sh && ./test/smoke-test.sh
```

`install.sh` splits its packages into required and optional precisely so this
works: `pi-bluetooth` and friends are absent on plain Debian and are skipped
with a warning instead of aborting.

**Works in a VM:** the installer end to end, package resolution, systemd units
coming up, the X session starting, Samba, SMB/NFS library mounts (point them at
a share on your host), the USB import path (attach a disk image), the config
file plumbing, and the first-boot wizard's screens.

**Does not work in a VM:**

- **Bluetooth pairing.** QEMU emulates no usable Bluetooth adapter. The only
  real fix is to pass a USB dongle through — add
  `-device qemu-xhci -device usb-host,vendorid=0x...,productid=0x...` to the
  QEMU line and the guest gets a genuine adapter, at which point pairing is
  testable for real. Otherwise rely on tier 2.
- **GPU rendering.** No VideoCore, so RetroArch falls back to software GL and
  the frontend is slow or blank. Proves nothing about performance.
- **Pi-specific boot config.** `config.txt` and `cmdline.txt` edits are applied
  but never consumed — only real firmware reads them.
- **`--image` mode limits.** QEMU's `raspi4b` has no GPU and unreliable
  networking. Use it to confirm the image boots and units start, over serial;
  not for anything visual.

## Tier 4b: on the actual Pi

`test/smoke-test.sh` is the same script and is the right thing to run over ssh
after a first boot. On real hardware every check should pass with zero
warnings; in a VM, warnings about the ES-DE download, moonlight, and the KMS
overlay are expected and are printed as warnings rather than failures for
exactly that reason.

## CI

Tiers 1–3 are self-contained and need only bash, python3 and a container
runtime:

```bash
./test/lint.sh && ./test/unit/run.sh && ./test/container-test.sh
```

`install.sh` honours `RETROPI_SKIP_PACKAGES=1`, `RETROPI_NO_SERVICES=1` and
`RETROPI_OFFLINE=1` for this. Those exist for containers and CI only — on real
hardware you want all three stages to run and to fail loudly.
