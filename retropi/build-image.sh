#!/usr/bin/env bash
# Build a fully-offline flashable RetroPi .img.xz from an official Raspberry
# Pi OS Lite image.
#
# Downloads the latest arm64 Lite image, expands the rootfs, chroots via
# qemu-user to install all packages and emulator cores, pre-stages the ES-DE
# frontend and controller profiles, then compresses to .img.xz.  The resulting
# image boots straight into the game menu with NO internet required.
#
# Needs: curl, xz, parted, losetup, e2fsprogs, rsync, mtools,
#        qemu-user-static (binfmt registered)
#   sudo apt install curl xz-utils parted e2fsprogs rsync mtools qemu-user-static
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
        -h|--help)  sed -n '2,18p' "$0"; exit 0 ;;
        *) echo "unknown option $1" >&2; exit 1 ;;
    esac
done

[ "$(id -u)" -eq 0 ] || { echo "needs root; re-run with sudo" >&2; exit 1; }

log()  { printf '\033[1;36m[retropi]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[retropi]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[retropi]\033[0m %s\n' "$*" >&2; exit 1; }

WORK="$HERE/.build"
DEPLOY="$HERE/deploy"
mkdir -p "$WORK" "$DEPLOY"

for cmd in curl xz parted losetup resize2fs rsync mcopy; do
    command -v "$cmd" >/dev/null || die "missing: $cmd"
done

QEMU_BIN=$(command -v qemu-aarch64-static 2>/dev/null || command -v qemu-aarch64 2>/dev/null || true)
[ -n "$QEMU_BIN" ] || die "missing: qemu-aarch64-static (install qemu-user-static)"

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
log "expanding rootfs (+4 GiB for packages)"
truncate -s +4G "$IMG"
LOOP=$(losetup --find --show --partscan "$IMG")
cleanup() {
    umount "$WORK/rootfs/dev/pts" 2>/dev/null || true
    umount "$WORK/rootfs/dev" 2>/dev/null || true
    umount "$WORK/rootfs/proc" 2>/dev/null || true
    umount "$WORK/rootfs/sys" 2>/dev/null || true
    umount -R "$WORK/rootfs" 2>/dev/null || true
    losetup -d "$LOOP" 2>/dev/null || true
}
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

install -d "$ROOTFS/opt/retropi"
cp -r "$HERE/overlay/opt/retropi/." "$ROOTFS/opt/retropi/"
cp -r "$HERE/overlay/etc/." "$ROOTFS/etc/"
chmod +x "$ROOTFS/opt/retropi/bin/"*
chmod 0440 "$ROOTFS/etc/sudoers.d/retropi"
install -d "$ROOTFS/var/lib/retropi"

install -d "$ROOTFS/usr/local/bin"
for f in "$ROOTFS/opt/retropi/bin/"*; do
    ln -sf "/opt/retropi/bin/$(basename "$f")" "$ROOTFS/usr/local/bin/$(basename "$f")"
done

# -------------------------------------------------- chroot: install packages ---
log "setting up chroot for package installation"
cp "$QEMU_BIN" "$ROOTFS/usr/bin/qemu-aarch64-static"
cp /etc/resolv.conf "$ROOTFS/etc/resolv.conf"
mount -t proc proc "$ROOTFS/proc"
mount -t sysfs sys "$ROOTFS/sys"
mount --bind /dev "$ROOTFS/dev"
mount --bind /dev/pts "$ROOTFS/dev/pts"

log "installing required packages (this is the slow bit)"
chroot "$ROOTFS" /bin/bash -c '
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y --no-install-recommends \
    retroarch \
    xserver-xorg xinit x11-xserver-utils unclutter \
    libgl1-mesa-dri \
    bluez bluez-tools \
    alsa-utils \
    cifs-utils nfs-common rsync samba samba-common-bin \
    curl ca-certificates git jq whiptail unzip p7zip-full \
    joystick evtest \
    python3 sudo
'

