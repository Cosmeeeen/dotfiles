# aliases.sh — safe and predictable. Standard commands keep their behavior.

# color
if ls --color=auto >/dev/null 2>&1; then alias ls='ls --color=auto'; else alias ls='ls -G'; fi
alias grep='grep --color=auto' egrep='grep -E --color=auto' fgrep='grep -F --color=auto'

# listings (eza if present, else plain ls)
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -lh --group-directories-first --git' \
        la='eza -lah --group-directories-first --git' \
        lt='eza --tree --level=2'
else
  alias ll='ls -lh' la='ls -lAh'
fi
alias l='ls -CF'

# navigation
alias ..='cd ..' ...='cd ../..' ....='cd ../../..'

# friendlier defaults
alias df='df -h' du='du -h' mkdir='mkdir -p'
alias reload='exec $SHELL -l'
alias h='history' j='jobs -l'

# monitoring / sysadmin
alias psg='ps aux | grep -v grep | grep -i'
alias myip='curl -fsSL https://ifconfig.me && echo'
if [ "$(uname)" = "Linux" ]; then
  alias free='free -h' ports='ss -tulpn' diskinfo='df -hT -x tmpfs -x devtmpfs'
  alias localip="ip -4 -o addr show scope global 2>/dev/null | awk '{print \$2\": \"\$4}'"
else
  alias ports='lsof -nP -iTCP -sTCP:LISTEN' diskinfo='df -h'
  alias localip='ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1'
fi

# bat as a separate command if installed as batcat (Ubuntu); never override cat
command -v batcat >/dev/null 2>&1 && alias bat='batcat'
