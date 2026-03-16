{
  inputs,
  config,
  pkgs,
  flakeRoot,
  ...
}:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    wl-clipboard
    qt6.qttools
  ];

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = ./noctalia.json;
  };

  xdg.configFile."niri".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/common/config/niri/.config/niri";
}
