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

