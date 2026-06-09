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
      "felixkratz/formulae"
      "koekeishiya/formulae"
      "nikitabobko/tap"
      "netbirdio/tap"
      "oven-sh/bun"
      "kopecmaciej/vi-mongo"
      "ariga/tap"
      "anomalyco/tap"
      "tinted-theming/tinted"
      "stripe/stripe-cli"
    ];

    brews = [
      # AI / coding assistants
      "aider"
      "anomalyco/tap/opencode"

      # Cloud / infra
      "cloud-sql-proxy"
      "cloudflared"
      "opentofu"
      "terraform"
      "terraform-ls"
      "ariga/tap/atlas"
      "netbirdio/tap/netbird"

      # Databases
      "pgcli"
      "mongosh"
      "postgresql@14"
      "usql"
      "kopecmaciej/vi-mongo/vi-mongo"

      # Containers / orchestration
      "docker-compose"
      "lazydocker"
      "k9s"

      # JS / frontend
      "node"
      "pnpm"
      "oven-sh/bun/bun"
      "deno"
      "typescript"
      "typescript-language-server"
      "tailwindcss-language-server"
      "http-server"

      # LSPs / dev tools
      "lua-language-server"
      "stylua"
      "tree-sitter-cli"

      # Python
      "pyenv"
      "pipx"
      "python-lsp-server"
      "sqlfluff"

      # Rust
      "rustup"

      # macOS-specific utilities
      "autokbisw"
      "dark-notify"
      "switchaudio-osx"
      "koekeishiya/formulae/skhd"
      "koekeishiya/formulae/yabai"
      "felixkratz/formulae/borders"
      "tinted-theming/tinted/tinty"

      # Terminal / shell utils
      "autossh"
      "emacs"
      "entr"
      "fish"
      "graphviz"
      "htop"
      "httpie"
      "imagemagick"
      "lazyactions"
      "mailutils"
      "mkcert"
      "moreutils"
      "p7zip"
      "pastel"
      "plantuml"
      "scrcpy"
      "stow"
      "stripe/stripe-cli/stripe"
      "task"
      "tcptraceroute"
      "thefuck"
      "tmux"
      "tree"
      "vegeta"
      "wget"
      "wstunnel"

      # GitHub Actions
      "act"

      # Networking / proxy
      "hoverfly"

      # Auth
      "ory/tap/hydra"
      "ory/tap/kratos"

      # Misc
      "gobang"
      "osmium-tool"
      "swaks"
    ];

    casks = [
      # Security / auth
      "1password"
      "1password-cli"

      # Browsers
      "firefox"
      "floorp"
      "google-chrome"
      "zen"

      # Dev tools
      "bruno"
      "dbeaver-community"
      "dbgate"
      "docker-desktop"
      "elasticvue"
      "firecamp"
      "github"
      "gcloud-cli"
      "lm-studio"
      "mongodb-compass"
      "mitmproxy"
      "ngrok"
      "obsidian"
      "orbstack"
      "postman"
      "sequel-ace"
      "utm"
      "visual-studio-code"
      "wireshark-app"
      "zed"

      # Editors / IDEs
      "neovim-nightly"

      # Terminal
      "iterm2"
      "wezterm@nightly"

      # Productivity
      "alfred"
      "raycast"
      "ticktick"

      # Window management
      "aerospace"
      "amethyst"
      "hammerspoon"
      "omniwm"
      "swipeaerospace"

      # System utils
      "karabiner-elements"
      "stats"
      "unnaturalscrollwheels"
      "deskpad"

      # Media
      "deezer"
      "obs"
      "reaper"
      "spotify"
      "vlc"

      # Communication
      "chatgpt"
      "zoom"

      # Gaming
      "moonlight"
      "steam"

      # Remote / networking
      "barrier"
      "netbird-ui"
      "rustdesk"

      # Other
      "android-platform-tools"
      "citrix-workspace"
      "gimp"
      "inkscape"
      "licecap"
      "macdroid"
      "microsoft-auto-update"
      "qbittorrent"

      # Fonts (nerd fonts)
      "font-0xproto-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "font-meslo-lg-nerd-font"
      "font-symbols-only-nerd-font"
      "font-geist-mono-nerd-font"
      "font-monaspice-nerd-font"
      "font-commit-mono-nerd-font"
      "font-iosevka-nerd-font"
      "font-iosevka-term-nerd-font"
      "font-victor-mono-nerd-font"
    ];
  };
}
