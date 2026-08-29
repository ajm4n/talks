# Game library

Three sources, all optional, all additive. Set them in the wizard or in
`/boot/firmware/retropi/retropi.conf`.

## Local

Games go in `~/ROMs/<system>/`, one directory per system, named the way ES-DE
expects (`snes`, `nes`, `megadrive`, `psx`, `n64`, `gba`, `gb`, `gbc`, `arcade`,
`dreamcast`, …). ES-DE hides any system whose directory is empty, so the menu
only ever shows what you actually have.

The directory is also shared over SMB as `\\retropi\ROMs`, which is usually the
easiest way to fill it — mount it from your desktop and copy.

## From a USB stick

Put a top-level `ROMs/` folder on a stick, with the same per-system layout.
Plug it into the Pi and a udev rule fires `retropi-library import-usb`, which
rsyncs it in and unmounts. Replugging the same stick is a no-op, so it is safe
to leave the folder there.

Turn it off with `usb_import = no`.

## From a NAS or PC share

The interesting one for a big collection: the games stay on the server and the
Pi mounts the share on demand, so an 8GB card can front a library of any size.

```ini
library_type  = smb        # or nfs
library_host  = 192.168.1.20
library_share = ROMs
library_user  = guest
library_pass  =
library_writable = no      # yes if saves should live on the share too
```

Then `sudo retropi-library mount`. It writes a systemd `.mount` plus an
`.automount`, so a NAS that is asleep or switched off never blocks boot — the
share is dialled up the first time the frontend reads it, and released after
ten idle minutes. Each system directory on the share is symlinked into
`~/ROMs`, so local and network systems appear side by side.

`sudo retropi-library status` shows what is attached; `umount` detaches and
removes the links.

Read-only is the default deliberately: it means a failed network write can
never corrupt the share, and save files stay local and fast.

## BIOS files

Several cores need system BIOS files (PlayStation, Saturn, Dreamcast, some
arcade sets). They go in `~/.config/retroarch/system/`. A core that boots to a
black screen is usually a missing or wrong-hash BIOS — RetroArch logs the
expected filename.

## Where games come from

This kit does not fetch commercial ROMs and will not be made to. It handles
whatever you put in front of it:

- **Your own carts and discs.** A Retrode or a flashcart with a save-manager
  dumps cartridges; any PC optical drive plus `cdrdao`/`redumper` handles discs.
  This is the only route that gives you the exact library you already own.
- **Freely distributable material.** There is a lot of it, and it drops straight
  in: homebrew released for free by its authors (itch.io has a deep retro
  homebrew scene), the Internet Archive's software collections, and the
  libretro project's own bundled free content. Plenty of it is genuinely good.
- **PC games you own, streamed.** See `streaming.md` — this covers the modern
  library the Pi could never run locally.
