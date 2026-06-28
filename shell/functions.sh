# functions.sh — small, portable helpers.

mkcd(){ mkdir -p -- "$1" && cd -- "$1"; }                       # make a dir and enter it
up(){ n="${1:-1}" p=""; while [ "$n" -gt 0 ]; do p="../$p"; n=$((n-1)); done; cd "$p" || return; }
bak(){ cp -a -- "$1" "$1.bak.$(date +%Y%m%d%H%M%S)" && echo "backed up -> $1.bak.*"; }
ducks(){ du -sh -- ${1:-*} 2>/dev/null | sort -rh | head -"${2:-15}"; }   # biggest items here

extract(){                                                       # extract any common archive
  [ -f "$1" ] || { echo "extract: '$1' not found"; return 1; }
  case "$1" in
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar)            tar xf  "$1" ;;
    *.gz)             gunzip  "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.zip)            unzip   "$1" ;;
    *.7z)             7z x    "$1" ;;
    *) echo "extract: unsupported archive: '$1'"; return 1 ;;
  esac
}