log "installing optional packages"
chroot "$ROOTFS" /bin/bash -c '
export DEBIAN_FRONTEND=noninteractive
for p in pi-bluetooth bluetooth mesa-vulkan-drivers \
         pulseaudio pulseaudio-module-bluetooth \
         network-manager fuse libfuse2 libfuse2t64; do
    apt-get install -y --no-install-recommends "$p" >/dev/null 2>&1 || true
done
'

log "installing libretro emulator cores"
chroot "$ROOTFS" /bin/bash -c '
export DEBIAN_FRONTEND=noninteractive
for c in libretro-beetle-pce-fast libretro-beetle-psx libretro-beetle-vb \
    libretro-beetle-wswan libretro-bsnes-mercury-accuracy libretro-desmume \
    libretro-fceumm libretro-gambatte libretro-genesisplusgx \
    libretro-mgba libretro-mupen64plus-next libretro-nestopia \
    libretro-pcsx-rearmed libretro-snes9x libretro-stella \
    libretro-vecx libretro-virtualjaguar libretro-yabause; do
    apt-get install -y --no-install-recommends "$c" >/dev/null 2>&1 || true
done
'

# --------------------------------------------------- pre-stage ES-DE ---
log "downloading ES-DE frontend"
ESDE_API="https://gitlab.com/api/v4/projects/es-de%2Femulationstation-de/releases?per_page=5"
ESDE_FALLBACK="https://gitlab.com/es-de/emulationstation-de/-/package_files/326321114/download"
ESDE_URL=""
if command -v jq >/dev/null 2>&1; then
    ESDE_URL=$(curl -fsSL --max-time 30 "$ESDE_API" 2>/dev/null \
        | jq -r '.[].assets.links[]? | select(.name | test("aarch64.*AppImage")) | .url' 2>/dev/null \
        | head -n1)
fi
: "${ESDE_URL:=$ESDE_FALLBACK}"

install -d "$ROOTFS/opt/retropi/share"
if curl -fL --retry 3 --connect-timeout 20 -o "$ROOTFS/opt/retropi/share/ES-DE.AppImage" "$ESDE_URL"; then
    chmod 755 "$ROOTFS/opt/retropi/share/ES-DE.AppImage"
    log "ES-DE installed ($(du -h "$ROOTFS/opt/retropi/share/ES-DE.AppImage" | cut -f1))"
else
    warn "could not download ES-DE; the Pi will use RetroArch as fallback frontend"
fi

# ---------------------------------------------- pre-stage autoconfig ---
log "downloading controller autoconfig profiles"
AUTOCONFIG="$ROOTFS/home/$USERNAME/.config/retroarch/autoconfig"
install -d "$AUTOCONFIG"
TMP_AC=$(mktemp -d)
if git clone --depth 1 -q https://github.com/libretro/retroarch-joypad-autoconfig "$TMP_AC/ac" 2>/dev/null; then
    cp -r "$TMP_AC/ac"/* "$AUTOCONFIG"/ 2>/dev/null || true
    rm -rf "$AUTOCONFIG/.git"
    log "installed $(find "$AUTOCONFIG" -name '*.cfg' | wc -l) controller profiles"
fi
rm -rf "$TMP_AC"

# ------------------------------------------ run install.sh (offline) ---
log "running install.sh inside chroot (offline, no services)"
chroot "$ROOTFS" /bin/bash -c '
export RETROPI_SKIP_PACKAGES=1
export RETROPI_NO_SERVICES=1
export RETROPI_OFFLINE=1
export DEBIAN_FRONTEND=noninteractive
cd /usr/local/src/retropi
./install.sh
'

# --------------------------------------------- enable systemd services ---
log "enabling systemd services"
MUW="$ROOTFS/etc/systemd/system/multi-user.target.wants"
mkdir -p "$MUW"
ln -sf /usr/lib/systemd/system/bluetooth.service "$MUW/bluetooth.service" 2>/dev/null || true
for svc in retropi-btpair.service retropi-library.service; do
    [ -f "$ROOTFS/etc/systemd/system/$svc" ] && \
        ln -sf "/etc/systemd/system/$svc" "$MUW/$svc"
done
for svc in "retropi-session@${USERNAME}.service" "retropi-portal@${USERNAME}.service"; do
    unit=$(echo "$svc" | sed 's/@.*/@.service/')
    [ -f "$ROOTFS/etc/systemd/system/$unit" ] && \
        ln -sf "/etc/systemd/system/$unit" "$MUW/$svc"
