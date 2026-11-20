{ pkgs, ... }:

# Dual boot helpers: reboot into the UEFI setup or straight into Windows
# (also exposed as vicinae commands, see ./home.nix).
{
  environment.systemPackages = with pkgs; [
    efibootmgr

    (writeShellScriptBin "reboot-uefi" ''
      exec sudo -n systemctl reboot --firmware-setup
    '')

    (writeShellScriptBin "reboot-windows" ''
      set -e

      entry=$(sudo -n efibootmgr | awk '/Windows Boot Manager/ {
          sub(/^Boot/, "")
          sub(/\*.*/, "")
          print
      }')

      sudo -n efibootmgr --bootnext "$entry"
      sudo -n reboot
    '')
  ];

  # Passwordless only for the exact invocations reboot-uefi/reboot-windows
  # make. A bare `systemctl` or `efibootmgr` rule would be passwordless root
  # (e.g. `systemctl edit` spawns an editor as root).
  security.sudo.extraRules = [
    {
      users = [ "guillaume" ];
      commands =
        map
          (command: {
            inherit command;
            options = [ "NOPASSWD" ];
          })
          [
            # `""` = no arguments allowed
            ''/run/current-system/sw/bin/efibootmgr ""''
            "/run/current-system/sw/bin/efibootmgr --bootnext [0-9A-F][0-9A-F][0-9A-F][0-9A-F]"
            ''/run/current-system/sw/bin/reboot ""''
            "/run/current-system/sw/bin/systemctl reboot --firmware-setup"
          ];
    }
  ];
}
