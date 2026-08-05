#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New WezTerm Window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️

# Reuses the already-running wezterm-gui process (fast, no cold-start
# font/GPU init) instead of `open -na WezTerm`, which always spawns a
# brand new process even when one is already running.
/opt/homebrew/bin/wezterm cli spawn --new-window 2>/dev/null || open -na WezTerm
