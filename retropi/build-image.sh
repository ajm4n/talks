#!/usr/bin/env bash
# Build a flashable RetroPi .img with pi-gen.
#
# Needs a Debian/Ubuntu machine (or container) with kvm-less binfmt support:
#   sudo apt install coreutils quilt parted qemu-user-static debootstrap \
#        zerofree zip dosfstools libarchive-tools libcap2-bin grep rsync \
#        xz-utils file git curl bc gpg pigz xxd arch-test
#
# Usage:  sudo ./build-image.sh [--hostname retropi] [--user pi] [--pass raspberry]
#
# Output: pi-gen/deploy/*-retropi.img.xz
set -euo pipefail

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PIGEN_DIR=${PIGEN_DIR:-$HERE/pi-gen/pi-gen}
PIGEN_BRANCH=${PIGEN_BRANCH:-arm64}

HOSTNAME_=retropi
USERNAME=pi
PASSWORD=raspberry
LOCALE=en_GB.UTF-8
TIMEZONE=Etc/UTC
KEYBOARD=gb

while [ $# -gt 0 ]; do
    case $1 in
        --hostname) HOSTNAME_=$2; shift 2 ;;
        --user)     USERNAME=$2;  shift 2 ;;
        --pass)     PASSWORD=$2;  shift 2 ;;
        --locale)   LOCALE=$2;    shift 2 ;;
        --timezone) TIMEZONE=$2;  shift 2 ;;
        --keyboard) KEYBOARD=$2;  shift 2 ;;
        -h|--help)  sed -n '2,14p' "$0"; exit 0 ;;
        *) echo "unknown option $1" >&2; exit 1 ;;
    esac
done

[ "$(id -u)" -eq 0 ] || { echo "pi-gen needs root; re-run with sudo" >&2; exit 1; }

# Building on Ubuntu is common and almost works: Ubuntu ships only its own
# keyrings, so debootstrap cannot verify Debian's archive and the chroot's apt
# fails with NO_PUBKEY several minutes in. Catch it here instead.
if [ ! -f /usr/share/keyrings/debian-archive-keyring.gpg ]; then
    echo "[retropi] installing debian-archive-keyring (required to bootstrap Debian)"
    apt-get update -qq && apt-get install -y debian-archive-keyring \
        || { echo "could not install debian-archive-keyring" >&2; exit 1; }
fi

# pi-gen expects a binary called "qemu-arm" for its ARM chroot. On most hosts
# this lives at "qemu-arm-static". Installing qemu-user-binfmt to get the
# "qemu-arm" name would remove qemu-user-static and kill the binfmt handler.
# A symlink avoids the conflict entirely.
if ! command -v qemu-arm >/dev/null 2>&1; then
    if command -v qemu-arm-static >/dev/null 2>&1; then
        echo "[retropi] symlinking qemu-arm -> qemu-arm-static"
        ln -sf "$(command -v qemu-arm-static)" /usr/local/bin/qemu-arm
    elif command -v qemu-aarch64-static >/dev/null 2>&1; then
        echo "[retropi] symlinking qemu-arm -> qemu-aarch64-static"
        ln -sf "$(command -v qemu-aarch64-static)" /usr/local/bin/qemu-arm
    else
        echo "qemu-user-static is required but not found" >&2; exit 1
    fi
fi

# Verify the binfmt handler is actually registered and working. Without this
# the chroot silently fails with "exec format error" deep inside apt.
if [ -d /proc/sys/fs/binfmt_misc ]; then
    if ! ls /proc/sys/fs/binfmt_misc/qemu-* >/dev/null 2>&1; then
        echo "[retropi] binfmt handler not registered; attempting manual registration"
        if [ -f /proc/sys/fs/binfmt_misc/register ]; then
            echo ':qemu-aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-aarch64-static:OCF' \
                > /proc/sys/fs/binfmt_misc/register 2>/dev/null || true
        fi
    fi
    if ! ls /proc/sys/fs/binfmt_misc/qemu-* >/dev/null 2>&1; then
        echo "binfmt_misc handler is not registered - the chroot will fail" >&2
        echo "on a normal host: sudo systemctl restart systemd-binfmt" >&2
        exit 1
    fi
    echo "[retropi] binfmt handler is active"
fi

if [ ! -d "$PIGEN_DIR" ]; then
    echo "[retropi] fetching pi-gen ($PIGEN_BRANCH)"
    git clone --depth 1 -b "$PIGEN_BRANCH" https://github.com/RPi-Distro/pi-gen "$PIGEN_DIR"
fi

# pi-gen only runs stages it finds in its own tree, so link ours in. The stage
# resolves our source tree from its own real path, so no other links are needed.
ln -sfn "$HERE/pi-gen/stage-retropi" "$PIGEN_DIR/stage-retropi"

# Stop after stage2 (Lite) plus ours - no desktop, nothing we do not use.
touch "$PIGEN_DIR/stage3/SKIP" "$PIGEN_DIR/stage4/SKIP" "$PIGEN_DIR/stage5/SKIP" 2>/dev/null || true
rm -f "$PIGEN_DIR"/stage{3,4,5}/EXPORT_* 2>/dev/null || true

cat > "$PIGEN_DIR/config" <<CFG
IMG_NAME='RetroPi'
RELEASE=bookworm
DEPLOY_COMPRESSION=xz
COMPRESSION_LEVEL=6
LOCALE_DEFAULT='$LOCALE'
TARGET_HOSTNAME='$HOSTNAME_'
KEYBOARD_KEYMAP='$KEYBOARD'
KEYBOARD_LAYOUT='English (UK)'
TIMEZONE_DEFAULT='$TIMEZONE'
FIRST_USER_NAME='$USERNAME'
FIRST_USER_PASS='$PASSWORD'
DISABLE_FIRST_BOOT_USER_RENAME=1
ENABLE_SSH=1
STAGE_LIST="stage0 stage1 stage2 stage-retropi"
CFG

echo "[retropi] building - expect 30-60 minutes and ~10GB of scratch space"
cd "$PIGEN_DIR"
./build.sh

echo
echo "[retropi] done. Images are in $PIGEN_DIR/deploy/"
ls -lh "$PIGEN_DIR/deploy/" 2>/dev/null || true
echo "Flash with Raspberry Pi Imager (choose 'Use custom' and pick the .img.xz)."
