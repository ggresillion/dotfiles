{ pkgs, lib, ... }:

{
  programs.niri.enable = true;

  services.displayManager.defaultSession = lib.mkForce "niri";

  programs.noctalia-greeter = {
    enable = true;
    greeter-args = "--session niri";

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

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.lxqt.lxqt-policykit
  ];
}
