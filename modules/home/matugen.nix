{
  config,
  lib,
  ...
}:

# Matugen templates for apps the shell has no built-in template for. dms runs
# them on every palette change. They overwrite the files noctalia renders, so
# the apps' own theme settings work under either shell.
let
  cfg = config.matugen;
  templates = "${config.xdg.configHome}/matugen/templates";
  inherit (config.xdg) configHome cacheHome dataHome;

  section =
    name: t:
    "\n[templates.${name}]\n"
    + lib.concatStrings (lib.mapAttrsToList (k: v: "${k} = ${builtins.toJSON v}\n") t);
in
{
  options.matugen.templates = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
    default = { };
    description = "Entries of matugen's [templates] table (input_path, output_path, post_hook).";
  };

  config = lib.mkIf config.profiles.desktop.enable {
    matugen.templates = {
      btop = {
        input_path = "${templates}/btop.theme";
        output_path = "${configHome}/btop/themes/noctalia.theme";
      };
      qt6ct = {
        input_path = "${templates}/qtct.conf";
        output_path = "${configHome}/qt6ct/colors/noctalia.conf";
      };
      steam = {
        input_path = "${templates}/steam.css";
        output_path = "${dataHome}/Steam/steamui/skins/Material-Theme/css/main/colors/matugen.css";
      };
      vesktop = {
        input_path = "${templates}/vesktop-material.css";
        output_path = "${configHome}/vesktop/themes/noctalia-material.theme.css";
      };
      vicinae = {
        input_path = "${templates}/vicinae.toml";
        output_path = "${dataHome}/vicinae/themes/noctalia.toml";
        post_hook = "vicinae theme set noctalia";
      };
      yazi = {
        input_path = "${templates}/yazi.toml";
        output_path = "${configHome}/yazi/flavors/noctalia.yazi/flavor.toml";
      };
      yazi-syntax = {
        input_path = "${templates}/yazi.tmTheme";
        output_path = "${configHome}/yazi/flavors/noctalia.yazi/tmtheme.xml";
      };
      # Imported by each Zen profile's userChrome.css/userContent.css.
      zen-chrome = {
        input_path = "${templates}/zen-userChrome.css";
        output_path = "${cacheHome}/noctalia/zen-browser/zen-userChrome.css";
      };
      zen-content = {
        input_path = "${templates}/zen-userContent.css";
        output_path = "${cacheHome}/noctalia/zen-browser/zen-userContent.css";
      };
    };

    xdg.configFile = {
      "matugen/templates".source = ./config/matugen/templates;
      # dms only merges what follows the exact "[templates]" line.
      "matugen/config.toml".text =
        "[config]\n\n[templates]\n" + lib.concatStrings (lib.mapAttrsToList section cfg.templates);
    };
  };
}
