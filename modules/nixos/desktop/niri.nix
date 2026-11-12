{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  cfg = config.desktop;
in
{
  imports = [
    inputs.dux-greeter.nixosModules.default
    inputs.mango.nixosModules.mango
    ./niri-spicy.nix
  ];

  # Both shells and greeters are installed; these pick which one starts.
  # home-manager reads desktop.shell through osConfig.
  options.desktop = {
    shell = lib.mkOption {
      type = lib.types.enum [
        "noctalia"
        "dux"
      ];
      default = "noctalia";
      description = "Desktop shell started with niri.";
    };
    greeter = lib.mkOption {
      type = lib.types.enum [
        "noctalia"
        "dux"
      ];
      default = cfg.shell;
      defaultText = lib.literalExpression "config.desktop.shell";
      description = "greetd login greeter.";
    };
    lite = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Skip the source-built extras: the HDR sessions (mango, niri-spicy) and linux-wallpaperengine.";
    };
  };

  config = lib.mkMerge [
    {
      programs.niri.enable = true;

      services.displayManager.defaultSession = lib.mkForce "niri";

      # Second session ("Mango" in the greeter) for desktop HDR: niri has no
      # color management. HDR needs wlroots' Vulkan renderer, which must be
      # set before mango starts, hence the wrapper. Config: modules/home/desktop.nix
      programs.mango = {
        enable = !cfg.lite;
        package = inputs.mango.packages.${pkgs.stdenv.hostPlatform.system}.mango.overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];
          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/mango --set WLR_RENDERER vulkan
          '';
        });
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      # Prefer Wayland for electron-based apps (Vesktop, VSCode, etc.)
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };

      hardware.bluetooth.enable = true;
      hardware.xpadneo.enable = true;
      # Lets `qmk flash` reach keyboard bootloaders without sudo.
      hardware.keyboard.qmk.enable = true;

      services.udisks2.enable = true;

      environment.systemPackages = [
        pkgs.xwayland-satellite
        pkgs.lxqt.lxqt-policykit
        pkgs.udiskie
      ];
    }

    (lib.mkIf (cfg.greeter == "noctalia") {
      # Same command the upstream flake module used: the nixpkgs module doesn't
      # expose the session .desktop files via XDG_DATA_DIRS.
      services.greetd.settings.default_session.command =
        "${lib.getExe' pkgs.coreutils "env"} "
        + "XDG_DATA_DIRS=${config.services.displayManager.sessionData.desktops}/share "
        + "${lib.getExe' config.services.displayManager.noctalia-greeter.package "noctalia-greeter-session"} -- --session niri";

      services.displayManager.noctalia-greeter = {
        enable = true;

        settings = {
          session.default = "niri";
          user.default = "guillaume";

          appearance = {
            scheme = "Synced";
            theme_mode = "dark";
            password_style = "default";

            palette = {
              primary = "#89b4fa";
              on_primary = "#11111b";
              secondary = "#94e2d5";
              on_secondary = "#11111b";
              tertiary = "#f38ba8";
              on_tertiary = "#11111b";
              error = "#f38ba8";
              on_error = "#11111b";
              surface = "#1e1e2e";
              on_surface = "#cdd6f4";
              surface_variant = "#313244";
              on_surface_variant = "#a6adc8";
              outline = "#45475a";
              shadow = "#11111b";
              hover = "#89b4fa";
              on_hover = "#11111b";
            };
          };

          cursor = {
            theme = "Adwaita";
            size = 24;
          };

          keyboard = {
            layout = "us";
            variant = "intl";
          };

          idle.timeout = 300;
        };
      };
    })

    (lib.mkIf (cfg.greeter == "dux") {
      programs.dms-greeter = {
        enable = true;
        compositor.name = "niri";
        # Copies the Dux Shell theme and wallpaper into the greeter.
        configHome = config.users.users.guillaume.home;
      };
    })
  ];
}
