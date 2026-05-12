# 💙🐕 ruka's cheatsheet

A friendly reference for the keybinds, aliases, and helpers configured in this
chezmoi repo. Open it any time with `cheat` from your shell.

---

## 🐚 Shell (zsh)

### Magic keybinds

| Key           | Tool    | Description                               |
| ------------- | ------- | ----------------------------------------- |
| `Ctrl+R`      | atuin   | fuzzy shell history (synced across panes) |
| `Ctrl+G`      | navi    | interactive cheatsheet picker             |
| `Ctrl+T`      | fzf     | fuzzy file picker                         |
| `Alt+C`       | fzf     | fuzzy `cd` into subdirectory              |
| `Ctrl+R` (vi) | atuin   | survives zsh-vi-mode reinit               |
| `Tab`         | fzf-tab | fuzzy completion                          |

> Note: any new keybind that needs to survive `zsh-vi-mode` must be appended to
> `zvm_after_init_commands` in `dot_config/zsh/dot_zshrc`, not bound directly.

### Aliases

| Alias    | Expands to                                              |
| -------- | ------------------------------------------------------- |
| `reload` | `exec zsh` — restart the shell in place                 |
| `fuck`   | `sudo $(fc -ln -1)` — re-run last command with sudo     |
| `pulumi` | `op plugin run -- pulumi` — pulumi via 1Password plugin |
| `jjbb`   | Jenkins Job Builder Builder via docker                  |
| `cheat`  | open this cheatsheet                                    |

### Custom functions

| Function                     | What it does                                         |
| ---------------------------- | ---------------------------------------------------- |
| `z <pattern>`                | zoxide — jump to frecent dir matching pattern        |
| `git-prune`                  | switch to main, pull, delete locally-merged branches |
| `code <file-or-folder>`      | open in VSCode (sets `VSCODE_CWD`)                   |
| `timezsh`                    | benchmark zsh startup over 10 runs                   |
| `video-url-from-tweet <url>` | extract video URL from tweet                         |
| `video-from-tweet <url>`     | download video from tweet                            |
| `video-to-gif <in> <out>`    | convert video → gif via ffmpeg                       |
| `gif-from-tweet <url> <out>` | download tweet video and convert to gif              |

---

## 🌿 Neovim

**Leader key:** `<Space>` (set in `dot_config/nvim/init.lua`)

### Custom maps (from `lua/mappings.lua`)

| Mode | Key  | Action                   |
| ---- | ---- | ------------------------ |
| n    | `;`  | enter command mode (`:`) |
| i    | `jk` | escape to normal mode    |

### Splits

| Mode  | Key                       | Action                           |
| ----- | ------------------------- | -------------------------------- |
| n / t | `<C-h>`                   | toggle horizontal terminal split |
| n / t | `<C-i>`                   | toggle floating terminal         |
| n     | `<A-h/j/k/l>`             | move cursor between splits       |
| n     | `<A-\>`                   | move to previous split           |
| n     | `<C-h/j/k/l>`             | resize current split             |
| n     | `<leader><leader>h/j/k/l` | swap buffer with neighbour split |

NvChad's defaults (telescope, LSP, etc.) are still active — the maps above are
on top of those.

### Neovim Recipes

| Command                          | Action                                                            |
| -------------------------------- | ----------------------------------------------------------------- |
| `:g/<pattern>/d`                 | (Global) delete lines matching `<pattern>`                        |
| `:%s/<pattern>/<replacement>/gc` | (Substitute Global) lines matching `<pattern>`, with confirmation |

---

## 🪟 tmux

**Prefix:** `Ctrl+a` (the prefix-as-prefix chord is also `Ctrl+a Ctrl+a` to
cycle to the next pane).

### Window / pane

| Key             | Action                                     |
| --------------- | ------------------------------------------ |
| `prefix r`      | reload `tmux.conf` (with sparkly toast ✨) |
| `prefix \|`     | split pane horizontally (keeps cwd)        |
| `prefix -`      | split pane vertically (keeps cwd)          |
| `prefix c`      | new window (keeps cwd)                     |
| `prefix Ctrl+a` | cycle to next pane                         |
| `prefix v`      | send literal prefix to inner program       |
| `Shift+Left`    | previous window                            |
| `Shift+Right`   | next window                                |

### Sessions / pickers

| Key        | Action                                            |
| ---------- | ------------------------------------------------- |
| `prefix o` | sessionx — fuzzy picker for windows + zoxide dirs |

### Plugins active

- tmux-tilish (smart-splits.nvim integration)
- tmux-resurrect (session restore, `nvim` sessions captured)
- tmux-continuum (autosave + boot)
- tmux-sessionx (the `prefix o` picker)

---

## 🍎 Ghostty

| Key       | Action                                          |
| --------- | ----------------------------------------------- |
| `⌥+Space` | global toggle — summon/dismiss Ghostty anywhere |
| `⌘+1..9`  | jump to tmux window N (sends `Ctrl+a <N>`)      |
| `⌘+t`     | new tmux window (sends `Ctrl+a c`)              |
| `⌘+r`     | rename tmux window (sends `Ctrl+a ,`)           |
| `⌘+w`     | close tmux window (sends `Ctrl+a &`)            |

Plus: focus-follows-mouse is on, copy-on-select goes to system clipboard, left
option is treated as Alt.

---

## ⚙️ Chezmoi

The repo lives at `~/.local/share/chezmoi/` (this directory).

| Command               | Does                                                 |
| --------------------- | ---------------------------------------------------- |
| `chezmoi cd`          | jump into the source repo                            |
| `chezmoi edit <file>` | edit the source-state version of a dotfile           |
| `chezmoi diff`        | preview what would change in `$HOME`                 |
| `chezmoi apply`       | sync source → `$HOME`                                |
| `chezmoi status`      | see which targets are out of date                    |
| `chezmoi update`      | pull from remote and re-apply                        |
| `chezmoi re-add <f>`  | pull a manual edit from `$HOME` back into the source |

---

## 🌸 XDG layout reminders

- `XDG_CONFIG_HOME` → `~/.config`
- `XDG_DATA_HOME` → `~/.local/share`
- `XDG_CACHE_HOME` → `~/.cache`
- `ZDOTDIR` → `~/.config/zsh` (so `.zshrc` lives there, not in `$HOME`)
- The root `~/.zshenv` only exists to bootstrap XDG vars and re-source
  `$ZDOTDIR/.zshenv` — real env config lives in `dot_config/zsh/dot_zshenv`.
