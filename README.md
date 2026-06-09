# My Dotfiles

Dotfile manager: [Chezmoi](https://www.chezmoi.io)  
Package manager: [Homebrew](https://brew.sh)  
Terminal: [iTerm2](http://iterm2.com)  
Editor: [Neovim](https://neovim.io)  
Prompt: [Starship](https://starship.rs)  

## Installation

Chezmoi one-liner:

```sh
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply chloeruka
```

Alternatively, install Chezmoi via [Homebrew](https://brew.sh):

```sh
brew install chezmoi
chezmoi init chloeruka --apply
```

## Useful commands

```sh
tmux new-session -A -s main
```

## Node and pnpm

The chain is `mise` → Node → corepack → `pnpm`. Standard pnpm-recommended
setup: there's no standalone `pnpm` binary — corepack (bundled with Node)
provides it.

| What                              | Path                                          |
| --------------------------------- | --------------------------------------------- |
| Node installs (mise)              | `~/.local/share/mise/installs/node/`          |
| `pnpm` / `corepack` shims         | `~/.local/share/mise/installs/node/<v>/bin/`  |
| `PNPM_HOME`                       | `~/.local/share/pnpm` (`$XDG_DATA_HOME/pnpm`) |
| Global CLIs (`pnpm i -g`)         | `~/.local/share/pnpm/bin/`                    |
| Package store (shared cache)      | `~/.local/share/pnpm/store/`                  |

`PNPM_HOME` and `$PNPM_HOME/bin` on PATH are set in `dot_config/zsh/dot_zshenv`.

**Don't run `pnpm setup`** — it rewrites `~/.zshrc`, but env lives in
`dot_config/zsh/dot_zshenv` here. If `pnpm bin -g` warns the bin dir isn't on
PATH, open a fresh shell rather than running setup.

