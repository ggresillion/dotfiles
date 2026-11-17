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
    # aura#233 on top of aura#290 (see aurora-pr.nix).
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
