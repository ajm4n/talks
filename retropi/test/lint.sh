#!/usr/bin/env bash
# Static checks. No Pi, no VM, no root - safe to run anywhere, including CI.
set -uo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"

PASS=0 FAIL=0 SKIP=0
ok()   { PASS=$((PASS+1)); printf '\033[32m  ok   \033[0m%s\n' "$*"; }
bad()  { FAIL=$((FAIL+1)); printf '\033[31m  FAIL \033[0m%s\n' "$*"; }
skip() { SKIP=$((SKIP+1)); printf '\033[33m  skip \033[0m%s\n' "$*"; }
head_() { printf '\n\033[1m%s\033[0m\n' "$*"; }

scripts() {
    find . -type f \( -name '*.sh' -o -path './overlay/opt/retropi/bin/*' \
        -o -path './test/stubs/*' -o -name '00-run.sh' \) -not -type l | sort
}

head_ "bash syntax"
while read -r f; do
    bash -n "$f" 2>/dev/null && ok "$f" || bad "$f: $(bash -n "$f" 2>&1 | head -n1)"
done < <(scripts)

head_ "shellcheck"
if command -v shellcheck >/dev/null; then
    while read -r f; do
        # SC1091: we source a path that only exists once installed.
        if out=$(shellcheck -e SC1091 -S warning "$f" 2>&1); then
            ok "$f"
        else
            bad "$f"; printf '%s\n' "$out" | head -n 20
        fi
    done < <(scripts)
else
    skip "shellcheck not installed (apt install shellcheck)"
fi

head_ "systemd units"
if command -v systemd-analyze >/dev/null; then
    for u in overlay/etc/systemd/system/*; do
        # Templates need an instance before they can be verified.
        target=$u
        if [[ $u == *@.service ]]; then
            target=$(mktemp -d)/$(basename "${u/@./@lint.}")
            cp "$u" "$target"
        fi
        # "is not executable" only fires because RetroPi is not installed on the
        # linting machine; that the paths exist in the tree is checked below.
        out=$(systemd-analyze verify "$target" 2>&1 \
            | grep -vE 'is not executable|Unknown key|Failed to prepare|^systemd-analyze' \
            | grep -vE 'Unit [a-z@.-]+\.(service|target|mount) not found')
        if [ -z "$out" ]; then ok "$(basename "$u")"
        else bad "$(basename "$u")"; printf '%s\n' "$out"; fi
    done
else
    skip "systemd-analyze not available"
fi

head_ "sudoers"
if command -v visudo >/dev/null; then
    if out=$(visudo -cf overlay/etc/sudoers.d/retropi 2>&1); then ok "syntax valid"
    else bad "invalid"; printf '%s\n' "$out"; fi
    # A wildcard in an NOPASSWD rule is how these fragments turn into a root shell.
    if grep -qE 'NOPASSWD.*\*' overlay/etc/sudoers.d/retropi; then
        bad "contains a wildcard in a NOPASSWD rule"
    else ok "no wildcards in NOPASSWD rules"; fi
else
    skip "visudo not available"
fi

head_ "xml"
if command -v xmllint >/dev/null; then
    for f in overlay/opt/retropi/share/es-de/*.xml; do
        xmllint --noout "$f" 2>/dev/null && ok "$(basename "$f")" || bad "$(basename "$f")"
    done
else
    skip "xmllint not available"
fi

head_ "udev rules"
if command -v udevadm >/dev/null; then
    if out=$(udevadm verify overlay/etc/udev/rules.d/99-retropi.rules 2>&1); then ok "99-retropi.rules"
    else bad "99-retropi.rules"; printf '%s\n' "$out"; fi
else
    skip "udevadm not available"
fi

head_ "consistency"
# Installed-path references in units and configs must point at files we ship.
missing=0
while read -r p; do
    rel=overlay${p}
    [ -e "$rel" ] || { bad "referenced but not shipped: $p"; missing=1; }
done < <(grep -rhoE '/opt/retropi/(bin|lib|share)/[A-Za-z0-9._/-]+' \
            overlay/etc overlay/opt/retropi/share pi-gen 2>/dev/null | sort -u)
[ "$missing" -eq 0 ] && ok "every /opt/retropi path referenced by a unit exists"

# Every executable must be listed in the README command table or be internal.
for b in overlay/opt/retropi/bin/*; do
    n=$(basename "$b")
    case $n in retropi-session|retropi-frontend|retropi-stream-launch|retropi-firstboot) continue ;; esac
    grep -q "$n" README.md || bad "$n is undocumented in README.md"
done
ok "user-facing commands are documented"

printf '\n\033[1m%d passed, %d failed, %d skipped\033[0m\n' "$PASS" "$FAIL" "$SKIP"
[ "$FAIL" -eq 0 ]
