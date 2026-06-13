#!/usr/bin/env bash
# ------------------------------------------------------------
# Arch "Spring-Clean" Maintenance Script
# (interactive, abort-safe, log-to-file)
# ------------------------------------------------------------
#  • Designed for periodic housekeeping (monthly-ish)
#  • Optionally run with --upgrade to include a full system upgrade.
#  • Run with --yes for an unattended pass (e.g. from cron/systemd timer).
#  • Automatically detects **paru** or **yay** and uses whichever is found.
#  • Requires: pacman-contrib (paccache), pacdiff, plus the detected AUR helper.
# ------------------------------------------------------------

set -uo pipefail
trap 'echo "[!] Aborted"; exit 130' INT TERM

# ---------- Config ---------------------------------------------------------
LOG_DIR="$HOME/.local/var/log"
PACCACHE_RETAIN=2   # keep N package versions
CACHE_DAYS=30       # prune ~/.cache entries older than N days
JOURNAL_RETAIN="7d" # e.g. 500M or 7d
# --------------------------------------------------------------------------

# ---------- CLI switches ---------------------------------------------------
DO_UPGRADE=false
ASSUME_YES=false
while [[ $# -gt 0 ]]; do
  case $1 in
  -u | --upgrade) DO_UPGRADE=true ;;
  -y | --yes) ASSUME_YES=true ;;
  -h | --help)
    echo "Usage: $0 [--upgrade] [--yes]"
    echo "  -u, --upgrade  also run a full system upgrade (paru/yay -Syu)"
    echo "  -y, --yes      assume yes to every prompt (unattended)"
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    exit 2
    ;;
  esac
  shift
done

# ---------- Detect AUR helper ---------------------------------------------
if command -v paru &>/dev/null; then
  AUR=paru
elif command -v yay &>/dev/null; then
  AUR=yay
else
  echo "Error: neither paru nor yay found in PATH." >&2
  exit 1
fi

# ---------- Logging --------------------------------------------------------
# Detect the terminal *before* the tee redirect makes stdout a pipe, so colour
# goes to the screen but never into the log file.
if [[ -t 1 ]]; then
  C_HEAD=$'\e[1;34m'
  C_RST=$'\e[0m'
else
  C_HEAD=""
  C_RST=""
fi

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/spring-clean-$(date +%F_%H-%M-%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

# ---------- Helpers --------------------------------------------------------
announce() { printf "\n%s==> %s%s\n" "$C_HEAD" "$1" "$C_RST"; }

confirm() {
  $ASSUME_YES && return 0
  local ans
  read -r -p "${1:-Are you sure?} [y/N] " ans
  [[ "$ans" =~ ^([yY][eE][sS]|[yY])$ ]]
}

# Human-readable size of a path (empty string if it doesn't exist).
size_of() { du -sh "$1" 2>/dev/null | cut -f1; }

announce "Arch Spring-Clean starting $(date) — using $AUR"

# ---------- 1. Optional system upgrade ------------------------------------
if $DO_UPGRADE; then
  announce "System upgrade ($AUR)"
  $AUR -Syu --ask 4 # interactive for .pacnew merges
  echo "Run 'sudo pacdiff' after the script to merge new config files."
fi

# ---------- 2. Pacman cache trim ------------------------------------------
announce "Pacman cache trim (keeping latest $PACCACHE_RETAIN)"
echo "Current cache: $(size_of /var/cache/pacman/pkg)"
if confirm "Clean pacman cache now?"; then
  sudo paccache -vrk"$PACCACHE_RETAIN" # trim installed pkgs to N versions
  sudo paccache -ruk0                  # drop all uninstalled pkgs
  echo "Cache after trim: $(size_of /var/cache/pacman/pkg)"
fi

# ---------- 3. Orphaned packages ------------------------------------------
announce "Removing orphaned packages"
mapfile -t ORPHANS < <($AUR -Qtdq)
if ((${#ORPHANS[@]})); then
  printf "Found %d orphan(s):\n%s\n" "${#ORPHANS[@]}" "${ORPHANS[*]}"
  if confirm "Remove these?"; then
    sudo pacman -Rns "${ORPHANS[@]}"
  fi
else
  echo "No orphans detected."
fi

# ---------- 4. $HOME/.cache prune ----------------------------------------
announce "Pruning ~/.cache (unused > $CACHE_DAYS days)"
echo "Before: $(size_of ~/.cache)"
if confirm "Clean ~/.cache now?"; then
  find ~/.cache -type f -mtime +"$CACHE_DAYS" -print -delete
  find ~/.cache -type d -empty -print -delete
  echo "After: $(size_of ~/.cache)"
fi

# ---------- 5. Journald rotate & vacuum ----------------------------------
announce "Vacuuming journald logs ($JOURNAL_RETAIN)"
echo "Before: $(journalctl --disk-usage | awk '{print $NF}')"
if confirm "Rotate & vacuum journald now?"; then
  sudo journalctl --rotate
  sudo journalctl --vacuum-time="$JOURNAL_RETAIN"
  echo "After: $(journalctl --disk-usage | awk '{print $NF}')"
fi

# ---------- 6. Failed systemd units --------------------------------------
announce "Scanning for failed systemd services"
failed=$(systemctl list-units --failed --no-legend --plain)
if [[ -z "$failed" ]]; then
  echo "No failed units detected."
else
  echo "$failed"
fi

announce "Spring-Clean finished in ${SECONDS}s — log saved to $LOG_FILE"
