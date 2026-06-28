# dotfiles

Minimal, cross-platform shell setup for **Ubuntu & macOS** servers and workstations.
Lightweight, dependency-tolerant, and pleasant for *anyone* who lands on the box — no
exotic keybindings, standard commands left untouched.

## Install

```sh
git clone <repo-url> ~/projects/dotfiles && cd ~/projects/dotfiles
./install.sh                 # install core tools, link configs, hook your shell
# or: ./install.sh --no-install   (link + hook only, install nothing)
exec $SHELL -l               # reload
```

**Non-destructive:** it appends one guarded block to `~/.bashrc` / `~/.zshrc` and symlinks
the configs into `~/.config` (any real file it would replace is backed up to `*.bak.*`
first). To remove, delete the `>>> dotfiles >>>` block, the symlinks under
`~/.config`, and the `~/.tmux.conf` shim.

## What you get

- **Shell** (bash + zsh, shared): big shared history, colored output, safe aliases, and
  helpers (`mkcd`, `extract`, `ports`, `myip`, `ducks`, `up`, `bak`, `psg` …). Git-aware
  prompt showing `user@host` (red as root) · cwd · branch. Uses **starship** automatically
  if installed, otherwise a zero-dependency fallback.
- **fastfetch**: clean login summary — os · kernel · uptime · cpu · load · mem · swap ·
  disk · ip · users · procs — with an ASCII logo. Plain-text keys + ASCII meters,
  so it renders on any terminal (**no Nerd Font required**).
- **tmux**: mouse on, truecolor, 50k history, gruvbox-tinted status, `|` / `-` splits that
  keep your cwd. Standard `C-b` prefix kept so it's familiar to others.

Everything **degrades gracefully** — missing tools are skipped, never errors.

## Notes

- Login banner shows once per shell tree. Disable: `export DOTFILES_NO_GREET=1`.
- Assumes a UTF-8, 256-color terminal (any modern SSH client).
- On Ubuntu < 24.04, `install.sh` grabs fastfetch from its official `.deb` release.

## License

[GPL-3.0](LICENSE) © 2026 Cosmin Ilie.
