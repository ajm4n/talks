#!/usr/bin/env python3
"""Adversarial tests for the portal's path handling.

The portal writes files supplied by anyone on the network, so the only thing
standing between a filename and the rest of the filesystem is safe_name(),
safe_system() and resolve_under(). Those are tested here directly.
"""
import importlib.machinery
import importlib.util
import os
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_loader(
    "portal",
    importlib.machinery.SourceFileLoader(
        "portal", str(ROOT / "overlay/opt/retropi/bin/retropi-portal")))
portal = importlib.util.module_from_spec(spec)
spec.loader.exec_module(portal)

PASS = FAIL = 0


def ok(msg):
    global PASS
    PASS += 1
    print(f"  ok   {msg}")


def bad(msg, detail=""):
    global FAIL
    FAIL += 1
    print(f"  FAIL {msg}")
    if detail:
        print(f"       {detail}")


def rejects(name, label):
    got = portal.safe_name(name)
    ok(label) if got is None else bad(label, f"accepted as {got!r}")


def accepts(name, label, expect=None):
    got = portal.safe_name(name)
    if got is None:
        bad(label, "rejected")
    elif expect and got != expect:
        bad(label, f"got {got!r}, wanted {expect!r}")
    else:
        ok(label)


print("\nsafe_name: traversal and separators")
rejects("../../../../etc/passwd", "parent traversal")
rejects("..%2f..%2fetc%2fpasswd.zip", "encoded traversal is not decoded twice")
accepts("/etc/cron.d/evil.zip", "absolute path stripped to basename", "evil.zip")
rejects("....//....//etc/shadow", "doubled-dot traversal")
rejects("..", "bare ..")
rejects(".", "bare .")
rejects("", "empty name")
accepts("../../game.zip", "traversal stripped to basename", "game.zip")
accepts(r"C:\Windows\rom.zip", "windows path stripped", "rom.zip")
accepts("sub/dir/game.sfc", "unix path stripped", "game.sfc")

print("\nsafe_name: hidden files and null bytes")
rejects(".bashrc", "dotfile")
rejects(".ssh", "dot directory name")
rejects("rom\x00.zip", "embedded null byte")
rejects("x" * 300 + ".zip", "absurdly long name")

print("\nsafe_name: extension allowlist")
rejects("payload.sh", "shell script")
rejects("authorized_keys", "no extension")
rejects("rom.zip.sh", "double extension, real one last")
rejects("evil.service", "systemd unit")
rejects("index.html", "html")
accepts("Super Mario World.sfc", "legitimate rom")
accepts("Final Fantasy VII (Disc 1).cue", "parentheses and spaces")
accepts("Game [!].zip", "brackets and bang")
accepts("ROM.ZIP", "uppercase extension accepted")
accepts("Sonic & Knuckles.md", "ampersand")

print("\nsafe_name: unicode")
rejects("\uff0e\uff0e\uff0f\uff0e\uff0e\uff0fetc\uff0fpasswd", "fullwidth traversal")
accepts("Pok\u00e9mon.gba", "accented latin kept or transliterated")

print("\nsafe_system")
for bad_sys, label in [
        ("../etc", "traversal"), ("/abs", "absolute"), ("", "empty"),
        ("has space", "space"),
        ("a" * 40, "too long"), ("-lead", "leading dash"), ("..", "dotdot")]:
    got = portal.safe_system(bad_sys)
    ok(f"rejects {label}") if got is None else bad(f"rejects {label}",
                                                  f"accepted {got!r}")
for good, label in [("snes", "snes"), ("mega-drive", "hyphen"),
                    ("pcengine_cd", "underscore"), ("n64", "digits")]:
    ok(f"accepts {label}") if portal.safe_system(good) == good else \
        bad(f"accepts {label}")
if portal.safe_system("SNES") == "snes":
    ok("lowercases input")
else:
    bad("lowercases input")

print("\nresolve_under: containment")
with tempfile.TemporaryDirectory() as td:
    base = Path(td) / "ROMs"
    (base / "snes").mkdir(parents=True)
    outside = Path(td) / "outside"
    outside.mkdir()

    r = portal.resolve_under(base, "snes", "game.sfc")
    ok("normal path resolves") if r and str(r).startswith(str(base.resolve())) \
        else bad("normal path resolves", str(r))

    r = portal.resolve_under(base, "..", "escape.sfc")
    ok("rejects .. component") if r is None else bad("rejects .. component", str(r))

    # A symlinked system directory pointing outside must not be writable
    # through the portal, even though the network-library feature makes
    # symlinked system dirs legitimate in general.
    (base / "evil").symlink_to(outside)
    r = portal.resolve_under(base, "evil", "pwn.sfc")
    ok("rejects symlink escaping the library") if r is None else \
        bad("rejects symlink escaping the library", str(r))

    # A symlink that stays inside is fine.
    (base / "inside").symlink_to(base / "snes")
    r = portal.resolve_under(base, "inside", "ok.sfc")
    ok("allows symlink staying inside") if r is not None else \
        bad("allows symlink staying inside")

print("\nconfig parsing")
ok("missing key returns default") if portal.conf_get("nope", "d") == "d" else \
    bad("missing key returns default")

print(f"\n{PASS} passed, {FAIL} failed")
sys.exit(1 if FAIL else 0)
