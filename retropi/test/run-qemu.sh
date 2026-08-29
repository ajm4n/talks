#!/usr/bin/env bash
# Boot a VM to test RetroPi. Two modes, testing different things:
#
#   ./test/run-qemu.sh                 Debian VM, repo shared in, you run
#                                      install.sh + smoke-test.sh inside.
#                                      Tests the whole software stack.
#
#   ./test/run-qemu.sh --image X.img   boot a built RetroPi image on QEMU's
#                                      emulated Pi. Tests that the image boots
#                                      and its services come up. No GPU, so the
#                                      frontend will not render.
#
# Options: --arch amd64|arm64  (default amd64: KVM-fast, and everything except
#                               the Pi-specific packages behaves identically)
#          --mem 2048  --cpus 2  --ssh-port 2222  --fresh
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
WORK=${RETROPI_VM_DIR:-$ROOT/.vm}
ARCH=amd64 MEM=2048 CPUS=2 SSH_PORT=2222 IMAGE="" FRESH=0

while [ $# -gt 0 ]; do
    case $1 in
        --arch) ARCH=$2; shift 2 ;;
        --mem) MEM=$2; shift 2 ;;
        --cpus) CPUS=$2; shift 2 ;;
        --ssh-port) SSH_PORT=$2; shift 2 ;;
        --image) IMAGE=$2; shift 2 ;;
        --fresh) FRESH=1; shift ;;
        -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
        *) echo "unknown option $1" >&2; exit 1 ;;
    esac
done

need() { command -v "$1" >/dev/null || { echo "missing: $1  ($2)" >&2; exit 1; }; }
mkdir -p "$WORK"

# ------------------------------------------------------- Pi image mode ------
if [ -n "$IMAGE" ]; then
    need qemu-system-aarch64 "apt install qemu-system-arm"
    [ -f "$IMAGE" ] || { echo "no such image: $IMAGE" >&2; exit 1; }

    BOOT=$WORK/piboot; mkdir -p "$BOOT"
    echo "[vm] extracting kernel and dtb from the image's boot partition"
    OFFSET=$(( $(partx -g -o START -n 1 "$IMAGE" | tr -d ' ') * 512 ))
    if command -v mcopy >/dev/null; then
        mcopy -n -o -i "$IMAGE@@$OFFSET" ::kernel8.img "$BOOT/" 2>/dev/null || true
        mcopy -n -o -i "$IMAGE@@$OFFSET" ::bcm2711-rpi-4-b.dtb "$BOOT/" 2>/dev/null || true
    else
        echo "[vm] mtools not installed; falling back to a loop mount (needs sudo)"
        MNT=$(mktemp -d); sudo mount -o loop,offset=$OFFSET,ro "$IMAGE" "$MNT"
        cp "$MNT/kernel8.img" "$MNT/bcm2711-rpi-4-b.dtb" "$BOOT/"; sudo umount "$MNT"; rmdir "$MNT"
    fi
    [ -f "$BOOT/kernel8.img" ] || { echo "could not extract kernel8.img" >&2; exit 1; }

    # QEMU's raspi machines insist on an SD image sized to a power of two.
    DISK=$WORK/pi-sd.img
    [ "$FRESH" = 1 ] && rm -f "$DISK"
    if [ ! -f "$DISK" ]; then cp "$IMAGE" "$DISK"; qemu-img resize -f raw "$DISK" 8G; fi

    echo "[vm] booting the emulated Pi 4. Serial console below; Ctrl-A X to quit."
    echo "[vm] NOTE: no GPU is emulated, so the frontend cannot draw. Watch the"
    echo "[vm]       units instead:  systemctl status retropi-btpair retropi-library"
    exec qemu-system-aarch64 \
        -M raspi4b -m 2048 \
        -kernel "$BOOT/kernel8.img" -dtb "$BOOT/bcm2711-rpi-4-b.dtb" \
        -append "rw earlycon=pl011,0x fe201000 console=ttyAMA0,115200 root=/dev/mmcblk0p2 rootwait" \
        -drive file="$DISK",format=raw,if=sd \
        -serial stdio -display none
fi

# ------------------------------------------------------- Debian VM mode -----
case $ARCH in
    amd64) QEMU=qemu-system-x86_64; PKG="qemu-system-x86" ;;
    arm64) QEMU=qemu-system-aarch64; PKG="qemu-system-arm qemu-efi-aarch64" ;;
    *) echo "arch must be amd64 or arm64" >&2; exit 1 ;;
esac
need "$QEMU" "apt install $PKG"
need qemu-img "apt install qemu-utils"

BASE=$WORK/debian-12-nocloud-$ARCH.qcow2
OVERLAY=$WORK/retropi-$ARCH.qcow2
URL=https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-$ARCH.qcow2

if [ ! -f "$BASE" ]; then
    need curl "apt install curl"
    echo "[vm] downloading the Debian base image (once, ~350MB)"
    curl -fL --progress-bar -o "$BASE.part" "$URL" && mv "$BASE.part" "$BASE"
fi

# An overlay keeps the base pristine, so --fresh is instant.
if [ "$FRESH" = 1 ] || [ ! -f "$OVERLAY" ]; then
    rm -f "$OVERLAY"
    qemu-img create -q -f qcow2 -F qcow2 -b "$BASE" "$OVERLAY" 12G
    echo "[vm] created a fresh disk"
fi

ACCEL=()
if [ "$ARCH" = amd64 ] && [ -w /dev/kvm ]; then
    ACCEL=(-enable-kvm -cpu host)
    echo "[vm] KVM available - this will be quick"
else
    echo "[vm] no KVM for $ARCH on this host; running under emulation (slow but fine)"
fi

MACHINE=()
if [ "$ARCH" = arm64 ]; then
    FW=$(ls /usr/share/AAVMF/AAVMF_CODE.fd /usr/share/qemu-efi-aarch64/QEMU_EFI.fd 2>/dev/null | head -n1)
    [ -n "$FW" ] || { echo "missing UEFI firmware: apt install qemu-efi-aarch64" >&2; exit 1; }
    MACHINE=(-M virt -cpu cortex-a72 -bios "$FW")
fi

cat <<BANNER

[vm] Booting. The Debian nocloud image logs straight in as root on this console.

     Inside the VM:

       mkdir -p /mnt/retropi && mount -t 9p -o trans=virtio,version=9p2000.L retropi /mnt/retropi
       cd /mnt/retropi && ./install.sh && ./test/smoke-test.sh

     ssh is forwarded to localhost:$SSH_PORT once you enable it in the guest.
     Ctrl-A then X quits QEMU.

BANNER

exec "$QEMU" "${ACCEL[@]}" "${MACHINE[@]}" \
    -m "$MEM" -smp "$CPUS" \
    -drive file="$OVERLAY",if=virtio,format=qcow2 \
    -netdev user,id=net0,hostfwd=tcp::"$SSH_PORT"-:22 -device virtio-net-pci,netdev=net0 \
    -virtfs local,path="$ROOT",mount_tag=retropi,security_model=mapped-xattr,id=retropi \
    -nographic
