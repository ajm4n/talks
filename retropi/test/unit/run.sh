#!/usr/bin/env bash
# Hardware-free tests for the RetroPi scripts. No Pi, no radio, no root.
#
#   ./test/unit/run.sh            run everything
#   ./test/unit/run.sh bt         run tests whose name matches "bt"
set -uo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
STUBS=$ROOT/test/stubs
BIN=$ROOT/overlay/opt/retropi/bin
FILTER=${1:-}

PASS=0 FAIL=0
red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }

ok()   { PASS=$((PASS+1)); green "  ok   $*"; }
notok(){ FAIL=$((FAIL+1)); red   "  FAIL $*"; }

assert_eq() {
    [ "$2" = "$3" ] && ok "$1" || { notok "$1"; printf '       want: %q\n       got:  %q\n' "$3" "$2"; }
}
assert_contains() {
    case "$2" in *"$3"*) ok "$1" ;; *) notok "$1"; printf '       %q does not contain %q\n' "$2" "$3" ;; esac
}
assert_status() {
    local name=$1 want=$2; shift 2
    "$@" >/dev/null 2>&1; local got=$?
    [ "$got" = "$want" ] && ok "$name" || { notok "$name"; printf '       exit want=%s got=%s\n' "$want" "$got"; }
}

test_case() {
    case "$1" in *"$FILTER"*) printf '\n\033[1m%s\033[0m\n' "$1"; return 0 ;; esac
    return 1
}

# ---------------------------------------------------------------- fixtures ---
new_bt_state() {
    local d; d=$(mktemp -d)
    printf '%s' "$(date +%s)" > "$d/start_time"
    : > "$d/devices"; : > "$d/commands.log"
    printf '%s' "$d"
}
add_device() {  # state mac name icon class paired connected delay
    printf '%s|%s|%s|%s|%s|%s|%s\n' "$2" "$3" "$4" "$5" "$6" "$7" "${8:-0}" >> "$1/devices"
}
bt() { STUB_BT_STATE=$BT_STATE PATH="$STUBS:$PATH" "$BIN/retropi-bt-pair" "$@"; }

# =========================================================== conf helpers ====
if test_case "common.sh: config parsing"; then
    D=$(mktemp -d)
    cat > "$D/retropi.conf" <<'CONF'
