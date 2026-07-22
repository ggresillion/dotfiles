{
  config,
  pkgs,
  ...
}:

{
  networking.hostName = "guillaume-laptop";

  # User
  users.users = {
    guillaume = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      hashedPassword = "$6$QApRfgdVjtrm1BwC$/6fJuQSpiMFDExYF5G66nbL72/LqZvtHn.ThWKwt2AbmxxUyezr/nhMEsMymteyyvCdnYDI8lSlrfJ6X8Un7u.";
      shell = "${pkgs.nushell}/bin/nu";
    };
  };

  # Laptop battery management
  services.power-profiles-daemon.enable = true;

  hardware.graphics.enable = true;

  # Basic packages
  environment.systemPackages = with pkgs; [
    git
    sbctl
    wget
    vim
  ];

  system.stateVersion = "26.05";
}
