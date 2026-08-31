#!/usr/bin/env bash
# Build a flashable RetroPi .img.xz from an official Raspberry Pi OS Lite image.
#
# Downloads the latest arm64 Lite image, expands the rootfs, injects the RetroPi
# overlay and a first-boot service that finishes installation (package install,
# core download, frontend fetch) on the Pi itself. No cross-compilation or qemu
# chroot needed — the heavy lifting happens on real hardware at first boot.
#
# Needs: curl, xz, parted, losetup, e2fsprogs, rsync, mtools
#   sudo apt install curl xz-utils parted e2fsprogs rsync mtools
#
# Usage:  sudo ./build-image.sh [--hostname retropi] [--user pi] [--pass raspberry]
#
# Output: deploy/retropi-<date>.img.xz
set -euo pipefail

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

HOSTNAME_=retropi
USERNAME=pi
PASSWORD=raspberry

while [ $# -gt 0 ]; do
    case $1 in
        --hostname) HOSTNAME_=$2; shift 2 ;;
        --user)     USERNAME=$2;  shift 2 ;;
        --pass)     PASSWORD=$2;  shift 2 ;;
        -h|--help)  sed -n '2,16p' "$0"; exit 0 ;;
        *) echo "unknown option $1" >&2; exit 1 ;;
    esac
done

[ "$(id -u)" -eq 0 ] || { echo "needs root; re-run with sudo" >&2; exit 1; }

log()  { printf '\033[1;36m[retropi]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[retropi]\033[0m %s\n' "$*" >&2; exit 1; }

WORK="$HERE/.build"
DEPLOY="$HERE/deploy"
mkdir -p "$WORK" "$DEPLOY"

for cmd in curl xz parted losetup resize2fs rsync mcopy; do
    command -v "$cmd" >/dev/null || die "missing: $cmd"
done

# Ensure /dev basics exist (containers sometimes lose these).
for d in urandom:1:9 random:1:8 null:1:3 zero:1:5; do
    IFS=: read -r name maj min <<<"$d"
    [ -e "/dev/$name" ] || mknod "/dev/$name" c "$maj" "$min"
    chmod 666 "/dev/$name"
done

# Ensure loop devices exist.
[ -e /dev/loop-control ] || mknod /dev/loop-control c 10 237
for i in $(seq 0 7); do
    [ -e "/dev/loop$i" ] || mknod "/dev/loop$i" b 7 "$i"
done

# ----------------------------------------------------------- download image ---
IMG_URL_BASE="https://downloads.raspberrypi.com/raspios_lite_arm64/images/"
if [ ! -f "$WORK/base.img" ]; then
    log "finding latest Raspberry Pi OS Lite arm64 image"
    LATEST_DIR=$(curl -fsSL "$IMG_URL_BASE" | grep -oP 'raspios_lite_arm64-\d{4}-\d{2}-\d{2}/' | sort | tail -n1)
    [ -n "$LATEST_DIR" ] || die "could not find image directory"
    IMG_FILE=$(curl -fsSL "${IMG_URL_BASE}${LATEST_DIR}" | grep -oP '\d{4}-\d{2}-\d{2}-raspios-[a-z]+-arm64-lite\.img\.xz' | head -n1)
    [ -n "$IMG_FILE" ] || die "could not find .img.xz in $LATEST_DIR"
    IMG_URL="${IMG_URL_BASE}${LATEST_DIR}${IMG_FILE}"

    log "downloading $IMG_FILE"
    curl -fL -o "$WORK/base.img.xz" "$IMG_URL" \
        || die "download failed"

    log "decompressing"
    xz -d "$WORK/base.img.xz"
fi

IMG="$WORK/retropi.img"
cp "$WORK/base.img" "$IMG"

# -------------------------------------------------------------- expand rootfs ---
log "expanding rootfs (+2 GiB for packages)"
truncate -s +2G "$IMG"
LOOP=$(losetup --find --show --partscan "$IMG")
cleanup() { umount -R "$WORK/rootfs" 2>/dev/null || true; losetup -d "$LOOP" 2>/dev/null || true; }
trap cleanup EXIT

partprobe "$LOOP" 2>/dev/null || true
for _ in $(seq 1 10); do [ -e "${LOOP}p2" ] && break; sleep 0.5; done
[ -e "${LOOP}p2" ] || die "partition devices did not appear (${LOOP}p2)"

PART_START=$(parted -ms "$LOOP" unit s print | awk -F: '/^2:/{gsub(/s/,"",$2); print $2}')
parted -s "$LOOP" rm 2
parted -s "$LOOP" mkpart primary ext4 "${PART_START}s" 100%
partprobe "$LOOP" 2>/dev/null || true
e2fsck -fy "${LOOP}p2" >/dev/null 2>&1 || true
resize2fs "${LOOP}p2"

# --------------------------------------------------------- mount rootfs only ---
log "mounting rootfs"
mkdir -p "$WORK/rootfs"
mount "${LOOP}p2" "$WORK/rootfs"
ROOTFS="$WORK/rootfs"

# ----------------------------------------------------------- inject overlay ---
log "injecting RetroPi overlay"
install -d "$ROOTFS/usr/local/src/retropi"
rsync -a --exclude='pi-gen' --exclude='.build' --exclude='deploy' \
    --exclude='.vm' --exclude='.git' \
    "$HERE/" "$ROOTFS/usr/local/src/retropi/"

cp -r "$HERE/overlay/opt/retropi/." "$ROOTFS/opt/retropi/" 2>/dev/null || {
    install -d "$ROOTFS/opt/retropi"
    cp -r "$HERE/overlay/opt/retropi/." "$ROOTFS/opt/retropi/"
}
cp -r "$HERE/overlay/etc/." "$ROOTFS/etc/"
chmod +x "$ROOTFS/opt/retropi/bin/"*
chmod 0440 "$ROOTFS/etc/sudoers.d/retropi"
install -d "$ROOTFS/var/lib/retropi"