library_type = smb
library_host = 192.168.1.20
library_pass =
usb_import = yes
library_writable = no
quoted = "hello world"
CONF
    out=$(RETROPI_BOOTCONF_DIR=$D bash -c '
        . '"$ROOT"'/overlay/opt/retropi/lib/common.sh
        RETROPI_CONF='"$D"'/retropi.conf
        echo "type=$(conf_get library_type)"
        echo "host=$(conf_get library_host)"
        echo "default=$(conf_get absent fallback)"
        echo "emptyfallback=$(conf_get library_pass none)"
        echo "quoted=$(conf_get quoted)"
        conf_bool usb_import       && echo "usb=on"  || echo "usb=off"
        conf_bool library_writable && echo "wr=on"   || echo "wr=off"
        conf_bool absent yes       && echo "abs=on"  || echo "abs=off"
    ')
    assert_contains "reads a value"                 "$out" "type=smb"
    assert_contains "reads an IP"                   "$out" "host=192.168.1.20"
    assert_contains "falls back when key absent"    "$out" "default=fallback"
    assert_contains "falls back when value empty"   "$out" "emptyfallback=none"
    assert_contains "strips surrounding quotes"     "$out" "quoted=hello world"
    assert_contains "conf_bool yes"                 "$out" "usb=on"
    assert_contains "conf_bool no"                  "$out" "wr=off"
    assert_contains "conf_bool honours a default"   "$out" "abs=on"
    rm -rf "$D"
fi

if test_case "common.sh: conf_set round-trips"; then
    D=$(mktemp -d); printf 'existing = old\n' > "$D/retropi.conf"
    out=$(RETROPI_BOOTCONF_DIR=$D bash -c '
        . '"$ROOT"'/overlay/opt/retropi/lib/common.sh
        RETROPI_BOOTCONF_DIR='"$D"'; RETROPI_CONF='"$D"'/retropi.conf
        conf_set existing new
        conf_set fresh value
        echo "existing=$(conf_get existing)"
        echo "fresh=$(conf_get fresh)"
        echo "lines=$(wc -l < "$RETROPI_CONF")"
    ')
    assert_contains "updates an existing key in place" "$out" "existing=new"
    assert_contains "appends a new key"                "$out" "fresh=value"
    assert_contains "does not duplicate the key"       "$out" "lines=2"
    rm -rf "$D"
fi

# ======================================================= bluetooth pairing ====
if test_case "bt: status reports no controller when none connected"; then
    BT_STATE=$(new_bt_state)
    add_device "$BT_STATE" "11:11:11:11:11:11" "Bose QC35" "audio-headset" "0x240418" "yes" "yes"
    assert_status "exits 1 with only a headset connected" 1 bt status
    out=$(bt status 2>&1)
    assert_contains "says so plainly" "$out" "no controller connected"
    rm -rf "$BT_STATE"
fi

if test_case "bt: pairs a gamepad found by name"; then
    BT_STATE=$(new_bt_state)
    add_device "$BT_STATE" "22:22:22:22:22:22" "8BitDo SN30 Pro" "" "0x000000" "no" "no" 2
    bt pair 20 >/dev/null 2>&1
    assert_eq "device is now paired"    "$(awk -F'|' '{print $5}' "$BT_STATE/devices")" "yes"
    assert_eq "device is now connected" "$(awk -F'|' '{print $6}' "$BT_STATE/devices")" "yes"
    assert_contains "it was trusted, so it reconnects itself later" \
        "$(cat "$BT_STATE/commands.log")" "trust 22:22:22:22:22:22"
    assert_status "status now succeeds" 0 bt status
    rm -rf "$BT_STATE"
fi

if test_case "bt: recognises a pad by BlueZ icon despite a junk name"; then
    BT_STATE=$(new_bt_state)
    add_device "$BT_STATE" "33:33:33:33:33:33" "BT5.0" "input-gaming" "0x000000" "no" "no" 1
    bt pair 15 >/dev/null 2>&1
    assert_eq "paired via input-gaming icon" "$(awk -F'|' '{print $6}' "$BT_STATE/devices")" "yes"
    rm -rf "$BT_STATE"
fi

if test_case "bt: recognises a pad by device class"; then
    BT_STATE=$(new_bt_state)
    add_device "$BT_STATE" "44:44:44:44:44:44" "Generic BT" "" "0x002508" "no" "no" 1
    bt pair 15 >/dev/null 2>&1
    assert_eq "paired via gamepad class 0x002508" "$(awk -F'|' '{print $6}' "$BT_STATE/devices")" "yes"
    rm -rf "$BT_STATE"
fi

if test_case "bt: ignores devices that are not gamepads"; then
    BT_STATE=$(new_bt_state)
    add_device "$BT_STATE" "55:55:55:55:55:55" "LE_WH-1000XM4" "audio-headset" "0x240404" "no" "no" 1
    add_device "$BT_STATE" "66:66:66:66:66:66" "Apple Wireless Keyboard" "input-keyboard" "0x002540" "no" "no" 1
    bt pair 8 >/dev/null 2>&1
    assert_eq "headset left alone"  "$(awk -F'|' '$1 ~ /^55/ {print $6}' "$BT_STATE/devices")" "no"
    assert_eq "keyboard left alone" "$(awk -F'|' '$1 ~ /^66/ {print $6}' "$BT_STATE/devices")" "no"
    rm -rf "$BT_STATE"
fi

if test_case "bt: survives a pad that refuses to pair"; then
    BT_STATE=$(new_bt_state)
    add_device "$BT_STATE" "77:77:77:77:77:77" "UNPAIRABLE" "input-gaming" "0x000000" "no" "no" 1
    assert_status "pair window exits non-zero rather than hanging" 1 bt pair 8
    rm -rf "$BT_STATE"
fi

if test_case "bt: forget removes pads but leaves other devices"; then
    BT_STATE=$(new_bt_state)
    add_device "$BT_STATE" "88:88:88:88:88:88" "DualSense Wireless Controller" "input-gaming" "0x002508" "yes" "yes"
    add_device "$BT_STATE" "99:99:99:99:99:99" "Bose QC35" "audio-headset" "0x240418" "yes" "yes"
    bt forget >/dev/null 2>&1
    assert_status "gamepad removed"  1 grep -q "^88:" "$BT_STATE/devices"
    assert_status "headset retained" 0 grep -q "^99:" "$BT_STATE/devices"
    rm -rf "$BT_STATE"
fi

if test_case "bt: reconnects a known pad without re-pairing"; then
    BT_STATE=$(new_bt_state)
    add_device "$BT_STATE" "AA:AA:AA:AA:AA:AA" "Xbox Wireless Controller" "input-gaming" "0x002508" "yes" "no"
    STUB_BT_STATE=$BT_STATE PATH="$STUBS:$PATH" timeout 12 "$BIN/retropi-bt-pair" daemon >/dev/null 2>&1
    assert_eq "reconnected" "$(awk -F'|' '{print $6}' "$BT_STATE/devices")" "yes"
    assert_status "never re-ran pair on an already-paired device" 1 \
        grep -q "^pair AA:" "$BT_STATE/commands.log"
    rm -rf "$BT_STATE"
fi

# ============================================================== streaming ====
if test_case "stream: sync writes one launcher per host app"; then
    D=$(mktemp -d); CONF=$D/boot; mkdir -p "$CONF" "$D/home"
    printf 'stream_host = 10.0.0.5\n' > "$CONF/retropi.conf"
    out=$(STUB_MOONLIGHT_STATE=$D PATH="$STUBS:$PATH" \
        RETROPI_BOOTCONF_DIR=$CONF RETROPI_ROMS=$D/home/ROMs RETROPI_STATE=$D/state \
        "$BIN/retropi-stream" sync 2>&1)
    assert_eq "one .stream per app" "$(ls -1 "$D/home/ROMs/moonlight" | wc -l)" "3"
    assert_status "app with a space in the name is handled" 0 \
        test -f "$D/home/ROMs/moonlight/Steam Big Picture.stream"
    assert_eq "launcher contains the app name" \
        "$(cat "$D/home/ROMs/moonlight/Hollow Knight.stream")" "Hollow Knight"
    assert_status "marks the library dirty so the frontend rescans" 0 test -f "$D/state/library-dirty"
    rm -rf "$D"
fi

if test_case "stream: launcher shim passes the app through"; then
    D=$(mktemp -d); mkdir -p "$D/bin"; printf 'Hollow Knight\n' > "$D/game.stream"
    cat > "$D/bin/retropi-stream" <<'SHIM'
#!/usr/bin/env bash
echo "ARGS:$*"
SHIM
    chmod +x "$D/bin/retropi-stream"
    out=$(RETROPI_PREFIX=$D "$BIN/retropi-stream-launch" "$D/game.stream")
    assert_eq "reads the app name out of the file" "$out" "ARGS:play Hollow Knight"
    assert_status "errors clearly with no argument" 1 env RETROPI_PREFIX=$D "$BIN/retropi-stream-launch"
    rm -rf "$D"
fi

if test_case "stream: refuses to run without a host"; then
    D=$(mktemp -d); mkdir -p "$D/boot"; : > "$D/boot/retropi.conf"
    out=$(STUB_MOONLIGHT_STATE=$D PATH="$STUBS:$PATH" RETROPI_BOOTCONF_DIR=$D/boot \
        "$BIN/retropi-stream" list 2>&1)
    assert_contains "explains what to do" "$out" "retropi-stream pair"
    rm -rf "$D"
fi

# ================================================================ library ====
if test_case "library: status reports an unconfigured install"; then
    D=$(mktemp -d); mkdir -p "$D/boot" "$D/ROMs"; : > "$D/boot/retropi.conf"
    out=$(RETROPI_BOOTCONF_DIR=$D/boot RETROPI_ROMS=$D/ROMs RETROPI_NET_MOUNT=$D/mnt \
        "$BIN/retropi-library" status 2>&1)
    assert_contains "shows the local path"      "$out" "$D/ROMs"
    assert_contains "shows no share configured" "$out" "not configured"
    rm -rf "$D"
fi

if test_case "library: rejects an unknown share type"; then
    D=$(mktemp -d); mkdir -p "$D/boot"
    printf 'library_type = ftp\nlibrary_host = h\nlibrary_share = s\n' > "$D/boot/retropi.conf"
    out=$(RETROPI_BOOTCONF_DIR=$D/boot RETROPI_ROMS=$D/ROMs RETROPI_NET_MOUNT=$D/mnt \
        "$BIN/retropi-library" mount 2>&1)
    assert_contains "names the bad value" "$out" "unknown library_type"
    rm -rf "$D"
fi

if test_case "library: refuses an incomplete share config"; then
    D=$(mktemp -d); mkdir -p "$D/boot"
    printf 'library_type = smb\n' > "$D/boot/retropi.conf"
    out=$(RETROPI_BOOTCONF_DIR=$D/boot RETROPI_ROMS=$D/ROMs RETROPI_NET_MOUNT=$D/mnt \
        "$BIN/retropi-library" mount 2>&1)
    assert_contains "says which keys are missing" "$out" "library_host"
    rm -rf "$D"
fi

# ================================================================= portal ====
if test_case "portal: adversarial path handling"; then
    if out=$(python3 "$ROOT/test/unit/test_portal.py" 2>&1); then
        n=$(printf '%s' "$out" | grep -c '^  ok')
        PASS=$((PASS + n)); green "  ok   $n path-safety assertions"
    else
        FAIL=$((FAIL + 1)); red "  FAIL portal path handling"; printf '%s\n' "$out" | grep -A2 FAIL
    fi
fi

# ================================================================= report ====
printf '\n\033[1m%d passed, %d failed\033[0m\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
