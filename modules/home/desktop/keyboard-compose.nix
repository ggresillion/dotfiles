{ config, ... }:

{
  home.file.".XCompose".text = ''
    include "%L"

    <dead_acute> <c> : "ç" ccedilla
    <dead_acute> <C> : "Ç" Ccedilla
  '';

  home.sessionVariables = {
    XCOMPOSEFILE = "${config.home.homeDirectory}/.XCompose";
  };
}
