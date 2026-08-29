#!/bin/bash -e
# Resolve the RetroPi source tree from this script's own real location, since
# pi-gen's BASE_DIR points at pi-gen's root, not at ours, and this stage is
# reached through a symlink.
RETROPI_SRC=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../.." && pwd)

# Runs inside pi-gen against the image rootfs. The packages in ../00-packages
# are already installed, so this reuses install.sh with the package step and
# the network fetches turned off - pi-gen has no working service manager and
# the AppImage is fetched on first boot instead.

install -d "${ROOTFS_DIR}/usr/local/src/retropi"
cp -r "${RETROPI_SRC}/overlay"   "${ROOTFS_DIR}/usr/local/src/retropi/"
cp -r "${RETROPI_SRC}/config"    "${ROOTFS_DIR}/usr/local/src/retropi/"
cp    "${RETROPI_SRC}/install.sh" "${ROOTFS_DIR}/usr/local/src/retropi/"

# Overlay straight in - no chroot service juggling.
cp -r "${RETROPI_SRC}/overlay/opt/retropi/." "${ROOTFS_DIR}/opt/retropi/" 2>/dev/null || {
    install -d "${ROOTFS_DIR}/opt/retropi"
    cp -r "${RETROPI_SRC}/overlay/opt/retropi/." "${ROOTFS_DIR}/opt/retropi/"
}
cp -r "${RETROPI_SRC}/overlay/etc/." "${ROOTFS_DIR}/etc/"
chmod +x "${ROOTFS_DIR}/opt/retropi/bin/"*
chmod 0440 "${ROOTFS_DIR}/etc/sudoers.d/retropi"
install -d "${ROOTFS_DIR}/var/lib/retropi"
install -d "${ROOTFS_DIR}/boot/firmware/retropi"
install -m 0644 "${RETROPI_SRC}/config/retropi.conf.example" \
    "${ROOTFS_DIR}/boot/firmware/retropi/retropi.conf"

# Cores, controller profiles and the frontend are fetched on the first boot the
# Pi has network, so the image stays small and never ships a stale AppImage.
install -m 0644 "${RETROPI_SRC}/pi-gen/stage-retropi/00-retropi/files/retropi-firstrun.service" \
    "${ROOTFS_DIR}/etc/systemd/system/retropi-firstrun.service"

on_chroot << CHROOT
set -e
USER_NAME="\${FIRST_USER_NAME:-pi}"
getent group retropi >/dev/null || groupadd retropi
for g in retropi input video audio render bluetooth plugdev tty; do
    getent group "\$g" >/dev/null && usermod -aG "\$g" "\$USER_NAME" || true
done

install -d /usr/local/bin
for f in /opt/retropi/bin/*; do ln -sf "\$f" "/usr/local/bin/\$(basename "\$f")"; done

install -d -o "\$USER_NAME" -g "\$USER_NAME" \
    "/home/\$USER_NAME/ROMs" "/home/\$USER_NAME/ES-DE" \
    "/home/\$USER_NAME/ES-DE/custom_systems" \
    "/home/\$USER_NAME/.config/retroarch/autoconfig"
cp /opt/retropi/share/retroarch/retroarch.cfg "/home/\$USER_NAME/.config/retroarch/retroarch.cfg"
cp /opt/retropi/share/es-de/es_settings.xml "/home/\$USER_NAME/ES-DE/es_settings.xml"
cp /opt/retropi/share/es-de/es_systems.xml "/home/\$USER_NAME/ES-DE/custom_systems/es_systems.xml"
chown -R "\$USER_NAME:\$USER_NAME" "/home/\$USER_NAME/.config" "/home/\$USER_NAME/ES-DE"

printf 'allowed_users=anybody\nneeds_root_rights=yes\n' > /etc/X11/Xwrapper.config

systemctl enable bluetooth
systemctl enable retropi-btpair.service
systemctl enable retropi-library.service
systemctl enable retropi-session@\$USER_NAME.service
systemctl enable retropi-portal@\$USER_NAME.service
systemctl enable retropi-firstrun.service
systemctl disable getty@tty1.service || true
systemctl set-default multi-user.target

if ! grep -q '^\[ROMs\]' /etc/samba/smb.conf; then
cat >> /etc/samba/smb.conf <<SMB

[ROMs]
   comment = RetroPi game library
   path = /home/\$USER_NAME/ROMs
   browseable = yes
   writeable = yes
   guest ok = yes
   force user = \$USER_NAME
SMB
fi
systemctl enable smbd || true
CHROOT

# Boot config tweaks.
CONFIGTXT="${ROOTFS_DIR}/boot/firmware/config.txt"
[ -f "$CONFIGTXT" ] || CONFIGTXT="${ROOTFS_DIR}/boot/config.txt"
if [ -f "$CONFIGTXT" ] && ! grep -q '^# --- retropi ---' "$CONFIGTXT"; then
cat >> "$CONFIGTXT" <<'TXT'

# --- retropi ---
dtoverlay=vc4-kms-v3d
max_framebuffers=2
hdmi_force_hotplug=1
disable_overscan=1
dtparam=audio=on
TXT
fi

CMDLINE="${ROOTFS_DIR}/boot/firmware/cmdline.txt"
[ -f "$CMDLINE" ] || CMDLINE="${ROOTFS_DIR}/boot/cmdline.txt"
if [ -f "$CMDLINE" ] && ! grep -q 'logo.nologo' "$CMDLINE"; then
    sed -i '1 s/$/ quiet loglevel=3 logo.nologo vt.global_cursor_default=0/' "$CMDLINE"
fi
