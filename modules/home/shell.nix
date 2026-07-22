{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      ripgrep
      fzf
      jq
      carapace
      starship
      zoxide
    ]
    ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
      inputs.nixwrap.packages.${pkgs.stdenv.hostPlatform.system}.wrap
    ];

  # Aliases
  home.shellAliases = {
    g = "git";
    d = "docker";
    dc = "docker compose";
    nrs = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos#(hostname)";
    nrt = "sudo nixos-rebuild test --flake ${config.home.homeDirectory}/nixos#(hostname)";
    nfu = "nix flake update --flake ${config.home.homeDirectory}/nixos";
    nd = "nix develop path:. --command $env.SHELL";
  };

  # Direnv
  programs.direnv = {
    enable = true;
    silent = true;
    # ponytail: custom mtime-cached hook in config/nushell/autoload/direnv.nu
    # already covers this; home-manager's default hook re-runs `direnv export`
    # on every single prompt with no caching.
    enableNushellIntegration = false;
    config = {
      global = {
        load_dotenv = true;
      };
    };
  };

  # Nushell
  programs.nushell.enable = true;
  xdg.configFile."nushell/autoload".source = ./config/nushell/autoload;

  # Starship
  xdg.configFile."starship.toml" = {
    source = ./config/starship/starship.toml;
    force = true;
  };

  # Zellij
  programs.zellij = {
    enable = true;
  };
  xdg.configFile."zellij".source = ./config/zellij;

  # Tmux
  xdg.configFile."tmux/which-key.yaml".source = ./config/tmux/which-key.yaml;

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [ tmux-which-key ];
    extraConfig = ''
      set -g @which-key-config "$HOME/.config/tmux/which-key.yaml"
      # ── Terminal ────────────────────────────────────────────────────────────
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      # ── General ─────────────────────────────────────────────────────────────
      set -sg escape-time 0
      set -g history-limit 50000
      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on
      set -g mouse on
      set -g focus-events on
      set -g mode-keys vi
      set -g set-clipboard on

      # ── Prefix ──────────────────────────────────────────────────────────────
      set -g prefix C-b
      bind C-b send-prefix

      # ── Pane navigation — smart-splits.nvim passthrough ─────────────────────
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind -n C-h if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
      bind -n C-j if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
      bind -n C-k if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
      bind -n C-l if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'
      bind -T copy-mode-vi C-h select-pane -L
      bind -T copy-mode-vi C-j select-pane -D
      bind -T copy-mode-vi C-k select-pane -U
      bind -T copy-mode-vi C-l select-pane -R

      # ── Splits ──────────────────────────────────────────────────────────────
      bind - split-window -v -c '#{pane_current_path}'
      bind | split-window -h -c '#{pane_current_path}'
      bind x kill-pane

      # ── Windows ─────────────────────────────────────────────────────────────
      bind c new-window -c '#{pane_current_path}'
      bind , command-prompt -I '#W' 'rename-window %%'
      bind p previous-window
      bind n next-window
      bind & kill-window

      # ── Resize ──────────────────────────────────────────────────────────────
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      bind z resize-pane -Z

      # ── Session ─────────────────────────────────────────────────────────────
      bind d detach-client
      bind $ command-prompt -I '#S' 'rename-session %%'

      # ── Copy mode ───────────────────────────────────────────────────────────
      bind [ copy-mode
      bind -T copy-mode-vi v     send-keys -X begin-selection
      bind -T copy-mode-vi y     send-keys -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send-keys -X cancel
      bind -T copy-mode-vi d     send-keys -X halfpage-down
      bind -T copy-mode-vi u     send-keys -X halfpage-up

      # ── Reload ──────────────────────────────────────────────────────────────
      bind r source-file ~/.config/tmux/tmux.conf \; display 'reloaded'

      # ── Alt+mode key tables (mirrors zellij Alt+t / Alt+p / Alt+n / Alt+s) ─
      # Alt+t → windows (zellij tab mode)
      bind -n M-t switch-client -T windows
      bind -T windows n new-window    -c '#{pane_current_path}'
      bind -T windows x kill-window
      bind -T windows r command-prompt -I '#W' 'rename-window %%'
      bind -T windows h previous-window
      bind -T windows k previous-window
      bind -T windows l next-window
      bind -T windows j next-window
      bind -T windows 1 select-window -t :1
      bind -T windows 2 select-window -t :2
      bind -T windows 3 select-window -t :3
      bind -T windows 4 select-window -t :4
      bind -T windows 5 select-window -t :5
      bind -T windows 6 select-window -t :6
      bind -T windows 7 select-window -t :7
      bind -T windows 8 select-window -t :8
      bind -T windows 9 select-window -t :9
      bind -T windows i swap-window -d -t -1
      bind -T windows o swap-window -d -t +1

      # Alt+p → panes (zellij pane mode)
      bind -n M-p switch-client -T panes
      bind -T panes d split-window -v -c '#{pane_current_path}'
      bind -T panes r split-window -h -c '#{pane_current_path}'
      bind -T panes x kill-pane
      bind -T panes f resize-pane -Z
      bind -T panes h select-pane -L
      bind -T panes j select-pane -D
      bind -T panes k select-pane -U
      bind -T panes l select-pane -R
      bind -T panes , command-prompt -I '#{pane_title}' 'select-pane -T %%'

      # Alt+n → resize (zellij resize mode)
      bind -n M-n switch-client -T resizing
      bind -T resizing h resize-pane -L 5
      bind -T resizing j resize-pane -D 5
      bind -T resizing k resize-pane -U 5
      bind -T resizing l resize-pane -R 5
      bind -T resizing H resize-pane -L 1
      bind -T resizing J resize-pane -D 1
      bind -T resizing K resize-pane -U 1
      bind -T resizing L resize-pane -R 1

      # Alt+s → scroll / copy mode (zellij scroll mode)
      bind -n M-s copy-mode

      # Alt+o → session (zellij session mode)
      bind -n M-o switch-client -T sessions
      bind -T sessions d detach-client
      bind -T sessions $ command-prompt -I '#S' 'rename-session %%'

      # ── Status bar — mirrors zellij zjstatus/ansi layout ────────────────────
      set -g status on
      set -g status-position bottom
      set -g status-style 'bg=colour0,fg=colour7'
      set -g status-interval 5

      set -g status-left '#{?client_prefix,#[bg=colour1\,fg=colour0\,bold] TMUX #[bg=colour0\,fg=colour1]█,#{?pane_in_mode,#[bg=colour3\,fg=colour0\,bold] SCROLL #[bg=colour0\,fg=colour3]█,#[bg=colour2\,fg=colour0\,bold] NORMAL #[bg=colour0\,fg=colour2]█}}'
      set -g status-left-length 20

      set -g status-right '#[fg=colour7] %H:%M  #[bg=colour0,fg=colour4]█#[bg=colour4,fg=colour8] #[bg=colour8,fg=colour4]█#[bg=colour8,fg=colour4] #S #[bg=colour0,fg=colour7]'
      set -g status-right-length 50

      set -g window-status-format         '#[bg=colour0,fg=colour4]█#[bg=colour4,fg=colour0]#I #[bg=colour8,fg=colour4] #W#[bg=colour0,fg=colour8]█'
      set -g window-status-current-format '#[bg=colour0,fg=colour3]█#[bg=colour3,fg=colour0]#I #[bg=colour8,fg=colour3] #W#[bg=colour0,fg=colour8]█'
      set -g window-status-separator      ' '

      set -g pane-border-style        'fg=colour8'
      set -g pane-active-border-style 'fg=colour4'
      set -g message-style            'bg=colour3,fg=colour0'
      set -g mode-style               'bg=colour3,fg=colour0'
    '';
  };

  # Git
  programs.git = {
    enable = true;
  };
  xdg.configFile."git/config".source = ./config/git/config;

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    extraPackages = with pkgs; [
      nodejs
      python3
      gcc
      tree-sitter
      nixd
      nixfmt
    ];
  };
  xdg.configFile = {
    "nvim/init.lua" = {
      source = ./config/nvim/init.lua;
      force = true;
    };
    "nvim/lua" = {
      source = ./config/nvim/lua;
      force = true;
    };
    "nvim/colors" = {
      source = ./config/nvim/colors;
      force = true;
    };
    "nvim/snippets" = {
      source = ./config/nvim/snippets;
      force = true;
    };
  };

  # WezTerm — package managed by homebrew on darwin
  programs.wezterm = pkgs.lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
  };
  xdg.configFile."wezterm/wezterm.lua" = {
    source = ./config/wezterm/wezterm.lua;
    force = true;
  };
}
