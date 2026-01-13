{ config, pkgs, ... }:

{
  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";
  home.stateVersion = "24.11";

  # Basic packages
  home.packages = with pkgs; [
    wl-clipboard
    firefox
  ];

  # Neovim - basic setup
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # WezTerm - minimal config
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        font_size = 12.0,
        color_scheme = 'Catppuccin Mocha',
      }
    '';
  };

  # Zellij - minimal config
  programs.zellij = {
    enable = true;
  };

  # Git
  programs.git = {
    enable = true;
    userName = "Guillaume Grésillion";
    userEmail = "guillaume.gresillion@gmail.com";
  };

  # Niri config
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb { layout "us" }
        }
    }

    output "DP-1" {
        mode "5120x1440@240"
    }

    layout {
        gaps 8
    }

    binds {
        Mod+Return { spawn "wezterm"; }
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }
        
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
    }
  '';

  programs.home-manager.enable = true;
}
