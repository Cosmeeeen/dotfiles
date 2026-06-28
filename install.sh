#!/usr/bin/env bash
# Set up these dotfiles on a fresh Ubuntu or macOS box. Non-destructive & idempotent.
#   ./install.sh              install core tools, link configs, hook your shell
#   ./install.sh --no-install just link configs + hook shells (install nothing)
set -uo pipefail
DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

log(){ printf '\n\033[1;33m▸ %s\033[0m\n' "$1"; }
ok(){ printf '  \033[0;32m✓\033[0m %s\n' "$1"; }
warn(){ printf '  \033[0;31m!\033[0m %s\n' "$1"; }
short(){ printf '%s' "${1/#$HOME/~}"; }

install_fastfetch_linux(){
  command -v fastfetch >/dev/null 2>&1 && return 0
  sudo apt-get install -y -qq fastfetch >/dev/null 2>&1 && return 0
  # fallback: official .deb (apt has it only on 24.04+)
  local arch tmp; arch="$(dpkg --print-architecture 2>/dev/null || echo amd64)"
  # dpkg arch names differ from fastfetch's release asset names
  case "$arch" in arm64) arch=aarch64 ;; armhf) arch=armv7l ;; i386) arch=i686 ;; esac
  tmp="$(mktemp)"
  if curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${arch}.deb" -o "$tmp"; then
    sudo dpkg -i "$tmp" >/dev/null 2>&1 || sudo apt-get -f install -y -qq >/dev/null 2>&1
  fi
  rm -f "$tmp"
  command -v fastfetch >/dev/null 2>&1
}

# 1) packages
if [ "${1:-}" != "--no-install" ]; then
  log "Packages"
  if [ "$OS" = "Linux" ] && command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -qq >/dev/null 2>&1 || warn "apt update failed"
    for p in tmux htop git curl; do
      if dpkg -s "$p" >/dev/null 2>&1; then ok "$p"
      elif sudo apt-get install -y -qq "$p" >/dev/null 2>&1; then ok "$p"
      else warn "apt: $p"; fi
    done
    if install_fastfetch_linux; then ok "fastfetch"; else warn "fastfetch unavailable — login banner will be skipped"; fi
  elif [ "$OS" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
    for p in tmux htop git curl fastfetch; do
      if brew list "$p" >/dev/null 2>&1; then ok "$p"
      elif brew install "$p" >/dev/null 2>&1; then ok "$p"
      else warn "brew: $p"; fi
    done
  else
    warn "no apt/brew found — install manually: tmux htop git curl fastfetch"
  fi
else
  log "Skipping package install (--no-install)"
fi

# 2) link configs (symlinks; never overwrites real files in place)
log "Link configs"
mkdir -p "$HOME/.config/fastfetch" "$HOME/.config/tmux"
link(){
  [ -e "$2" ] && [ ! -L "$2" ] && { mv "$2" "$2.bak.$(date +%s)" && warn "backed up existing $(short "$2")"; }
  ln -sfn "$1" "$2" && ok "$(short "$2")"
}
link "$DOT/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
link "$DOT/fastfetch/cosmin.txt"   "$HOME/.config/fastfetch/cosmin.txt"
link "$DOT/tmux/tmux.conf"         "$HOME/.config/tmux/tmux.conf"
# old tmux (<3.1) only reads ~/.tmux.conf — add a shim if you don't already have one
[ -e "$HOME/.tmux.conf" ] || { printf 'source-file ~/.config/tmux/tmux.conf\n' > "$HOME/.tmux.conf" && ok "$(short "$HOME/.tmux.conf") (old-tmux shim)"; }

# 3) hook shell rc files — appends ONE guarded, idempotent block (nothing overwritten)
log "Hook shells"
B="# >>> dotfiles >>>"; E="# <<< dotfiles <<<"
hook(){
  local rc="$1"
  [ -e "$rc" ] || return 0
  if grep -qF "$B" "$rc" 2>/dev/null; then ok "$(short "$rc") already hooked"; return 0; fi
  { printf '\n%s\n' "$B"
    printf 'export DOTFILES=%q\n' "$DOT"
    # shellcheck disable=SC2016  # literal $DOTFILES is meant to expand later, in the user's shell
    printf '%s\n' '[ -r "$DOTFILES/shell/init.sh" ] && . "$DOTFILES/shell/init.sh"'
    printf '%s\n' "$E"
  } >> "$rc" && ok "hooked $(short "$rc")"
}
[ -e "$HOME/.bashrc" ] || touch "$HOME/.bashrc"
hook "$HOME/.bashrc"
hook "$HOME/.zshrc"

log "Done"
echo "Reload with:  exec \$SHELL -l   (or open a new terminal)"
echo "Silence the login banner with:  export DOTFILES_NO_GREET=1"
