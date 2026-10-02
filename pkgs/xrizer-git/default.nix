{
  lib,
  xrizer,
  fetchFromGitHub,
  rustPlatform,
  libGL,
}:

# nixpkgs' xrizer (currently 0.5) doesn't yet implement OpenVR's
# IVRSystem_026, which recent No Man's Sky builds request. Without it,
# xrizer's OpenXR session opens then immediately tears down, and NMS
# silently falls back to flatscreen/PC mode instead of erroring.
# Fixed upstream in https://github.com/Supreeeme/xrizer/pull/341
# (merged 2026-05-29), not yet in a tagged release.
# https://github.com/WiVRn/WiVRn/issues/928
let
  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xrizer";
    rev = "0989a7fac2d1efb7ea82f5fe1a8ed30c3eeb9596";
    hash = "sha256-Rb1pssAq6Zx6VmQVQtGcThkA6zCwi5X7G7aHmdsDrJo=";
  };
in
xrizer.overrideAttrs (old: {
  version = "unstable-2026-09-03";
  inherit src;
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-JKQUrHGqnU5453iVKXnO51nX2NqcBYzsfvuu92WhLDE=";
  };
  # Upstream renamed the "static"/"linked" openxr features to
  # "static-openxr" (dynamic is now the default), so the old feature
  # substitution in nixpkgs' postPatch no longer applies - only the
  # libGLX.so.0 path fixup is still needed.
  postPatch = ''
    substituteInPlace src/graphics_backends/gl.rs \
      --replace-fail 'libGLX.so.0' '${lib.getLib libGL}/lib/libGLX.so.0'
  '';
})
