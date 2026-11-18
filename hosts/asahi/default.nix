# 14" M3 MacBook Pro (J504) on nixos-aurora.
#
# Temporary workarounds, each to remove once its fix is upstream (status as
# of 2026-11-18):
#
# 1. aurora-pr.nix: kernel aurora-silicon/linux#2147 and aura#290, the J504
#    display and GPU support. Without them the Mac boots on simpledrm.
#    Remove when both are merged and the channel-testing pins carry them:
#    import inputs.aurora directly again (see the let block below).
# 2. The aura#233 overlay below: without it aura (from #290) boot-loops every
#    M3 (aura#231). Remove when aura#233 is merged and pinned, or when the
#    patch stops applying (it is then upstream).
# 3. configuration.nix, j504-swap-timestamps: 120 Hz instead of 60 fps on the
#    internal panel. Remove when the J504 record in
#    drivers/gpu/drm/apple/iomfb_v14_7.c sets swap_timestamps upstream
#    (aurora-silicon/linux#1632 covers the other M3s, not the J504); the
#    patch then fails to apply.
#
# After removing one, check the panel (niri msg outputs, a vsynced app at
# ~120 fps) and that aura still boots: a broken aura is recovered from macOS
# by restoring m1n1/boot.bin.old on the ESP.
{ inputs, ... }:

let
  upstream = inputs.aurora;
  # Aurora with the J504 kernel and aura PRs (see aurora-pr.nix).
  aurora = import ./aurora-pr.nix {
    pkgs = upstream.inputs.nixpkgs.legacyPackages.aarch64-linux;
    src = upstream;
  };
in
{
  imports = [
    ./hardware.nix
    ./configuration.nix
    ../../modules/nixos/common
    ../../modules/nixos/desktop/niri.nix
    # Aurora: M3 (J504) GPU and display, on its own nixpkgs and
    # nixos-apple-silicon pins so its binary cache applies.
    upstream.inputs.apple-silicon.nixosModules.default
    "${aurora}/modules/aurora.nix"
    "${aurora}/modules/installed.nix"
  ];

  nixpkgs.overlays = [
    upstream.inputs.apple-silicon.overlays.default
    (import "${aurora}/overlay.nix")
    # Workaround 2: aura#233 on top of aura#290. aura main (#217, in #290)
    # has the boot core write its own RVBAR, which takes an SError on every
    # M3 and reboots right after the Aurora logo (aura#231).
    # Remove when aura#233 is merged and in the pinned aura.
    (final: prev: {
      m1n1 = prev.m1n1.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (final.fetchpatch {
            url = "https://github.com/aurora-silicon/aura/commit/a00ef17ecf26c89bcf1f644e1af7a943075ca95d.patch";
            hash = "sha256-k5orBloHZwiO9N+hk7dhF5xt+dWXJP1hO3/TKAWpFWQ=";
          })
        ];
      });
    })
  ];

  # Hardware stack only: niri and the dux greeter stay the desktop.
  aurora.desktop = "minimal";
  aurora.update.flake = "/etc/nixos#guillaume-asahi";

  # Aurora leaves sshd off and port 22 closed by default.
  aurora.openssh.startAtBoot = true;
  services.openssh.openFirewall = true;
}
