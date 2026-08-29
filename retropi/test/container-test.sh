#!/usr/bin/env bash
# Runs install.sh in a throwaway Debian container with the package and service
# stages skipped, then checks everything install.sh is actually responsible for
# putting on disk. Seconds, not minutes - this is the fast feedback loop.
#
# It does NOT test: package availability, systemd, udev, X, Bluetooth, the
# frontend. Those need the VM (test/run-qemu.sh) or real hardware.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
RUNTIME=${CONTAINER_RUNTIME:-docker}
IMAGE=${CONTAINER_IMAGE:-debian:bookworm}

command -v "$RUNTIME" >/dev/null || { echo "need $RUNTIME" >&2; exit 1; }

exec "$RUNTIME" run --rm -v "$ROOT:/src:ro" -w /tmp "$IMAGE" bash -euo pipefail -c '
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq >/dev/null
apt-get install -y -qq --no-install-recommends sudo python3 rsync >/dev/null

# install.sh sets up whichever account owns uid 1000, as on a real Pi.
useradd -u 1000 -m -s /bin/bash pi

cp -r /src /work && cd /work
mkdir -p /boot/firmware && printf "console=serial0,115200 root=/dev/mmcblk0p2 rootwait\n" > /boot/firmware/cmdline.txt
printf "[all]\n" > /boot/firmware/config.txt

RETROPI_SKIP_PACKAGES=1 RETROPI_NO_SERVICES=1 RETROPI_OFFLINE=1 SUDO_USER=pi ./install.sh

echo
echo "=== checks ==="
PASS=0; FAIL=0
ck() { if eval "$2" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "  ok   $1"; \
       else FAIL=$((FAIL+1)); echo "  FAIL $1"; fi; }

ck "library installed"            "[ -r /opt/retropi/lib/common.sh ]"
ck "binaries installed executable" "[ -x /opt/retropi/bin/retropi-bt-pair ]"
ck "retropi-setup symlink kept"    "[ -x /opt/retropi/bin/retropi-setup ]"
ck "commands linked onto PATH"     "[ -L /usr/local/bin/retropi-library ]"
ck "systemd units placed"          "[ -f /etc/systemd/system/retropi-session@.service ]"
ck "udev rules placed"             "[ -f /etc/udev/rules.d/99-retropi.rules ]"
ck "sudoers placed at 0440"        "[ \"$(stat -c %a /etc/sudoers.d/retropi)\" = 440 ]"
ck "sudoers validates"             "visudo -cf /etc/sudoers.d/retropi"
ck "retropi group created"         "getent group retropi"
ck "pi added to retropi group"     "id -nG pi | grep -qw retropi"
ck "boot config written"           "[ -f /boot/firmware/retropi/retropi.conf ]"
ck "config.txt got the KMS overlay" "grep -q vc4-kms-v3d /boot/firmware/config.txt"
ck "cmdline.txt quieted"           "grep -q logo.nologo /boot/firmware/cmdline.txt"
ck "ROMs dir created for pi"       "[ \"$(stat -c %U /home/pi/ROMs)\" = pi ]"
ck "retroarch.cfg seeded"          "grep -q input_exit_emulator_btn /home/pi/.config/retroarch/retroarch.cfg"
ck "retroarch.cfg owned by pi"     "[ \"$(stat -c %U /home/pi/.config/retroarch/retroarch.cfg)\" = pi ]"
ck "samba share appended"          "grep -q \"^\\[ROMs\\]\" /etc/samba/smb.conf"
ck "Xwrapper allows anybody"       "grep -q allowed_users=anybody /etc/X11/Xwrapper.config"
ck "config parses after install"   "/opt/retropi/bin/retropi-library status"

# Re-running must not duplicate anything - people will run this twice.
RETROPI_SKIP_PACKAGES=1 RETROPI_NO_SERVICES=1 RETROPI_OFFLINE=1 SUDO_USER=pi ./install.sh >/dev/null 2>&1
ck "second run: one KMS block"     "[ \"$(grep -c \"^# --- retropi ---\" /boot/firmware/config.txt)\" = 1 ]"
ck "second run: one samba stanza"  "[ \"$(grep -c \"^\\[ROMs\\]\" /etc/samba/smb.conf)\" = 1 ]"
ck "second run: no duplicate keys" "[ \"$(grep -c ^input_exit_emulator_btn /home/pi/.config/retroarch/retroarch.cfg)\" = 1 ]"
ck "second run: cmdline unchanged" "[ \"$(grep -c logo.nologo /boot/firmware/cmdline.txt)\" = 1 ]"

echo
echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
'
