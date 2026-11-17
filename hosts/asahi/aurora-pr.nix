# nixos-aurora with J504 (14" M3 MacBook Pro) display and GPU support from
# open PRs, until they merge and reach channel-testing:
#   kernel: aurora-silicon/linux#2147 (stacked on #2146)
#   aura:   aurora-silicon/aura#290, plus aura#233 (applied in default.nix):
#           without it every M3 boot-loops in aura (the boot core's RVBAR
#           store takes an SError, aura#231).
# Everything else (Mesa, firmware, services) stays on Aurora's pins and cache;
# only the kernel and aura build locally. Drop this file once the channel
# carries them, and import inputs.aurora directly again.
{ pkgs, src }:

let
  kernel = {
    commit = "98897fac88abbc9b382d22ea7764adb5bfe94b4d";
    version = "7.3.0";
    sha256 = "bc1e82690269dbbee274f874636b6b4bb4829c633cb8dfc6cd199d188768b4f1";
    nix_hash = "sha256-vB6CaQJp277idPh0Y2trS7SCnGM8uN/GzRmdGIdotPE=";
  };
  aura = {
    commit = "ac26eb8a57c9472742bfdfb081023fcbb09c8b0f";
    sha256 = "75567db4f59235ed40dbdb588276f336dd8a90e4de62e6830cc2c5f7c4bfb700";
    nix_hash = "sha256-dVZ9tPWSNe1A29tYgnbzNt2KkOTeYuaDDMLF98S/twA=";
  };
  auraSrc = pkgs.fetchurl {
    name = "aura-${aura.commit}.tar.gz";
    url = "https://codeload.github.com/aurora-silicon/aura/tar.gz/${aura.commit}";
    hash = aura.nix_hash;
  };
in
pkgs.runCommand "nixos-aurora-j504" { nativeBuildInputs = [ pkgs.jq ]; } ''
  cp -r ${src} $out
  chmod -R u+w $out
  cd $out

  jq --arg k ${kernel.commit} --arg kv ${kernel.version} \
     --arg ks ${kernel.sha256} --arg kh ${kernel.nix_hash} \
     --arg a ${aura.commit} --arg as ${aura.sha256} --arg ah ${aura.nix_hash} '
    ."kernel-aurora" += {
      commit: $k, version: $kv, sha256: $ks, nix_hash: $kh,
      source_url: "https://codeload.github.com/aurora-silicon/linux/tar.gz/\($k)",
      archive_root: "linux-\($k)" }
    | .aura += {
      commit: $a, sha256: $as, nix_hash: $ah,
      source_url: "https://codeload.github.com/aurora-silicon/aura/tar.gz/\($a)",
      archive_root: "aura-\($a)" }
    | del(.aura.release_tag)' sources.json > s.tmp && mv s.tmp sources.json

  # The vendored ALARM config is kept; only its recorded kernel commit moves.
  jq --arg k ${kernel.commit} \
    '.kernel_commit = $k | .config_upstream.kernel_commit = $k' \
    kernel/provenance.json > p.tmp && mv p.tmp kernel/provenance.json

  tar -xzf ${auraSrc} --strip-components=2 -O \
    aura-${aura.commit}/rust/Cargo.lock > locks/aura.Cargo.lock

  # The PR tree's asahi.config asks for options newer than the vendored
  # ALARM config snapshot (M4/M5 support); olddefconfig would leave them off.
  cat >> kernel/nixos.config <<'CFG'
CONFIG_PCIE_APPLE_MSI=y
CONFIG_APPLE_CENTAURI=m
CONFIG_APPLE_CENTAURI_T6050=m
CONFIG_APPLE_CENTAURI_T6050_WIFI=y
CONFIG_BT_CENTAURI=m
CONFIG_BT_HCICENTAURI=m
CONFIG_DRM_ASAHI_G18=y
CONFIG_DRM_ASAHI_M5=y
CONFIG_BACKLIGHT_APPLE_DWI=m
CONFIG_PHY_APPLE_T6050_DP=m
CFG
''
