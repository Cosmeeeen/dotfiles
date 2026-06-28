# prompt.sh — starship if installed, else a light, git-aware, cross-shell prompt.
# Shows: user@host (red as root) · cwd · git branch · status-colored prompt char.

if command -v starship >/dev/null 2>&1; then
  case "${ZSH_VERSION:+z}${BASH_VERSION:+b}" in
    z*) eval "$(starship init zsh)" ;;
    *b) eval "$(starship init bash)" ;;
  esac
  return 0 2>/dev/null || true
fi

__dot_branch(){ git rev-parse --abbrev-ref HEAD 2>/dev/null; }

if [ -n "${ZSH_VERSION:-}" ]; then
  setopt PROMPT_SUBST 2>/dev/null
  __dot_zbr(){ b=$(__dot_branch) && [ -n "$b" ] && printf ' [%s]' "$b"; }
  _dot_uc='%F{108}'; [ "$(id -u)" = 0 ] && _dot_uc='%F{167}'
  PROMPT="${_dot_uc}%n@%m%f %F{223}%~%f%F{245}\$(__dot_zbr)%f"$'\n'"%F{214}❯%f "
elif [ -n "${BASH_VERSION:-}" ]; then
  __dot_ps1(){
    local code=$?
    local rst='\[\e[0m\]' uc='\[\e[38;5;108m\]' cw='\[\e[38;5;223m\]' \
          gb='\[\e[38;5;245m\]' ac='\[\e[38;5;214m\]'
    [ "$(id -u)" = 0 ] && uc='\[\e[38;5;167m\]'
    [ "$code" -ne 0 ] && ac='\[\e[38;5;167m\]'
    local br; br=$(__dot_branch); [ -n "$br" ] && br=" [$br]"
    PS1="${uc}\u@\h${rst} ${cw}\w${rst}${gb}${br}${rst}\n${ac}❯${rst} "
  }
  case "${PROMPT_COMMAND:-}" in *__dot_ps1*) ;; *) PROMPT_COMMAND="__dot_ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}";; esac
fi
