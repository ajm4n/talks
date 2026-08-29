#!/usr/bin/env bash
# Turn a stock Raspberry Pi OS (Bookworm, 64-bit, Lite) install into RetroPi.
#
#   curl -fsSL <raw-url>/install.sh | sudo bash
# or, from a clone:
#   sudo ./install.sh
#
# Safe to re-run: every step is idempotent.
set -euo pipefail

SRC_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PREFIX=/opt/retropi
STATE=/var/lib/retropi

log()  { printf '\033[1;36m[retropi]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[retropi]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[retropi]\033[0m %s\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || die "run me with sudo"

# ---------------------------------------------------------------- sanity ----
. /etc/os-release
case "${ID:-}${ID_LIKE:-}" in
    *debian*|*raspbian*) ;;
    *) warn "this expects Raspberry Pi OS / Debian; continuing anyway" ;;
esac
[ "$(dpkg --print-architecture)" = "arm64" ] || warn "64-bit Pi OS is strongly recommended"

TARGET_USER=${SUDO_USER:-$(getent passwd 1000 | cut -d: -f1)}
[ -n "$TARGET_USER" ] || die "could not work out which user to set up"
TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
log "setting up for user '$TARGET_USER' ($TARGET_HOME)"

# -------------------------------------------------------------- packages ----
# Two escape hatches, for containers and CI only. On real hardware you want
# both stages to run and to fail loudly if they cannot.
SKIP_PACKAGES=${RETROPI_SKIP_PACKAGES:-0}
NO_SERVICES=${RETROPI_NO_SERVICES:-0}

if [ "$SKIP_PACKAGES" = 1 ]; then
    warn "RETROPI_SKIP_PACKAGES=1 - not installing any packages"
else
log "installing packages (this is the slow bit)"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq

# Split deliberately: the first list must succeed, the second is Pi-specific or
# release-specific and is allowed to be missing. That is what lets this run in a
# plain arm64/amd64 Debian VM for testing, where pi-bluetooth does not exist.
REQUIRED_PKGS=(
    retroarch
    xserver-xorg xinit x11-xserver-utils unclutter
    libgl1-mesa-dri
    bluez bluez-tools
    alsa-utils
    cifs-utils nfs-common rsync samba samba-common-bin
    curl ca-certificates git jq whiptail unzip p7zip-full
    joystick evtest
)
OPTIONAL_PKGS=(
    pi-bluetooth bluetooth
    mesa-vulkan-drivers
    pulseaudio pulseaudio-module-bluetooth
    network-manager
    fuse libfuse2 libfuse2t64
)

apt-get install -y --no-install-recommends "${REQUIRED_PKGS[@]}" \
    || die "package install failed"

for p in "${OPTIONAL_PKGS[@]}"; do
    apt-get install -y --no-install-recommends "$p" >/dev/null 2>&1 \
        || warn "optional package '$p' unavailable on this release, skipping"
done
fi

