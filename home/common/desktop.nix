{
  inputs,
  pkgs,
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
    settings = ./noctalia.json;
  };

  xdg.configFile."niri".source = ./config/niri/.config/niri;
}
