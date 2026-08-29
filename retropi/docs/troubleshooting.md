# Troubleshooting

Get a shell: ssh in (`ssh pi@retropi.local`), or press `Ctrl+Alt+F2` on an
attached keyboard for tty2 — tty1 belongs to the game session.

## Black screen, nothing happens

```bash
systemctl status 'retropi-session@*'
journalctl -u 'retropi-session@*' -b --no-pager | tail -50
```

Common causes:

- **X will not start for a non-console user.** `/etc/X11/Xwrapper.config` must
  say `allowed_users=anybody`. The installer sets this; a Pi OS update can
  reset it.
- **A getty is fighting for tty1.** `sudo systemctl disable --now getty@tty1`.
- **No frontend installed and no network to fetch one.** Check for
  `/opt/retropi/share/ES-DE.AppImage`. Without it the session falls back to
  RetroArch's menu, which should still appear — if even that fails,
  `sudo retropi-update --frontend`.

## Frontend loops or restarts

`retropi-frontend` deliberately relaunches on a crash rather than dropping you
to a console, so a crash loop looks like a flickering screen. The reason is in
`journalctl -u 'retropi-session@*' -b`.

An ES-DE AppImage needs FUSE: `sudo apt install libfuse2`. Without it the
AppImage exits immediately with a mount error.

## No sound

```bash
aplay -l                       # is the HDMI device listed?
alsamixer                      # unmute, turn up
```

HDMI audio needs `dtparam=audio=on` in `config.txt` and the TV selected as the
default sink. For a Bluetooth speaker or headset, `pulseaudio-module-bluetooth`
is installed — pair it with `bluetoothctl` by hand; the pairing daemon only
touches gamepads on purpose.

## Games run slowly

- Confirm the GL driver: `dtoverlay=vc4-kms-v3d` must be in `config.txt` and
  `glxinfo | grep renderer` should mention V3D, not llvmpipe.
- In RetroArch, `video_driver = "glcore"` and vsync on. Threaded video helps on
  a Pi 3 and hurts on a 4/5.
- N64, Saturn, Dreamcast and PSP are the hard cases. Use `mupen64plus-next` with
  the GLideN64 plugin for N64 and expect per-game tuning.
- If games are on a network share over Wi-Fi, large discs stutter on load.
  Either move that system to local storage or use ethernet.

## Network library will not mount

```bash
sudo retropi-library status
systemctl status "$(systemd-escape -p --suffix=mount /mnt/retropi-library)"
sudo mount -t cifs //HOST/SHARE /mnt/retropi-library -o guest   # test by hand
```

Most SMB failures are the protocol version or credentials. The mount uses
`vers=3.0`; an old NAS may need `vers=2.0` or `vers=1.0` — edit
`/etc/systemd/system/*retropi-library.mount` and `systemctl daemon-reload`.

## Wizard reappears, or never appeared

The marker is `/var/lib/retropi/firstboot.done`. Delete it to make the wizard
run again on next boot, or run `retropi-setup` at any time.

## Start over

```bash
sudo rm -rf ~/.config/retroarch ~/ES-DE
sudo ./install.sh
```

Games in `~/ROMs` and settings in `retropi.conf` are left alone.

## Useful logs

```bash
journalctl -u retropi-btpair -b --no-pager      # pairing
journalctl -u retropi-library -b --no-pager     # library mounts
journalctl -u 'retropi-session@*' -b --no-pager # session and frontend
~/.config/retroarch/logs/                       # per-core emulator logs
```
