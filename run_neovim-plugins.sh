#!/bin/bash
set -eou pipefail

echo "Installing neovim plugins..."
nvim --headless +'PlugInstall --sync' +qa
echo "Done!"

echo "Installing CoC extensions..."
nvim --headless +'CocInstall \
  coc-tsserver \
  coc-json \
  coc-snippets \
  coc-rust-analyzer' +qa
echo "Done!"
