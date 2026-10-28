{
  pkgs,
  config,
  ...
}:

let
  vrcd = pkgs.stdenv.mkDerivation {
    pname = "vr-cyberdeck";
    version = "1.8.3";

    src = pkgs.fetchurl {
      url = "https://github.com/DeliciousMeatPop/VRCD/releases/download/v1.8.3/vr-cyberdeck-1.8.3-x86_64.AppImage";
      hash = "sha256-iZKW9uffNlvXugBJe8mj9kxMz/g76KMjw8wHaFFl99c=";
    };
    dontUnpack = true;

    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.copyDesktopItems
      config.programs.appimage.package
    ];

    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/share/vr-cyberdeck.AppImage"
      makeWrapper ${config.programs.appimage.package}/bin/appimage-run \
        "$out/bin/vr-cyberdeck" \
        --add-flags "$out/share/vr-cyberdeck.AppImage"
      runHook postInstall
    '';

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "vr-cyberdeck";
        exec = "vr-cyberdeck";
        desktopName = "VR CyberDeck";
        genericName = "Quest sideloader";
        comment = "Sideload content to Meta Quest devices";
        categories = [ "Utility" ];
        startupNotify = true;
      })
    ];

    meta = with pkgs.lib; {
      description = "Cross-platform sideloader for Android and Meta Quest devices";
      homepage = "https://github.com/deliciousmeatpop/vrcd";
      license = licenses.agpl3;
      platforms = platforms.linux;
      mainProgram = "vr-cyberdeck";
    };
  };
in
{
  services.wivrn = {
    enable = true;
    openFirewall = true;
    package = pkgs.wivrn;
    # Off: a running server switches LACT to its VR profile (see gaming.nix).
    # Plugging the headset starts it (wivrn-usb below), or
    # `systemctl --user start wivrn` for wireless.
    autoStart = false;
    # CAP_SYS_NICE lets the compositor take a high-priority GPU queue, so
    # async reprojection keeps running while the game hitches.
    highPriority = true;
    # Sets PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES so Steam games see WiVRn
    # without per-game launch options.
    steam.importOXRRuntimes = true;
    config = {
      enable = true;
      json."openvr-compat-path" = "${pkgs.xrizer-git}/lib/xrizer";
    };
  };

  # Stable path for ~/.config/wivrn/config.json's "openvr-compat-path":
  # WiVRn prefers the user config over the -f one above, and falls back to
  # its bundled xrizer 0.5 when the key is missing there. Lives in $HOME, not
  # /etc: native games run in Steam's pressure-vessel container, which sees
  # $HOME and /nix/store but not the host's /etc.
  systemd.tmpfiles.rules = [
    "L+ /home/guillaume/.local/share/xrizer - - - - ${pkgs.xrizer-git}/lib/xrizer"
  ];

  # Wired WiVRn without the dashboard's "Connect via USB" click: plugging the
  # Quest 3 (2833:5013) starts a user service that tunnels the server port over
  # adb and opens the headset app on it.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="2833", ATTR{idProduct}=="5013", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="wivrn-usb.service"
  '';

  systemd.user.services.wivrn-usb = {
    description = "Connect a USB-plugged Quest to WiVRn";
    wants = [ "wivrn.service" ];
    after = [ "wivrn.service" ];
    path = [ pkgs.android-tools ];
    script = ''
      timeout 30 adb -d wait-for-device
      adb -d reverse tcp:9757 tcp:9757
      adb -d shell am start -a android.intent.action.VIEW \
        -d "wivrn+tcp://localhost:9757" org.meumeu.wivrn
    '';
    serviceConfig.Type = "oneshot";
  };

  environment.systemPackages = [
    pkgs.android-tools
    pkgs.wayvr
    vrcd
  ];
}