# ---------------------------------------------------------------- overlay ----
log "installing RetroPi files"
install -d "$PREFIX" "$STATE"
cp -r "$SRC_DIR/overlay/opt/retropi/." "$PREFIX/"
chmod +x "$PREFIX"/bin/*
cp -r "$SRC_DIR/overlay/etc/." /etc/
chmod 0440 /etc/sudoers.d/retropi
visudo -cf /etc/sudoers.d/retropi >/dev/null || die "sudoers fragment is invalid"

# Put the tools on PATH for the interactive shell too.
install -d /usr/local/bin
for f in "$PREFIX"/bin/*; do
    ln -sf "$f" "/usr/local/bin/$(basename "$f")"
done

# -------------------------------------------------------- users and groups ----
getent group retropi >/dev/null || groupadd retropi
for g in retropi input video audio render bluetooth plugdev tty; do
    getent group "$g" >/dev/null && usermod -aG "$g" "$TARGET_USER"
done

# --------------------------------------------------------- boot-time config ----
BOOTDIR=/boot/firmware
[ -d "$BOOTDIR" ] || BOOTDIR=/boot
install -d "$BOOTDIR/retropi"
if [ ! -f "$BOOTDIR/retropi/retropi.conf" ]; then
    cp "$SRC_DIR/config/retropi.conf.example" "$BOOTDIR/retropi/retropi.conf"
    log "wrote $BOOTDIR/retropi/retropi.conf - editable from any machine on the FAT partition"
fi

CONFIGTXT=$BOOTDIR/config.txt
if [ -f "$CONFIGTXT" ] && ! grep -q '^# --- retropi ---' "$CONFIGTXT"; then
    log "tuning $CONFIGTXT"
    cat >> "$CONFIGTXT" <<'TXT'

# --- retropi ---
# Full KMS driver, the one the GL cores and the frontend both want.
dtoverlay=vc4-kms-v3d
max_framebuffers=2
# Force HDMI output even when the TV is off at boot, so a cold start on a
# switched-off input still comes up at the right resolution.
hdmi_force_hotplug=1
disable_overscan=1
# A little headroom for audio over HDMI.
dtparam=audio=on
TXT
fi

# Quiet, fast boot: no rainbow splash, no kernel spew on the TV.
CMDLINE=$BOOTDIR/cmdline.txt
if [ -f "$CMDLINE" ] && ! grep -q 'logo.nologo' "$CMDLINE"; then
    sed -i '1 s/$/ quiet loglevel=3 logo.nologo vt.global_cursor_default=0/' "$CMDLINE"
fi

# ------------------------------------------------------------- retroarch ----
log "seeding RetroArch config"
RA_DIR=$TARGET_HOME/.config/retroarch
install -d -o "$TARGET_USER" -g "$TARGET_USER" "$RA_DIR" "$RA_DIR/autoconfig" \
    "$TARGET_HOME/ROMs" "$TARGET_HOME/ES-DE"

# Merge, never clobber: keys the user already set survive an upgrade.
python3 - "$PREFIX/share/retroarch/retroarch.cfg" "$RA_DIR/retroarch.cfg" <<'PY'
import sys, re, pathlib
src, dst = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
kv = re.compile(r'^\s*([\w.]+)\s*=')
existing = {}
lines = dst.read_text().splitlines() if dst.exists() else []
for line in lines:
    m = kv.match(line)
    if m:
        existing[m.group(1)] = line
added = [l for l in src.read_text().splitlines()
         if not (m := kv.match(l)) or m.group(1) not in existing]
out = lines + ([""] + added if added else [])
dst.write_text("\n".join(out) + "\n")
print(f"  {len(added)} defaults applied, {len(existing)} existing keys kept")
PY
chown -R "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME/.config"

# ------------------------------------------------------------------ samba ----
# So dragging games across from a desktop needs no cables and no ssh.
install -d /etc/samba
if ! grep -q '^\[ROMs\]' /etc/samba/smb.conf 2>/dev/null; then
    log "sharing $TARGET_HOME/ROMs on the network"
    cat >> /etc/samba/smb.conf <<SMB

[ROMs]
   comment = RetroPi game library
   path = $TARGET_HOME/ROMs
   browseable = yes
   writeable = yes
   guest ok = yes
   create mask = 0664
   directory mask = 0775
   force user = $TARGET_USER
SMB
    [ "$NO_SERVICES" = 1 ] || systemctl enable --now smbd >/dev/null 2>&1 \
        || warn "smbd did not start"
fi

# --------------------------------------------------------------- services ----
if [ "$NO_SERVICES" = 1 ]; then
    warn "RETROPI_NO_SERVICES=1 - not enabling any services"
else
log "enabling services"
systemctl daemon-reload
systemctl enable bluetooth >/dev/null
systemctl enable retropi-btpair.service >/dev/null
systemctl enable retropi-library.service >/dev/null
systemctl enable "retropi-session@$TARGET_USER.service" >/dev/null
systemctl enable "retropi-portal@$TARGET_USER.service" >/dev/null
# The session owns tty1; a login prompt fighting it for the TTY is the classic
# "black screen with a blinking cursor" failure.
systemctl disable getty@tty1.service >/dev/null 2>&1 || true
systemctl set-default multi-user.target >/dev/null
fi

# Anyone can start X on the console (Debian defaults to console-users-only,
# which the systemd-started session does not satisfy).
if [ -f /etc/X11/Xwrapper.config ]; then
    sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config
else
    printf 'allowed_users=anybody\nneeds_root_rights=yes\n' > /etc/X11/Xwrapper.config
fi

# ------------------------------------------------------- network fetches ----
if [ "${RETROPI_OFFLINE:-0}" = "1" ]; then
    log "RETROPI_OFFLINE=1 - skipping downloads; run 'sudo retropi-update' later"
else
    "$PREFIX/bin/retropi-update" --cores --autoconfig --frontend --streaming || \
        warn "some downloads failed; re-run 'sudo retropi-update' once you have network"
fi

cat <<DONE

  RetroPi is installed.

  Reboot and it comes up straight in the game menu:   sudo reboot

  Library portal         http://$(hostname):$(  \
      sed -n 's/^[[:space:]]*portal_port[[:space:]]*=[[:space:]]*//p' \
      "$BOOTDIR/retropi/retropi.conf" 2>/dev/null | tail -n1 || echo 8080)
  Games go in            $TARGET_HOME/ROMs/<system>/
  or over the network at \\\\$(hostname)\\ROMs
  Controller pairing     automatic; hold the pad's pair button
  Settings               $BOOTDIR/retropi/retropi.conf
  Re-run the wizard      retropi-setup

DONE
