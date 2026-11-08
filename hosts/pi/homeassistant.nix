{ ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    # Logs go to journald (NixOS default), already capped in default.nix.
    daemon.settings.live-restore = true;
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      # Restore the backup into /var/lib/homeassistant before first start.
      homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        volumes = [
          "/var/lib/homeassistant:/config"
          "/etc/localtime:/etc/localtime:ro"
        ];
        extraOptions = [
          "--network=host"
          "--privileged"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8123 ];
}
