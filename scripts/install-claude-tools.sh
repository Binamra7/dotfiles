#!/usr/bin/env bash
# =============================================================================
# install-claude-tools.sh
# -----------------------------------------------------------------------------
# Install & configure Claude Code token-optimization tools on a fresh machine.
# Idempotent and cross-distro (Arch + Debian/Ubuntu). Each tool is independent:
# a failure in one is reported and skipped, the rest continue.
#
# Tools:
#   rtk       - Rust Token Killer: CLI proxy that compresses command output.
#               https://github.com/rtk-ai/rtk
#   karpathy  - Claude Code plugin/skill: anti-over-engineering guidelines.
#               https://github.com/multica-ai/andrej-karpathy-skills
#   graphify  - Python CLI + skill + hook: code knowledge graph instead of grep.
#               https://github.com/safishamsi/graphify  (PyPI: graphifyy)
#
# Usage:
#   ./install-claude-tools.sh                 # install all tools
#   ./install-claude-tools.sh rtk graphify    # install only the named tools
#   ./install-claude-tools.sh --skip graphify # install all except the named
#   ./install-claude-tools.sh --list          # list available tools and exit
#   ./install-claude-tools.sh -h | --help
# =============================================================================

set -uo pipefail

ALL_TOOLS=(rtk karpathy graphify)

# ---------- pretty output ----------------------------------------------------
if [[ -t 1 ]]; then
  C_RESET=$'\e[0m'; C_BOLD=$'\e[1m'; C_BLUE=$'\e[34m'
  C_GREEN=$'\e[32m'; C_YELLOW=$'\e[33m'; C_RED=$'\e[31m'
else
  C_RESET=""; C_BOLD=""; C_BLUE=""; C_GREEN=""; C_YELLOW=""; C_RED=""
fi
announce() { printf "\n%s==> %s%s\n" "$C_BOLD$C_BLUE" "$1" "$C_RESET"; }
ok()       { printf "%s  ✓ %s%s\n" "$C_GREEN" "$1" "$C_RESET"; }
warn()     { printf "%s  ! %s%s\n" "$C_YELLOW" "$1" "$C_RESET"; }
err()      { printf "%s  ✗ %s%s\n" "$C_RED" "$1" "$C_RESET"; }
have()     { command -v "$1" >/dev/null 2>&1; }

# ---------- results tracking -------------------------------------------------
declare -A RESULT   # tool -> ok|fail|skip
mark() { RESULT["$1"]="$2"; }

# ---------- distro detection -------------------------------------------------
DISTRO="unknown"
if have pacman; then
  DISTRO="arch"
elif have apt-get; then
  DISTRO="debian"
fi

# pkg_install <pacman-name> <apt-name> : best-effort system package install.
pkg_install() {
  local arch_pkg="$1" deb_pkg="$2"
  case "$DISTRO" in
    arch)   sudo pacman -S --needed --noconfirm "$arch_pkg" ;;
    debian) sudo apt-get install -y "$deb_pkg" ;;
    *)      warn "Unknown distro — install '$arch_pkg'/'$deb_pkg' manually."; return 1 ;;
  esac
}

# ---------- PATH bootstrap ---------------------------------------------------
# rtk's install.sh and pipx both drop binaries in ~/.local/bin. Make sure it is
# on PATH for the rest of this run AND persisted for future shells (.zshrc here
# already does `typeset -U` so a duplicate export is harmless, but we only add
# one if nothing already puts ~/.local/bin on PATH).
LOCAL_BIN="$HOME/.local/bin"
ensure_local_bin_on_path() {
  mkdir -p "$LOCAL_BIN"
  case ":$PATH:" in
    *":$LOCAL_BIN:"*) ;;
    *) export PATH="$LOCAL_BIN:$PATH" ;;
  esac
}

# ---------- prerequisite helpers ---------------------------------------------
need_claude_cli() {
  if have claude; then return 0; fi
  warn "The 'claude' CLI is not on PATH — required for this tool."
  warn "Install Claude Code first, then re-run: $0 $1"
  return 1
}

ensure_pipx() {
  if have pipx; then return 0; fi
  announce "Installing pipx (prerequisite for Python tools)"
  if pkg_install python-pipx pipx; then
    :
  elif have python3; then
    warn "Falling back to 'python3 -m pip install --user pipx'."
    python3 -m pip install --user --break-system-packages pipx 2>/dev/null \
      || python3 -m pip install --user pipx
    python3 -m pipx ensurepath >/dev/null 2>&1 || true
  else
    err "No pipx and no python3 — cannot install Python-based tools."
    return 1
  fi
  have pipx
}

# =============================================================================
# Tool installers — each is idempotent and self-contained.
# =============================================================================

