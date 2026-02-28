all: 
	ln -sfn "$$HOME/dotfiles/dotfiles/nvim" "$$XDG_CONFIG_HOME/nvim"
	ln -sfn "$$HOME/dotfiles/dotfiles/zellij" "$$XDG_CONFIG_HOME/zellij"
	ln -sfn "$$HOME/dotfiles/dotfiles/nushell" "$$XDG_CONFIG_HOME/nushell"
	ln -sfn "$$HOME/dotfiles/dotfiles/starship/starship.toml" "$$XDG_CONFIG_HOME/starship.toml"
	ln -sfn "$$HOME/dotfiles/dotfiles/wezterm" "$$XDG_CONFIG_HOME/wezterm"
	ln -sfn "$$HOME/dotfiles/dotfiles/git" "$$XDG_CONFIG_HOME/git"

delete:
	@rm -rf "$$XDG_CONFIG_HOME/nvim"
	@rm -rf "$$XDG_CONFIG_HOME/zellij"
	@rm -rf "$$XDG_CONFIG_HOME/nushell"
	@rm -f  "$$XDG_CONFIG_HOME/starship.toml"
	@rm -rf "$$XDG_CONFIG_HOME/wezterm"
	@rm -rf "$$XDG_CONFIG_HOME/git"
