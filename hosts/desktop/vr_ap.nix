{ config, pkgs, ... }:

{
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="FR"
  '';
  hardware.wirelessRegulatoryDatabase = true;

  networking.networkmanager.unmanaged = [ "wlp9s0" ];

  networking.interfaces.wlp9s0.ipv4.addresses = [
    {
      address = "10.66.0.1";
      prefixLength = 24;
    }
  ];

  services.hostapd = {
    enable = true;
    radios.wlp9s0 = {
      band = "5g";
      channel = 36;
      countryCode = "FR";
      wifi5 = {
        capabilities = [
          "HT40+"
          "SHORT-GI-80"
        ];
        operatingChannelWidth = "80";
      };
      networks.wlp9s0 = {
        ssid = "VR-Link";
        authentication = {
          mode = "wpa2-sha256";
          wpaPassword = "jafikiki";
        };
      };
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "wlp9s0";
      bind-interfaces = true;
      dhcp-range = [ "10.66.0.50,10.66.0.150,24h" ];
      dhcp-option = [
        "3,10.66.0.1"
        "6,10.66.0.1"
      ];
    };
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [ "wlp9s0" ];
    externalInterface = "enp10s0";
  };

  networking.firewall.trustedInterfaces = [ "wlp9s0" ];
}
