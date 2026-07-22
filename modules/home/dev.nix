{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    go
    gcc
    delve
    github-cli
    lazygit
    gnumake
  ];
}
