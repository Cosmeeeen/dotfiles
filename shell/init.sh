# init.sh — entry point sourced by ~/.bashrc and ~/.zshrc (see install.sh).
# Loads env, aliases, functions and the prompt. Interactive shells only.

case $- in *i*) ;; *) return 2>/dev/null || exit 0 ;; esac

: "${DOTFILES:=$HOME/.dotfiles}"

for _f in env aliases functions prompt; do
  [ -r "$DOTFILES/shell/$_f.sh" ] && . "$DOTFILES/shell/$_f.sh"
done
unset _f

# Login summary, once per shell tree. Disable with: export DOTFILES_NO_GREET=1
if [ -z "${DOTFILES_GREETED:-}" ] && [ -z "${DOTFILES_NO_GREET:-}" ] \
   && [ -t 1 ] && command -v fastfetch >/dev/null 2>&1; then
  export DOTFILES_GREETED=1
  fastfetch 2>/dev/null
fi
