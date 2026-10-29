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
    # Start it with `systemctl --user start wivrn` before a VR session.
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

  environment.systemPackages = [
    pkgs.android-tools
    pkgs.wayvr
    vrcd
  ];
}
