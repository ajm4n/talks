# Streaming games from a PC

Moonlight turns the Pi into a thin client for a gaming PC on the same network.
The PC does the work; the Pi decodes an H.264/HEVC stream in hardware and sends
your controller input back. On wired ethernet a Pi 4 or 5 does 1080p60 with
latency you stop noticing after a few minutes.

This is how you play things the Pi cannot emulate — modern PC titles, anything
GPU-heavy, your whole Steam library.

## On the PC

Install **[Sunshine](https://github.com/LizardByte/Sunshine)** (open source,
Windows/Linux/macOS, works with any GPU). Its web UI is at
`https://localhost:47990`. GeForce Experience's built-in GameStream also works
if you still have it, but it is discontinued — Sunshine is the one to use.

Add whatever you want streamable as applications in Sunshine. "Desktop" is
worth keeping around as an escape hatch.

## On the Pi

```bash
sudo retropi-update --streaming    # installs moonlight-embedded
retropi-stream pair 192.168.1.50   # shows a PIN, type it into Sunshine
retropi-stream sync                # writes one launcher per app
```

`sync` writes a `.stream` file per app into `~/ROMs/moonlight/`. ES-DE picks
those up as a system called **Streaming from PC**, so a streamed game launches
from exactly the same menu, with the same controller, as an emulated one.
Re-run `sync` after adding apps in Sunshine.

## Quality

In `retropi.conf`:

```ini
stream_fps     = 60
stream_bitrate = 20000    # kbps; 20000 is right for 1080p60 on wired ethernet
stream_codec   = h264     # hevc on a Pi 5 if the host encodes it
```

Wired ethernet on both ends is worth more than any setting here. On Wi-Fi, use
5GHz and expect to drop the bitrate to about 10000.

## Notes

- Controllers pass straight through, so the pairing setup covers this too.
- `Ctrl+Alt+Shift+Q`, or the pad combo Sunshine is configured with, quits a
  stream back to the frontend.
- The host must be awake. Sunshine can be woken with Wake-on-LAN if the PC and
  the Pi are on the same wired segment.
