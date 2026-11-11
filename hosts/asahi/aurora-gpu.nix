{
  config,
  lib,
  pkgs,
  ...
}:

# M3 GPU acceleration from the Aurora stack Omarchy ships on Macs, which
# upstream Asahi lacks so far. Pins match omacom/omarchy-pkgs on 2026-11-10
# (pkgbuilds/{linux-aurora,mesa-aurora,m1n1-aurora}); bump all three together.
let
  asahiPkgs = config.hardware.asahi.pkgs;
in
{
  # Asahi kernel plus Aurora's T8122 GPU and display bring-up.
  boot.kernelPackages = lib.mkForce (
    pkgs.linuxPackagesFor (
      (asahiPkgs.linux-asahi.override { _kernelPatches = config.boot.kernelPatches; }).kernel.override {
        buildLinux =
          args:
          pkgs.buildLinux (
            args
            // {
              pname = "linux-aurora";
              version = "7.2.11";
              modDirVersion = "7.2.11";
              src = pkgs.fetchFromGitHub {
                owner = "omacom";
                repo = "linux-aurora";
                rev = "bed544bdf93a496ebf70ba180923bab12b6e01cf";
                hash = "sha256-6dZqSVdiivUKWD2950iIHdi4rrhYfJQCkqqnMRQDwx0=";
              };
            }
          );
      }
    )
  );

  # m1n1 with the J504 display and GPU defaults: it only powers the GPU on
  # for Linux on the 25G83 system firmware it knows.
  boot.m1n1Package = asahiPkgs.m1n1.overrideAttrs (old: rec {
    version = "1.6.1.aurora23";
    src = pkgs.fetchFromGitHub {
      owner = "omacom";
      repo = "m1n1";
      rev = "ba130ffbeeadaa35215ed88b07ebcee3199d0be7";
      hash = "sha256-MDqdtFFP4Mo+aYYT51K2OcsAd93+6V1CIwciqfhHQXw=";
    };
    # Replace with the hash the first build reports.
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      name = "m1n1-${version}-vendor";
      hash = lib.fakeHash;
    };
  });

  # Defaults are built into m1n1 for the J504; uncomment to force or disable.
  # boot.m1n1ExtraOptions = ''
  #   chosen.asahi,t8122-dcp=1
  #   chosen.asahi,t8122-gpu=1
  #   chosen.asahi,t8122-gpu-power-standin=1
  #   chosen.asahi,t8122-gpu-fuse-leakage=1
  # '';

  # Mesa that knows the M3 GPU (gallium and vulkan asahi drivers).
  hardware.graphics = {
    enable = true;
    package = pkgs.mesa.overrideAttrs (old: {
      version = "26.3.0-devel-b7b03c5";
      src = pkgs.fetchFromGitHub {
        owner = "omacom";
        repo = "mesa";
        rev = "b7b03c5b3b8abe1e040d6056dc62c01b02d3639c";
        hash = "sha256-FQYLgZC16lx5YnI8V24MOZqDeZoA8RzqFsJR7f8QCPU=";
      };
    });
  };
}
