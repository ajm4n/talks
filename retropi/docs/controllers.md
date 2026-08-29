# Controllers

## How pairing works

`retropi-btpair.service` runs `retropi-bt-pair daemon` from boot. Its loop:

1. Reconnect anything already paired that looks like a gamepad.
2. If nothing is connected, open a 45-second discovery window with a
   `NoInputNoOutput` agent, so pads that expect a PIN prompt just pair.
3. Anything matching a gamepad — by BlueZ icon (`input-gaming`), by device
   class, or by a name pattern covering the usual suspects and the usual
   clones — gets paired, trusted and connected.
4. Back off 15 seconds and repeat.

Trusting matters more than pairing: it is what lets the pad reconnect on its
own next time you switch it on, without the Pi scanning.

## Putting a pad into pairing mode

| Pad | Combo |
|---|---|
| 8BitDo (SN30/Pro 2/Ultimate) | hold `Start` to power on, then hold `Select` ~3s until the LEDs run |
| DualShock 4 | hold `Share` + `PS` until the bar flashes fast |
| DualSense | hold `Create` + `PS` |
| Xbox Wireless | hold the pair button on the back until the logo flashes fast |
| Switch Pro | hold `Sync` on the top edge |
| 8BitDo receivers | pair the receiver over USB instead; no Bluetooth needed |

8BitDo pads have several modes. Use **X-input** (`Start`+`X` on power-on) or
**D-input** (`Start`+`B`); Switch mode reports axes that RetroArch maps oddly.

## Manual control

```bash
retropi-bt-pair pair 90     # 90-second pairing window
retropi-bt-pair status      # what is connected right now
retropi-bt-pair forget      # unpair every gamepad and start over
sudo systemctl restart retropi-btpair
```

## Button mapping

RetroArch identifies a pad by USB/BT vendor and product ID and loads a matching
profile from `~/.config/retroarch/autoconfig`. `retropi-update --autoconfig`
installs the libretro profile set, which covers several hundred pads — this is
why you normally never see a mapping screen.

For a pad with no profile: RetroArch menu → Settings → Input → Port 1 Controls
→ Set All Controls, then "Save Controller Profile". Drop the resulting `.cfg`
in `~/.config/retroarch/autoconfig` and it is permanent.

## Hotkeys

`Select` is the hotkey modifier, so nothing below fires during normal play:

| Combo | Action |
|---|---|
| Select + Start | quit back to the frontend |
| Select + X | RetroArch menu |
| Select + R1 | save state |
| Select + L1 | load state |
| Select + R2 | fast-forward |
| Select + L2 | rewind |
| Select + Y | screenshot |
| Select + D-pad L/R | previous / next save slot |

Button numbers live in `/opt/retropi/share/retroarch/retroarch.cfg` as
`input_*_btn`. Pads that number their buttons differently need those adjusted;
`evtest` or `jstest /dev/input/js0` will tell you which index is which.

## DualShock 3

DS3 pads are not standard Bluetooth HID and need a USB handshake to pair. They
are deliberately not handled by the daemon. Plug one in over USB and it works
as a wired pad.

## Troubleshooting

**Pad connects then drops.** Almost always 2.4GHz congestion between Bluetooth
and Wi-Fi on the Pi's shared radio. Move to 5GHz Wi-Fi, or use ethernet.

**Pad connects but does nothing in games.** It connected after RetroArch
started. Quit to the frontend and relaunch; RetroArch enumerates pads at start.

**Nothing is found at all.** `sudo systemctl status bluetooth` and
`bluetoothctl show` — if there is no controller, `pi-bluetooth` is missing or
`dtoverlay=disable-bt` is set in `config.txt`.
