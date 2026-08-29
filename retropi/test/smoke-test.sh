#!/usr/bin/env bash
# Run INSIDE a VM (or on the Pi itself) after install.sh, to check the install
# actually landed. Asserts state, changes nothing.
set -uo pipefail

PASS=0 FAIL=0 WARN=0
ok()   { PASS=$((PASS+1)); printf '\033[32m  ok   \033[0m%s\n' "$*"; }
bad()  { FAIL=$((FAIL+1)); printf '\033[31m  FAIL \033[0m%s\n' "$*"; }
warn() { WARN=$((WARN+1)); printf '\033[33m  warn \033[0m%s\n' "$*"; }
head_(){ printf '\n\033[1m%s\033[0m\n' "$*"; }

check()      { if eval "$2" >/dev/null 2>&1; then ok "$1"; else bad "$1"; fi; }
check_warn() { if eval "$2" >/dev/null 2>&1; then ok "$1"; else warn "$1"; fi; }

USER_NAME=${SUDO_USER:-$(getent passwd 1000 | cut -d: -f1)}
USER_HOME=$(getent passwd "$USER_NAME" | cut -d: -f6)
BOOTDIR=/boot/firmware; [ -d "$BOOTDIR" ] || BOOTDIR=/boot

head_ "files"
check "/opt/retropi/lib/common.sh installed"   "[ -r /opt/retropi/lib/common.sh ]"
for b in retropi-bt-pair retropi-library retropi-stream retropi-update \
         retropi-session retropi-frontend retropi-firstboot; do
    check "$b is executable" "[ -x /opt/retropi/bin/$b ]"
done
check "commands are on PATH"                   "command -v retropi-library"
check "retropi-setup alias resolves"           "[ -x /opt/retropi/bin/retropi-setup ]"
check "state directory exists"                 "[ -d /var/lib/retropi ]"

head_ "configuration"
check "retropi.conf is on the boot partition"  "[ -f $BOOTDIR/retropi/retropi.conf ]"
check "config parses"                          "retropi-library status"
check "ROMs directory exists"                  "[ -d $USER_HOME/ROMs ]"
check "ROMs directory is owned by $USER_NAME"  "[ \"\$(stat -c %U $USER_HOME/ROMs)\" = $USER_NAME ]"
check "RetroArch config was seeded"            "[ -f $USER_HOME/.config/retroarch/retroarch.cfg ]"
check "our hotkey defaults are present"        "grep -q input_exit_emulator_btn $USER_HOME/.config/retroarch/retroarch.cfg"
check_warn "controller profiles installed"     "[ -n \"\$(ls -A $USER_HOME/.config/retroarch/autoconfig 2>/dev/null)\" ]"

head_ "packages"
check "retroarch installed"                    "command -v retroarch"
check "X server installed"                     "command -v Xorg"
check "bluez installed"                        "command -v bluetoothctl"
check "cifs support installed"                 "[ -x /sbin/mount.cifs ] || command -v mount.cifs"
check_warn "ES-DE frontend downloaded"         "[ -x /opt/retropi/share/ES-DE.AppImage ]"
check_warn "moonlight installed"               "command -v moonlight"

head_ "services"
check "btpair unit enabled"                    "systemctl is-enabled retropi-btpair.service"
check "library unit enabled"                   "systemctl is-enabled retropi-library.service"
check "session unit enabled for $USER_NAME"    "systemctl is-enabled retropi-session@$USER_NAME.service"
check "getty on tty1 is disabled"              "! systemctl is-enabled getty@tty1.service"
check "default target is multi-user"           "[ \"\$(systemctl get-default)\" = multi-user.target ]"
check_warn "bluetooth service enabled"         "systemctl is-enabled bluetooth"
check_warn "smbd enabled"                      "systemctl is-enabled smbd"

head_ "permissions"
check "sudoers fragment is valid"              "visudo -cf /etc/sudoers.d/retropi"
check "sudoers fragment is mode 0440"          "[ \"\$(stat -c %a /etc/sudoers.d/retropi)\" = 440 ]"
check "$USER_NAME is in the retropi group"     "id -nG $USER_NAME | grep -qw retropi"
check "$USER_NAME is in the input group"       "id -nG $USER_NAME | grep -qw input"
check "X can be started by a non-console user" "grep -q 'allowed_users=anybody' /etc/X11/Xwrapper.config"
check "udev rules installed"                   "[ -f /etc/udev/rules.d/99-retropi.rules ]"

head_ "behaviour"
check "bt-pair status runs and reports"        "retropi-bt-pair status; [ \$? -le 1 ]"
check "library status runs"                    "retropi-library status"
check "an unknown library type is rejected"    "! sh -c 'sed -i s/^library_type.*/library_type=ftp/ $BOOTDIR/retropi/retropi.conf; retropi-library mount'"
sed -i 's/^library_type.*/library_type = none/' "$BOOTDIR/retropi/retropi.conf" 2>/dev/null
check "samba exports the ROMs share"           "grep -q '^\[ROMs\]' /etc/samba/smb.conf"
check_warn "boot config has the KMS overlay"   "grep -q vc4-kms-v3d $BOOTDIR/config.txt"

printf '\n\033[1m%d passed, %d failed, %d warnings\033[0m\n' "$PASS" "$FAIL" "$WARN"
[ "$WARN" -gt 0 ] && printf 'Warnings are expected in a VM: no Pi hardware, no GPU, no radio.\n'
[ "$FAIL" -eq 0 ]
