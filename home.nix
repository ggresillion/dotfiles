{ config, pkgs, ... }:

{
  imports = [
    ./zellij
  ];
  home.username = "guillaume";
  home.homeDirectory = "/Users/guillaume";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;

    functions.rebuild =
      if pkgs.stdenv.isDarwin then
        ''
          sudo darwin-rebuild switch --flake ~/dotfiles
        ''
      else
        ''
          sudo nixos-rebuild switch --flake ~/dotfiles
        '';

    shellAliases = {
      cd = "z";
      ls = "ls --color=auto";
      ll = "ls -lh";
      la = "ls -la";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      g = "git";
      ga = "git add";
      gc = "git commit";
      gca = "git commit -a";
      gcm = "git commit -m";
      gs = "git status";
      gl = "git pull";
      gp = "git push";
      gb = "git branch";
      gd = "git diff";
      gco = "git checkout";
      d = "docker";
      dc = "docker compose";
      dcb = "docker compose build";
      dcu = "docker compose up";
      dcd = "docker compose down";
      dcl = "docker compose logs -f";
      dps = "docker ps";
      dpa = "docker ps -a";
      di = "docker images";
      drmi = "docker rmi";
      drm = "docker rm";
      dstop = "docker stop";
      dstart = "docker start";
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";
      kga = "kubectl get all";
      kctx = "kubectl config current-context";
      kns = "kubectl config set-context --current --namespace";
      nr = "nix run";
      nb = "nix build";
      ns = "nix shell";
      nf = "nix flake";
      nfu = "nix flake update";
      hms = "home-manager switch --flake ~/dotfiles";
      hmg = "home-manager generations";
      hmr = "home-manager rollback";
      c = "clear";
      e = "$EDITOR";
      please = "sudo";
      lg = "lazygit";
    };

    shellInit = ''
      set -g fish_greeting ""

      # Load direnv
      direnv hook fish | source

      # Load zoxide
      zoxide init fish | source

      # Load starship prompt
      starship init fish | source
    '';
  };

  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "you@example.com";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      gcc
      nil
      stylua
      nixfmt-rfc-style
    ];
  };

  xdg.configFile."nvim" = {
    source = ./nvim/.config/nvim;
    recursive = true;
  };

  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (
      builtins.readFile (
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/starship/starship/refs/heads/master/docs/public/presets/toml/catppuccin-powerline.toml";
          sha256 = "0j4jp769nqjcrzr3wjwahmzg5a5mxg2asy5vsh6l7y95258pwpr1";
        }
      )
    );
  };

  programs.zoxide.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bat.enable = true;
  programs.gh.enable = true;
}
