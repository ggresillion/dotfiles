# Local packages, exposed as `overlays.default` and `packages.<system>` by the flake.
final: prev: {
  # nixpkgs' openrgb doesn't yet support this MSI B850 board's i2c devices.
  openrgb-git = final.callPackage ./openrgb-git { };
  deezer-tui = final.callPackage ./deezer-tui/package.nix { };
  xrizer-git = final.callPackage ./xrizer-git { };
}
