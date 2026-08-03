{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  # Determinate Nix manages the installation — disable nix-darwin's management
  nix.enable = false;

  system.primaryUser = "guillaume";

  networking.hostName = "macbook";
  networking.computerName = "Guillaume's MacBook Pro";

  # System-level packages (prefer home-manager for user packages)
  environment.systemPackages = with pkgs; [ ];

  users.users.guillaume = {
    name = "guillaume";
    home = "/Users/guillaume";
  };

  # ── macOS system defaults ──────────────────────────────────────────────────

  system.defaults = {
    spaces.spans-displays = false;

    dock = {
      autohide = true;
      tilesize = 47;
      orientation = "left";
      show-recents = false;
      magnification = false;
    };

    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv"; # list view
      AppleShowAllExtensions = true;
      NewWindowTarget = "Home";
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
      AppleShowScrollBars = "Automatic";
    };

    trackpad = {
      Clicking = false;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };

    screencapture.location = "~/Desktop";
  };

  # ── Homebrew ───────────────────────────────────────────────────────────────

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };
    global.brewfile = true;

    taps = [
      "nikitabobko/tap"
      "netbirdio/tap"
      "oven-sh/bun"
      "kopecmaciej/vi-mongo"
      "anomalyco/tap"
      "tinted-theming/tinted"
      "stripe/stripe-cli"
    ];

    brews = [
      # Cloud / infra
      "cloud-sql-proxy"
      "cloudflared"
      "opentofu"
      "netbirdio/tap/netbird"

      # Databases
      "pgcli"

      # Containers / orchestration
      "docker-compose"
      "lazydocker"
      "k9s"

      # Compilers
      "pnpm"
      "oven-sh/bun/bun"
      "rustup"

      # LSPs
      "lua-language-server"
      "typescript-language-server"
      "tailwindcss-language-server"
      "python-lsp-server"
      "stylua"
      "tree-sitter-cli"

      # macOS-specific utilities
      "tinted-theming/tinted/tinty"

      # Terminal / shell utils
      "htop"
      "p7zip"
      "stripe/stripe-cli/stripe"
    ];

    casks = [
      # Security / auth
      "1password"
      "1password-cli"

      # Browsers
      "chromium"
      "zen"

      # Dev tools
      "bruno"
      "dbeaver-community"
      "elasticvue"
      "github"
      "gcloud-cli"
      "mongodb-compass"
      "mitmproxy"
      "orbstack"

      # Editors / IDEs
      "neovim-nightly"

      # Terminal
      "wezterm"

      # Productivity
      "raycast"

      # Window management
      "omniwm"

      # System utils
      "stats"
      "unnaturalscrollwheels"
      "karabiner-elements"

      # Media
      "vlc"

      # Remote / networking
      "netbird-ui"

      # Other
      "android-platform-tools"

      # Fonts (nerd fonts)
      "font-jetbrains-mono-nerd-font"
   ];
  };
}
