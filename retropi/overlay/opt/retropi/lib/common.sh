#!/usr/bin/env bash
# Shared helpers for RetroPi scripts. Sourced, never executed directly.

RETROPI_PREFIX=${RETROPI_PREFIX:-/opt/retropi}
RETROPI_BIN=$RETROPI_PREFIX/bin
RETROPI_LIB=$RETROPI_PREFIX/lib
RETROPI_SHARE=$RETROPI_PREFIX/share
RETROPI_STATE=${RETROPI_STATE:-/var/lib/retropi}
RETROPI_USER=${RETROPI_USER:-$(getent passwd 1000 | cut -d: -f1)}
RETROPI_HOME=$(getent passwd "$RETROPI_USER" | cut -d: -f6)
RETROPI_ROMS=${RETROPI_ROMS:-$RETROPI_HOME/ROMs}

# Boot-partition config lives on the FAT partition so it can be edited from any
# machine before the Pi is ever powered on.
for d in /boot/firmware/retropi /boot/retropi; do
    [ -d "$d" ] && RETROPI_BOOTCONF_DIR=$d && break
done
RETROPI_BOOTCONF_DIR=${RETROPI_BOOTCONF_DIR:-/boot/firmware/retropi}
RETROPI_CONF=$RETROPI_BOOTCONF_DIR/retropi.conf

log()  { printf '[retropi] %s\n' "$*" >&2; }
warn() { printf '[retropi] WARN: %s\n' "$*" >&2; }
die()  { printf '[retropi] ERROR: %s\n' "$*" >&2; exit 1; }

# Read a key from retropi.conf. Usage: conf_get key [default]
conf_get() {
    local key=$1 default=${2-} value=
    if [ -r "$RETROPI_CONF" ]; then
        value=$(sed -n "s/^[[:space:]]*${key}[[:space:]]*=[[:space:]]*//p" "$RETROPI_CONF" | tail -n1)
        value=${value%\"}; value=${value#\"}
    fi
    printf '%s' "${value:-$default}"
}

conf_set() {
    local key=$1 value=$2
    mkdir -p "$RETROPI_BOOTCONF_DIR"
    touch "$RETROPI_CONF"
    if grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$RETROPI_CONF"; then
        sed -i "s|^[[:space:]]*${key}[[:space:]]*=.*|${key} = ${value}|" "$RETROPI_CONF"
    else
        printf '%s = %s\n' "$key" "$value" >> "$RETROPI_CONF"
    fi
}

conf_bool() {
    case $(conf_get "$1" "${2:-no}" | tr '[:upper:]' '[:lower:]') in
        1|y|yes|true|on) return 0 ;;
        *) return 1 ;;
    esac
}

as_user() { sudo -u "$RETROPI_USER" -H "$@"; }

have() { command -v "$1" >/dev/null 2>&1; }

# Marker files under $RETROPI_STATE guard one-shot work.
state_done()     { [ -e "$RETROPI_STATE/$1.done" ]; }
mark_done()      { mkdir -p "$RETROPI_STATE"; : > "$RETROPI_STATE/$1.done"; }
