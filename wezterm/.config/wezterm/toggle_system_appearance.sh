#!/usr/bin/env bash

set -e -u -o pipefail

ZELLIJ_CONFIG_PATH="${HOME}/dotfiles/zellij/.config/zellij/config.kdl"
ZELLIJ_THEME_LIGHT="catppuccin-latte"
ZELLIJ_THEME_DARK="catppuccin-mocha"

STARSHIP_CONFIG_PATH="${HOME}/dotfiles/starship/.config/starship.toml"
STARSHIP_PALETTE_LIGHT="catppuccin_latte"
STARSHIP_PALETTE_DARK="catppuccin_mocha"

switch_zellij_theme() {
  local theme=$1
  if [[ $theme == "light" ]]; then
  
    # Set the light theme
    sed -i '' -E "s/^theme .*/theme \"$ZELLIJ_THEME_LIGHT\"/" "$ZELLIJ_CONFIG_PATH"
  elif [[ $theme == "dark" ]]; then
  
    # Set the dark theme
    sed -i '' -E "s/^theme .*/theme \"$ZELLIJ_THEME_DARK\"/" "$ZELLIJ_CONFIG_PATH"
  else
    echo "Error: Invalid theme '$theme'. Expected 'light' or 'dark'." >&2
    exit 1
  fi
}

switch_starship_palette() {
  local theme=$1
  if [[ $theme == "light" ]]; then
    sed -i '' -E "s/^palette = .*/palette = '$STARSHIP_PALETTE_LIGHT'/" "$STARSHIP_CONFIG_PATH"
  elif [[ $theme == "dark" ]]; then
    sed -i '' -E "s/^palette = .*/palette = '$STARSHIP_PALETTE_DARK'/" "$STARSHIP_CONFIG_PATH"
  else
    echo "Error: Invalid theme '$theme'. Expected 'light' or 'dark'." >&2
    exit 1
  fi
}


if [[ $# -eq 0 ]]; then
  echo "Error: Missing theme argument." >&2
  exit 1
fi

THEME="$1"
switch_zellij_theme "$THEME"
switch_starship_palette "$THEME"

