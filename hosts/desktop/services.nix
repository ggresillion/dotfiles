{ ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  services.prowlarr.enable = true;
  services.jackett.enable = true;

  # 16261-16262: Project Zomboid dedicated server
  networking.firewall.allowedUDPPorts = [
    16261
    16262
  ];
}
