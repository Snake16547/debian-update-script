#!/usr/bin/env bash
# Up — minimal Debian/Ubuntu package updater
# Based on "Up" by Joe Collins (ezeelinux.com), GPL-2.0.
set -Eeuo pipefail

VERSION="2.0.0"
export DEBIAN_FRONTEND="${DEBIAN_FRONTEND:-readline}"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  bold=$'\033[1m'; dim=$'\033[2m'; green=$'\033[32m'; red=$'\033[31m'; reset=$'\033[0m'
else
  bold=''; dim=''; green=''; red=''; reset=''
fi
info() { printf '%s  • %s%s\n' "$dim" "$*" "$reset"; }
ok() { printf '%s  ✓ %s%s\n' "$green" "$*" "$reset"; }
die() { printf '%sError:%s %s\n' "$red" "$reset" "$*" >&2; exit 1; }
usage() {
  cat <<'HELP'
Up — minimal Debian/Ubuntu updater

Usage: ./update.sh [option]

  (none)       Refresh package lists and full-upgrade
  --remove     Also autoremove unused dependencies
  --clean      Also autoremove and autoclean the APT cache
  --dry-run    Simulate a full-upgrade without changing packages
  --help       Show this help
  --version    Show version

This tool updates packages within the configured APT repositories.
It does not perform a Debian release upgrade or change APT sources.
HELP
}
mode=update
case "${1:-}" in
  '') ;;
  --remove) mode=remove ;;
  --clean) mode=clean ;;
  --dry-run) mode=dry ;;
  --help|-h) usage; exit 0 ;;
  --version) printf 'Up %s\n' "$VERSION"; exit 0 ;;
  *) usage >&2; die "Unknown option: $1" ;;
esac
[[ $# -le 1 ]] || die "Only one option is supported."
command -v apt-get >/dev/null || die "apt-get is required."
command -v dpkg-query >/dev/null || die "dpkg-query is required."
[[ -r /etc/os-release ]] || die "Cannot detect the operating system."
# shellcheck disable=SC1091
. /etc/os-release
case " ${ID:-} ${ID_LIKE:-} " in
  *' debian '*|*' ubuntu '*) ;;
  *) die "Only Debian and Ubuntu based systems are supported." ;;
esac
if (( EUID == 0 )); then
  runner=()
else
  command -v sudo >/dev/null || die "Run as root or install sudo."
  runner=(sudo)
fi
trap 'printf "%sUpdate failed at line %s.%s\n" "$red" "$LINENO" "$reset" >&2' ERR
printf '\n%sUp%s %s%s\n' "$bold" "$reset" "${PRETTY_NAME:-Linux}" "$reset"
info "Mode: $mode"
if [[ "$mode" == dry ]]; then
  info "Simulating full-upgrade (no changes)"
  "${runner[@]}" apt-get -s full-upgrade
  ok "Simulation finished"
  exit 0
fi
info "Refreshing package lists"
"${runner[@]}" apt-get update
info "Upgrading installed packages"
"${runner[@]}" apt-get full-upgrade
if [[ "$mode" == remove || "$mode" == clean ]]; then
  info "Removing unused dependencies"
  "${runner[@]}" apt-get autoremove
fi
if [[ "$mode" == clean ]]; then
  info "Cleaning obsolete cached packages"
  "${runner[@]}" apt-get autoclean
fi
if [[ -e /run/reboot-required ]]; then
  info "Reboot recommended"
fi
ok "Finished"