install -d "$ROOTFS/usr/local/bin"
for f in "$ROOTFS/opt/retropi/bin/"*; do
    ln -sf "/opt/retropi/bin/$(basename "$f")" "$ROOTFS/usr/local/bin/$(basename "$f")"
done

# ---------------------------------------- first-boot service (finishes setup) ---
log "installing first-boot service"
cat > "$ROOTFS/usr/local/src/retropi/firstrun.sh" <<'FIRSTRUN'
#!/usr/bin/env bash
set -euo pipefail
exec > /var/log/retropi-firstrun.log 2>&1
echo "[retropi] first-run: $(date)"
cd /usr/local/src/retropi
./install.sh
systemctl disable retropi-firstrun.service
rm -f /etc/systemd/system/retropi-firstrun.service
echo "[retropi] first-run complete: $(date)"
FIRSTRUN
chmod +x "$ROOTFS/usr/local/src/retropi/firstrun.sh"

cat > "$ROOTFS/etc/systemd/system/retropi-firstrun.service" <<'UNIT'
[Unit]
Description=RetroPi first-run setup
After=network-online.target
Wants=network-online.target
ConditionPathExists=/usr/local/src/retropi/firstrun.sh

[Service]
Type=oneshot
ExecStart=/usr/local/src/retropi/firstrun.sh
RemainAfterExit=yes
StandardOutput=journal+console
StandardError=journal+console

[Install]
WantedBy=multi-user.target
UNIT

ln -sf /etc/systemd/system/retropi-firstrun.service \
    "$ROOTFS/etc/systemd/system/multi-user.target.wants/retropi-firstrun.service"

# ------------------------------------------------------ hostname ---
echo "$HOSTNAME_" > "$ROOTFS/etc/hostname"
sed -i "s/127\.0\.1\.1.*/127.0.1.1\t$HOSTNAME_/" "$ROOTFS/etc/hosts" 2>/dev/null || true

# ------------------------------------------------ unmount rootfs ---
log "unmounting rootfs"
sync
umount "$WORK/rootfs"

# ------------------------------------------ boot partition (mtools) ---
# The boot partition is FAT32; many container kernels lack vfat, so we use
# mtools instead of mounting. mtools addresses the partition through an
# offset into the image on the loop device.
log "configuring boot partition"
BOOT_OFFSET=$(parted -ms "$LOOP" unit B print | awk -F: '/^1:/{gsub(/B/,"",$2); print $2}')
BOOT_SIZE=$(parted -ms "$LOOP" unit B print | awk -F: '/^1:/{gsub(/B/,"",$4); print $4}')

export MTOOLS_SKIP_CHECK=1
MTOOLSRC="$WORK/mtoolsrc"
cat > "$MTOOLSRC" <<MTCFG
drive b:
    file="${LOOP}"
    offset=${BOOT_OFFSET}
MTCFG
export MTOOLSRC

# Read existing config.txt, append our block if not present, write it back.
TMPBOOT="$WORK/boot-tmp"
mkdir -p "$TMPBOOT"

mcopy b:/config.txt "$TMPBOOT/config.txt" 2>/dev/null || true
if [ -f "$TMPBOOT/config.txt" ] && ! grep -q '^# --- retropi ---' "$TMPBOOT/config.txt"; then
    cat >> "$TMPBOOT/config.txt" <<'TXT'

# --- retropi ---
dtoverlay=vc4-kms-v3d
max_framebuffers=2
hdmi_force_hotplug=1
disable_overscan=1
dtparam=audio=on
TXT
    mcopy -o "$TMPBOOT/config.txt" b:/config.txt
fi

mcopy b:/cmdline.txt "$TMPBOOT/cmdline.txt" 2>/dev/null || true
if [ -f "$TMPBOOT/cmdline.txt" ] && ! grep -q 'logo.nologo' "$TMPBOOT/cmdline.txt"; then
    sed -i '1 s/$/ quiet loglevel=3 logo.nologo vt.global_cursor_default=0/' "$TMPBOOT/cmdline.txt"
    mcopy -o "$TMPBOOT/cmdline.txt" b:/cmdline.txt
fi

# Seed boot config.
mmd b:/retropi 2>/dev/null || true
mcopy -o "$HERE/config/retropi.conf.example" b:/retropi/retropi.conf

# Enable SSH.
touch "$TMPBOOT/ssh"
mcopy -o "$TMPBOOT/ssh" b:/ssh

# Set user credentials.
if command -v openssl >/dev/null 2>&1; then
    HASH=$(echo "$PASSWORD" | openssl passwd -6 -stdin)
    echo "${USERNAME}:${HASH}" > "$TMPBOOT/userconf.txt"
    mcopy -o "$TMPBOOT/userconf.txt" b:/userconf.txt
fi

rm -rf "$TMPBOOT" "$MTOOLSRC"

# ------------------------------------------------------------ detach loop ---
losetup -d "$LOOP"
trap - EXIT

# ---------------------------------------------------------------- compress ---
log "compressing (this takes a while)"
xz -T0 -6 "$IMG"

OUTNAME="retropi-$(date +%Y-%m-%d).img.xz"
mv "$IMG.xz" "$DEPLOY/$OUTNAME"

echo
log "done: $DEPLOY/$OUTNAME"
ls -lh "$DEPLOY/$OUTNAME"
echo
echo "Flash with Raspberry Pi Imager (choose 'Use custom' and pick the .img.xz)."
echo "First boot takes 5-10 minutes while it installs packages over the network."
echo "After that, it reboots straight into the game menu."
