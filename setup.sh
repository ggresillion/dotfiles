#!/bin/bash

echo "creating dotfiles symlinks"

ln -s $(pwd)/dot_config/nvim ~/.config/nvim
ln -s $(pwd)/dot_config/fish ~/.config/fish
ln -s $(pwd)/dot_tmux.conf ~/.tmux.conf

echo "done"
