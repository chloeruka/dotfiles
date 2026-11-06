# CLAUDE.md

Guidance for working in this repository.

## What this is

Ruka's personal **dotfiles**, managed by [chezmoi](https://www.chezmoi.io) on
**macOS only**. The source lives here; chezmoi renders and copies files into
`$HOME` (mostly `~/.config`) on `chezmoi apply`.

- Dotfile manager: chezmoi · Package manager: Homebrew · Terminal: iTerm2 / Ghostty
- Editor: Neovim (NvChad) · Prompt: Starship · Shell: zsh

## How chezmoi maps files (important)

Source filenames are **not** their applied names — chezmoi rewrites them:

| Source                          | Applied to                  |
| ------------------------------- | --------------------------- |
| `dot_config/`                   | `~/.config/`                |
| `dot_zshenv`                    | `~/.zshenv`                 |
| `dot_config/zsh/dot_zshrc`      | `~/.config/zsh/.zshrc`      |
| `*.tmpl`                        | rendered as a Go template   |
| `run_onchange_*.sh.tmpl`        | script run on content change|

So **edit files here in the source tree**, never the rendered copies in `$HOME`.
Changes only take effect after `chezmoi apply`. Preview with `chezmoi diff`.

`.chezmoiignore` lists files kept in the repo but **not** applied (`README.md`,
`CHEATSHEET.md`, `freshrc`).

## Package management

Packages are declared as **data**, not in the install script. To add/remove a
tool, edit `.chezmoidata/packages.yaml` (keys: `taps`, `brews`, `casks`) — the
`run_onchange_darwin-install-packages.sh.tmpl` template ranges over that data
and feeds a `brew bundle`. The script re-runs automatically when its rendered
content changes (i.e. when you edit the package list).

## Toolchain: mise → Node → corepack → pnpm

Runtimes are managed by `mise`, not Homebrew. The Node/pnpm chain is the
pnpm-recommended setup: **no standalone `pnpm` binary** — corepack (bundled with
Node) provides it.

| What                       | Path                                          |
| -------------------------- | --------------------------------------------- |
| Node installs (mise)       | `~/.local/share/mise/installs/node/`          |
| `pnpm`/`corepack` shims     | `~/.local/share/mise/installs/node/<v>/bin/`  |
| `PNPM_HOME`                | `~/.local/share/pnpm` (`$XDG_DATA_HOME/pnpm`) |
| Global CLIs (`pnpm i -g`)  | `~/.local/share/pnpm/bin/`                    |

`PNPM_HOME` + PATH live in `dot_config/zsh/dot_zshenv`. **Don't run `pnpm setup`**
— it rewrites `~/.zshrc`, but env is managed here in `dot_zshenv`.

## zsh layout

- `dot_zshenv` (repo root → `~/.zshenv`): bootstraps `XDG_*` and points
  `ZDOTDIR` at `~/.config/zsh`.
- `dot_config/zsh/dot_zshenv`: env vars (`PNPM_HOME`, PATH additions).
- `dot_config/zsh/dot_zshrc`: interactive shell — plugins, prompt, keybinds.
  Sets `JAVA_HOME=$(/usr/libexec/java_home -v 17)`.
- zsh plugins (zsh-vi-mode, autosuggestions, fzf-tab, zsh-nvm) are vendored via
  `.chezmoiexternal.toml` into `~/.local/share/zsh/plugins/`.

### ⚠️ zsh-vi-mode clobbers late keybinds

`zsh-vi-mode` reinitialises ZLE on a deferred `zvm_after_init` hook that fires
**after** `.zshrc` finishes — wiping any `bindkey` set during normal startup,
including atuin (`^R`), navi (`^G`), and fzf bindings. To add a keybind that
must survive vi-mode, append to the `zvm_after_init_commands` array instead of
calling `bindkey` directly:

```zsh
zvm_after_init_commands+=(
  'bindkey "^R" _atuin_search_widget'
  'bindkey "^G" _navi_widget'
)
```

(If atuin's up-arrow gets clobbered too, add `'bindkey "^[[A" _atuin_search_widget'`.)

## Neovim (NvChad)

Config lives in `dot_config/nvim/`, structured the NvChad way:

- `lua/configs/lspconfig.lua` — language servers via `vim.lsp.config` + `vim.lsp.enable`.
- `lua/configs/overrides.lua` — `M.mason.pkgs` (servers Mason auto-installs) and
  `M.treesitter.ensure_installed` (grammars). Add new tools here.
- `lua/plugins/init.lua` — lazy.nvim plugin specs.
- `ftplugin/<ft>.lua` — per-filetype setup (e.g. `java.lua` launches jdtls).

**Adding a normal language server:** add it to `mason.pkgs` (overrides.lua), the
grammar to `treesitter.ensure_installed`, then `vim.lsp.enable "<name>"` in
lspconfig.lua. Reuse NvChad's shared `on_attach`/`capabilities` from
`require("nvchad.configs.lspconfig")` so keymaps/completion stay consistent.

**Java is the exception:** jdtls is heavier and is driven by the `nvim-jdtls`
plugin + `ftplugin/java.lua` launcher (per-project workspaces) rather than the
plain `vim.lsp.enable` path. Needs a JDK on PATH — currently Temurin JDK 17 via
`JAVA_HOME` in `dot_config/zsh/dot_zshrc`.

## Lua style

`.stylua.toml` governs formatting (2-space indent, double quotes, call-without-
parens for single string/table args). `stylua` isn't always on PATH, but conform
formats Lua on save in nvim. Match surrounding style when editing.

## Workflow

1. Edit files in the **source tree** here.
2. `chezmoi diff` to preview, `chezmoi apply` to install.
3. For nvim changes, also restart nvim / re-open the relevant filetype so
   lazy.nvim and Mason pick up new plugins/servers.
