# env.sh — environment, history, locale, tool config. Sourced by bash & zsh.

# locale (only if the system left it unset)
[ -z "${LANG:-}" ] && export LANG=C.UTF-8

# editor / pager
if command -v nvim >/dev/null 2>&1; then export EDITOR=nvim
elif command -v vim >/dev/null 2>&1; then export EDITOR=vim
else export EDITOR=nano; fi
export VISUAL="$EDITOR" PAGER=less LESS="-R -i -M"

# colored man pages
export LESS_TERMCAP_md=$'\033[1;33m' LESS_TERMCAP_us=$'\033[4;36m' \
       LESS_TERMCAP_me=$'\033[0m'   LESS_TERMCAP_ue=$'\033[0m'

# PATH: prepend ~/.local/bin once
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH";; esac

# history
export HISTSIZE=50000
if [ -n "${ZSH_VERSION:-}" ]; then
  export HISTFILE="$HOME/.zsh_history" SAVEHIST=50000
  setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY APPEND_HISTORY 2>/dev/null
elif [ -n "${BASH_VERSION:-}" ]; then
  export HISTFILESIZE=50000 HISTCONTROL=ignoreboth HISTTIMEFORMAT='%F %T  '
  shopt -s histappend cmdhist checkwinsize 2>/dev/null
  shopt -s autocd cdspell dirspell globstar 2>/dev/null   # bash 4+; silently ignored on 3.2
  case "${PROMPT_COMMAND:-}" in
    *"history -a"*) ;;
    *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
  esac
fi

# tool env (only if present)
if command -v bat >/dev/null 2>&1 || command -v batcat >/dev/null 2>&1; then
  export BAT_THEME="gruvbox-dark"
fi
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border \
--color=fg:#ebdbb2,bg+:#3c3836,hl:#fabd2f,fg+:#ebdbb2,hl+:#fabd2f,prompt:#fe8019,pointer:#fe8019,info:#8ec07c,border:#504945"
fi