install_rtk() {
  announce "RTK (Rust Token Killer)"
  ensure_local_bin_on_path

  if have rtk && rtk gain >/dev/null 2>&1; then
    ok "rtk already installed ($(rtk --version 2>/dev/null | head -n1))"
  else
    if have rtk && ! rtk gain >/dev/null 2>&1; then
      warn "An 'rtk' on PATH does not support 'rtk gain' — likely the namesake"
      warn "(reachingforthejack/rtk). Reinstalling the token-killer over it."
    fi
    if have cargo; then
      # Prefer cargo when present (no curl|sh); falls through to script otherwise.
      cargo install --git https://github.com/rtk-ai/rtk || true
    fi
    if ! { have rtk && rtk gain >/dev/null 2>&1; }; then
      curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh \
        || { err "rtk install script failed"; mark rtk fail; return; }
    fi
    hash -r 2>/dev/null || true
  fi

  if ! { have rtk && rtk gain >/dev/null 2>&1; }; then
    err "rtk not usable after install (rtk gain failed)"; mark rtk fail; return
  fi

  # Configure the Claude Code PreToolUse hook non-interactively.
  if rtk init -g --auto-patch; then
    ok "rtk hook configured in ~/.claude/settings.json (restart Claude Code)"
    mark rtk ok
  else
    err "rtk installed but 'rtk init -g --auto-patch' failed"; mark rtk fail
  fi
}

# Generic Claude Code plugin install: <marketplace-repo> <plugin@marketplace>
install_cc_plugin() {
  local repo="$1" plugin_ref="$2"
  claude plugin marketplace add "$repo" 2>/dev/null \
    || warn "marketplace add '$repo' returned nonzero (may already be added)"
  claude plugin install "$plugin_ref"
}

install_karpathy() {
  announce "Karpathy guidelines (anti-over-engineering skill)"
  need_claude_cli karpathy || { mark karpathy skip; return; }
  if install_cc_plugin multica-ai/andrej-karpathy-skills \
       andrej-karpathy-skills@karpathy-skills; then
    ok "karpathy skills installed"
    mark karpathy ok
  else
    err "karpathy plugin install failed"; mark karpathy fail
  fi
}

install_graphify() {
  announce "Graphify (code knowledge graph)"
  ensure_pipx || { mark graphify fail; return; }
  ensure_local_bin_on_path

  if have graphify; then
    ok "graphify already installed; upgrading"
    pipx upgrade graphifyy >/dev/null 2>&1 || true
  else
    pipx install graphifyy || { err "pipx install graphifyy failed"; mark graphify fail; return; }
    hash -r 2>/dev/null || true
  fi
  have graphify || { err "graphify not on PATH after install"; mark graphify fail; return; }

  # Register the skill, then the always-on CLAUDE.md directive + PreToolUse hook.
  graphify install || warn "'graphify install' (skill registration) returned nonzero"
  if graphify claude install; then
    ok "graphify skill + Claude Code hook installed (use /graphify . to build a graph)"
    mark graphify ok
  else
    warn "'graphify claude install' failed — skill may still work standalone"
    mark graphify ok
  fi
}

# =============================================================================
# Argument parsing
# =============================================================================
usage() {
  sed -n '2,40p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

SELECTED=()
SKIP=()
mode="all"
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage 0 ;;
    --list) printf '%s\n' "${ALL_TOOLS[@]}"; exit 0 ;;
    --skip) mode="skip"; shift; SKIP+=("$1") ;;
    rtk|karpathy|graphify) mode="select"; SELECTED+=("$1") ;;
    *) err "Unknown argument: $1"; usage 2 ;;
  esac
  shift
done

# Resolve the final tool list.
TOOLS=()
case "$mode" in
  select) TOOLS=("${SELECTED[@]}") ;;
  skip)
    for t in "${ALL_TOOLS[@]}"; do
      skip=0
      for s in "${SKIP[@]}"; do [[ "$t" == "$s" ]] && skip=1; done
      (( skip )) || TOOLS+=("$t")
    done ;;
  all) TOOLS=("${ALL_TOOLS[@]}") ;;
esac

# =============================================================================
# Run
# =============================================================================
announce "Claude Code token-tools installer  (distro: $DISTRO)"
printf "Installing: %s\n" "${TOOLS[*]}"
[[ "$DISTRO" == "unknown" ]] && warn "Unrecognized distro — system-package steps will be skipped."

for t in "${TOOLS[@]}"; do
  case "$t" in
    rtk)      install_rtk ;;
    karpathy) install_karpathy ;;
    graphify) install_graphify ;;
  esac
done

# ---------- summary ----------------------------------------------------------
announce "Summary"
fail_count=0
for t in "${TOOLS[@]}"; do
  case "${RESULT[$t]:-fail}" in
    ok)   ok   "$t" ;;
    skip) warn "$t (skipped — see notes above)" ;;
    *)    err  "$t (failed)"; (( fail_count++ )) ;;
  esac
done

echo
warn "Restart Claude Code so newly added hooks/plugins load."
have rtk && warn "If 'rtk' isn't found in new shells, ensure ~/.local/bin is on PATH."

exit $(( fail_count > 0 ? 1 : 0 ))
