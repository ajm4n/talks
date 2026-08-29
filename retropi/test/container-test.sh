#!/usr/bin/env bash
# Runs install.sh in a throwaway Debian container with the package and service
# stages skipped, then checks everything install.sh is actually responsible for
# putting on disk - including that a second run changes nothing.
#
# It does NOT test: package availability, systemd, udev, X, Bluetooth, the
# frontend. Those need the VM (test/run-qemu.sh) or real hardware.
#
#   CONTAINER_RUNTIME=podman ./test/container-test.sh
#   CONTAINER_NET=host       ./test/container-test.sh   # daemon without NAT
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
RUNTIME=${CONTAINER_RUNTIME:-docker}
IMAGE=${CONTAINER_IMAGE:-debian:bookworm}

command -v "$RUNTIME" >/dev/null || { echo "need $RUNTIME" >&2; exit 1; }

# Pass a proxy through if the host uses one, and allow host networking for
# daemons started without NAT (--iptables=false), where bridged DNS is dead.
NET_ARGS=(--network "${CONTAINER_NET:-bridge}")
PROXY_ARGS=()
for v in http_proxy https_proxy no_proxy HTTP_PROXY HTTPS_PROXY NO_PROXY; do
    [ -n "${!v:-}" ] && PROXY_ARGS+=(-e "$v=${!v}")
done

# The guest script arrives on stdin, so it can use any quoting it likes.
exec "$RUNTIME" run --rm -i "${NET_ARGS[@]}" ${PROXY_ARGS[@]+"${PROXY_ARGS[@]}"} \
    -v "$ROOT:/src:ro" -w /tmp "$IMAGE" bash -euo pipefail -s <<'GUEST'
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq >/dev/null
apt-get install -y -qq --no-install-recommends sudo python3 >/dev/null

# install.sh sets up whichever account owns uid 1000, as on a real Pi.
useradd -u 1000 -m -s /bin/bash pi

cp -r /src /work && cd /work
mkdir -p /boot/firmware
printf 'console=serial0,115200 root=/dev/mmcblk0p2 rootwait\n' > /boot/firmware/cmdline.txt
printf '[all]\n' > /boot/firmware/config.txt

run_install() {
    RETROPI_SKIP_PACKAGES=1 RETROPI_NO_SERVICES=1 RETROPI_OFFLINE=1 SUDO_USER=pi ./install.sh
}

echo "=== first install ==="
run_install

PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); printf '  ok   %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL %s\n' "$1"; }

# Each helper takes the real arguments - no eval, no nested quoting.
ck()       { if "${@:2}" >/dev/null 2>&1; then ok "$1"; else bad "$1"; fi; }
ck_owner() { local w; w=$(stat -c %U "$2" 2>/dev/null); [ "$w" = "$3" ] && ok "$1" || bad "$1 (owner=$w)"; }
ck_mode()  { local w; w=$(stat -c %a "$2" 2>/dev/null); [ "$w" = "$3" ] && ok "$1" || bad "$1 (mode=$w)"; }
ck_count() { # name expected pattern file
    local n; n=$(grep -c -e "$3" "$4" 2>/dev/null || true)
    [ "$n" = "$2" ] && ok "$1" || bad "$1 (found $n, wanted $2)"
}

echo
echo "=== placement ==="
ck  "library installed"             test -r /opt/retropi/lib/common.sh
ck  "binaries installed executable" test -x /opt/retropi/bin/retropi-bt-pair
ck  "retropi-setup symlink kept"    test -x /opt/retropi/bin/retropi-setup
ck  "commands linked onto PATH"     test -L /usr/local/bin/retropi-library
ck  "systemd units placed"          test -f /etc/systemd/system/retropi-session@.service
ck  "udev rules placed"             test -f /etc/udev/rules.d/99-retropi.rules
ck  "sudoers validates"             visudo -cf /etc/sudoers.d/retropi
ck_mode  "sudoers is mode 0440"     /etc/sudoers.d/retropi 440
ck  "retropi group created"         getent group retropi
ck  "pi is in the retropi group"    grep -qw pi <<<"$(id -nG pi)"
ck  "boot config written"           test -f /boot/firmware/retropi/retropi.conf
ck  "config.txt got the KMS overlay" grep -q vc4-kms-v3d /boot/firmware/config.txt
ck  "cmdline.txt quieted"           grep -q logo.nologo /boot/firmware/cmdline.txt
ck_owner "ROMs dir belongs to pi"   /home/pi/ROMs pi
ck  "retroarch.cfg seeded"          grep -q input_exit_emulator_btn /home/pi/.config/retroarch/retroarch.cfg
ck_owner "retroarch.cfg owned by pi" /home/pi/.config/retroarch/retroarch.cfg pi
ck  "samba share appended"          grep -q '^\[ROMs\]' /etc/samba/smb.conf
ck  "Xwrapper allows anybody"       grep -q allowed_users=anybody /etc/X11/Xwrapper.config
ck  "config parses after install"   /opt/retropi/bin/retropi-library status

# A user-edited key must survive an upgrade; a default must not be duplicated.
sed -i 's/^video_smooth.*/video_smooth = "true"/' /home/pi/.config/retroarch/retroarch.cfg

echo
echo "=== second install (idempotency) ==="
run_install >/dev/null 2>&1
ck_count "one KMS block in config.txt"      1 '^# --- retropi ---' /boot/firmware/config.txt
ck_count "one ROMs stanza in smb.conf"      1 '^\[ROMs\]'          /etc/samba/smb.conf
ck_count "one logo.nologo in cmdline.txt"   1 'logo.nologo'        /boot/firmware/cmdline.txt
ck_count "no duplicated retroarch key"      1 '^input_exit_emulator_btn' /home/pi/.config/retroarch/retroarch.cfg
ck_count "user's edited value was kept"     1 '^video_smooth = "true"'   /home/pi/.config/retroarch/retroarch.cfg

echo
echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
GUEST
