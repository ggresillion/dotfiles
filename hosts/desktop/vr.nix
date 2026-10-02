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
    autoStart = true;
    config = {
      enable = true;
      json."openvr-compat-path" = "${pkgs.xrizer-git}/lib/xrizer";
    };
  };

  environment.systemPackages = [
    pkgs.android-tools
    vrcd
  ];
}
