XDG_CONFIG_HOME ?= $(HOME)/.config

DIRS = fish git hypr niri nushell nvim wezterm zellij
FILES = starship
HOME_DIRS = aerospace zsh

all:
	for d in $(DIRS); do stow --target=$(XDG_CONFIG_HOME)/$$d $$d; done
	for d in $(FILES); do stow --target=$(XDG_CONFIG_HOME) $$d; done
	for d in $(HOME_DIRS); do stow --target=$(HOME) $$d; done

delete:
	for d in $(DIRS); do stow -D --target=$(XDG_CONFIG_HOME)/$$d $$d; done
	for d in $(FILES); do stow -D --target=$(XDG_CONFIG_HOME) $$d; done
	for d in $(HOME_DIRS); do stow -D --target=$(HOME) $$d; done
