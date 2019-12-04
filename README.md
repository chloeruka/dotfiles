# Dotfiles

## Dependencies
- iterm2 and a patched font

## Useful commands
`tmux new-session -A -s main`

## Installation
```sh
ln -s ~/dotfiles/config/zshrc ~/.zshrc
zsh
fresh
```

## nvim configuration
1. Run `:PlugInstall` to install vim-plug plugins
1. Add plugins as needed for languages:
```
:CocInstall coc-tsserver coc-json coc-snippets
```

## TODO
- homebrew brewfile
