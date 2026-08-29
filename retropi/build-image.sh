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
