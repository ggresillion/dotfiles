{ pkgs, ... }:
let
  ethDevice = "enp10s0";
  wifiDevice = "wlp9s0";
  backupSsid = "Vroom Vroom le WiFi";

  # Ethernet is preferred (low metric) while it can reach the internet; when it
  # can't, its metric is bumped above Wi-Fi so traffic fails over to the phone hotspot.
  ethFailover = pkgs.writeShellApplication {
    name = "eth-failover";
    runtimeInputs = with pkgs; [
      iputils
      networkmanager
    ];
    text = ''
      state=good
      fails=0

      set_metric() {
        nmcli device modify ${ethDevice} ipv4.route-metric "$1" ipv6.route-metric "$1" >/dev/null || true
      }

      while true; do
        if [ "$(cat /sys/class/net/${ethDevice}/carrier 2>/dev/null)" = 1 ] &&
           { ping -q -c1 -W2 -I ${ethDevice} 1.1.1.1 >/dev/null 2>&1 ||
             ping -q -c1 -W2 -I ${ethDevice} 9.9.9.9 >/dev/null 2>&1; }; then
          fails=0
          if [ "$state" = bad ]; then
            echo "Ethernet back online, restoring priority"
            set_metric 100
            state=good
          fi
        else
          fails=$((fails + 1))
          if [ "$state" = good ] && [ "$fails" -ge 3 ]; then
            echo "Ethernet has no internet, failing over to Wi-Fi"
            set_metric 2000
            nmcli device connect ${wifiDevice} >/dev/null 2>&1 ||
              nmcli connection up id "${backupSsid}" >/dev/null 2>&1 || true
            state=bad
          fi
        fi
        sleep 5
      done
    '';
  };
in
{
  networking.firewall.allowedUDPPorts = [ 8211 ];

  systemd.services.eth-failover = {
    description = "Fail over from Ethernet to Wi-Fi when the ISP is down";
    after = [ "NetworkManager.service" ];
    requires = [ "NetworkManager.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${ethFailover}/bin/eth-failover";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