done
rm -f "$ROOTFS/etc/systemd/system/getty.target.wants/getty@tty1.service" 2>/dev/null
ln -sf /usr/lib/systemd/system/multi-user.target "$ROOTFS/etc/systemd/system/default.target"
mkdir -p "$ROOTFS/etc/X11"
printf 'allowed_users=anybody\nneeds_root_rights=yes\n' > "$ROOTFS/etc/X11/Xwrapper.config"

# ---------------------------------------- lightweight first-boot service ---
log "installing first-boot service"
cat > "$ROOTFS/usr/local/src/retropi/firstrun.sh" <<'FIRSTRUN'
#!/usr/bin/env bash
set -euo pipefail
exec > /var/log/retropi-firstrun.log 2>&1
echo "[retropi] first-run: $(date)"
TARGET_USER=$(getent passwd 1000 | cut -d: -f1)
[ -n "$TARGET_USER" ] || { echo "no UID-1000 user yet"; exit 0; }
TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
getent group retropi >/dev/null || groupadd retropi
for g in retropi input video audio render bluetooth plugdev tty; do
    getent group "$g" >/dev/null && usermod -aG "$g" "$TARGET_USER" 2>/dev/null || true
done
for d in "$TARGET_HOME/.config" "$TARGET_HOME/ROMs" "$TARGET_HOME/ES-DE"; do
    [ -d "$d" ] && chown -R "$TARGET_USER":"$TARGET_USER" "$d"
done
cd /usr/local/src/retropi
RETROPI_SKIP_PACKAGES=1 RETROPI_OFFLINE=1 ./install.sh 2>&1 || true
systemctl disable retropi-firstrun.service
rm -f /etc/systemd/system/retropi-firstrun.service
echo "[retropi] first-run complete: $(date)"
FIRSTRUN
chmod +x "$ROOTFS/usr/local/src/retropi/firstrun.sh"

cat > "$ROOTFS/etc/systemd/system/retropi-firstrun.service" <<'UNIT'
[Unit]
Description=RetroPi first-run setup
After=local-fs.target
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
ln -sf /etc/systemd/system/retropi-firstrun.service "$MUW/retropi-firstrun.service"

# ------------------------------------------------------ hostname ---
echo "$HOSTNAME_" > "$ROOTFS/etc/hostname"
sed -i "s/127\.0\.1\.1.*/127.0.1.1\t$HOSTNAME_/" "$ROOTFS/etc/hosts" 2>/dev/null || true

# ------------------------------------------------ clean up chroot ---
log "cleaning up chroot"
chroot "$ROOTFS" /bin/bash -c 'apt-get clean; rm -rf /var/lib/apt/lists/*'
rm -f "$ROOTFS/usr/bin/qemu-aarch64-static"

umount "$ROOTFS/dev/pts" 2>/dev/null || true
umount "$ROOTFS/dev" 2>/dev/null || true
umount "$ROOTFS/proc" 2>/dev/null || true
umount "$ROOTFS/sys" 2>/dev/null || true

# ------------------------------------------------ unmount rootfs ---
log "unmounting rootfs"
sync
umount "$WORK/rootfs"

# ------------------------------------------ boot partition (mtools) ---
log "configuring boot partition"
BOOT_OFFSET=$(parted -ms "$LOOP" unit B print | awk -F: '/^1:/{gsub(/B/,"",$2); print $2}')

export MTOOLS_SKIP_CHECK=1
MTOOLSRC="$WORK/mtoolsrc"
cat > "$MTOOLSRC" <<MTCFG
drive b:
    file="${LOOP}"
    offset=${BOOT_OFFSET}
MTCFG
export MTOOLSRC

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

mmd b:/retropi 2>/dev/null || true
mcopy -o "$HERE/config/retropi.conf.example" b:/retropi/retropi.conf

touch "$TMPBOOT/ssh"
mcopy -o "$TMPBOOT/ssh" b:/ssh

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
echo "No internet needed — the Pi boots straight into the game menu."
