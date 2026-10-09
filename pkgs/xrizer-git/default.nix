{
  lib,
  xrizer,
  fetchFromGitHub,
  rustPlatform,
  libGL,
  openxr-loader,
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
    rev = "1511bbe75bfa38cb775dd0aae1bfc8d1b8d3efde";
    hash = "sha256-3bp1JYNPUbNwBkjZG2Ex1jtj3L8Vt78wFKhHAPpTD58=";
  };
in
xrizer.overrideAttrs (old: {
  version = "unstable-2026-10-07";
  inherit src;
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-F6ZTOCPih04tT0hlaso43/TNP5bahQkF8HOdjn7/bBc=";
  };
  # IVRCompositor029::GetPosesForFrame is still todo!() upstream (as of
  # 2026-10-07) and panics on launch in some games; return current poses instead.
  patches = [ ./get-poses-for-frame.patch ];
  # Upstream renamed the "static"/"linked" openxr features to
  # "static-openxr" (dynamic is now the default), so the old feature
  # substitution in nixpkgs' postPatch no longer applies - only the
  # libGLX.so.0 path fixup is still needed.
  postPatch = ''
    substituteInPlace src/graphics_backends/gl.rs \
      --replace-fail 'libGLX.so.0' '${lib.getLib libGL}/lib/libGLX.so.0'
  '';
  # The default build dlopen()s libopenxr_loader.so by bare name, which
  # isn't on the game's library path; dlopen also searches the calling
  # library's RUNPATH, so add the loader there (after fixup's rpath shrink).
  postFixup = (old.postFixup or "") + ''
    patchelf --add-rpath ${lib.getLib openxr-loader}/lib \
      $out/lib/xrizer/${old.platformPath}/vrclient.so
  '';
})
