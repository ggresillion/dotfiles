{ pkgs, ... }:
{
  nixpkgs.config.rocmSupport = true;
  environment.systemPackages = [ pkgs.llama-cpp-rocm ];
}
