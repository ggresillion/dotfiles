{ config, pkgs, ... }:

{
  # Boot
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Cache
  nix.binaryCaches = [ "https://cache.nixos.org/" ];
  nix.binaryCachePublicKeys = [ "nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];

  # Networking
  networking.hostName = "guillaume-desktop";
  networking.networkmanager.enable = true;

  # Time & Locale
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.guillaume = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # Niri
  programs.niri.enable = true;
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # DMS
  programs.dms-shell.enable = true;

  # Steam
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Basic packages
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
  ];

  system.stateVersion = "24.11";
}
