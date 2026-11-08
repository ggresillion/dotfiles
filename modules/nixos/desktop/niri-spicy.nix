{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

# niri-spicy: third session ("Niri Spicy" in the greeter) with HDR, keeping
# the niri layout and config. It ships its own `niri` binary, so it is only
# referenced by its session/service, never put in PATH (the stock niri stays
# there for `niri msg`). Config: ~/.config/niri/spicy.kdl
# (modules/home/config/niri/spicy.kdl).
let
  niri-spicy = pkgs.rustPlatform.buildRustPackage {
    pname = "niri-spicy";
    version = inputs.niri-spicy.shortRev or "unknown";

    # Cargo.toml patches smithay with `path = "../smithay"`: lay both out side
    # by side and build from the niri directory.
    src = pkgs.runCommand "source" { } ''
      mkdir $out
      cp -r ${inputs.niri-spicy} $out/niri
      cp -r ${inputs.smithay-spicy} $out/smithay
    '';
    sourceRoot = "source/niri";

    cargoLock = {
      lockFile = "${inputs.niri-spicy}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };

    strictDeps = true;
    doCheck = false;

    nativeBuildInputs = with pkgs; [
      rustPlatform.bindgenHook
      pkg-config
      cmake
    ];

    buildInputs = with pkgs; [
      cairo
      dbus
      libGL
      libdisplay-info_0_3
      libinput
      seatd
      libxkbcommon
      libgbm
      pango
      wayland
      pipewire
      systemd
      shaderc
      vulkan-loader
    ];

    env = {
      # Use the system shaderc instead of building it from source.
      SHADERC_LIB_DIR = "${lib.getLib pkgs.shaderc}/lib";
      # dlopen()ed at runtime: keep them in RPATH.
      RUSTFLAGS = toString (
        map (arg: "-C link-arg=" + arg) [
          "-Wl,--push-state,--no-as-needed"
          "-lEGL"
          "-lwayland-client"
          "-lvulkan"
          "-Wl,--pop-state"
        ]
      );
      NIRI_BUILD_COMMIT = inputs.niri-spicy.shortRev or "unknown";
    };

    meta.mainProgram = "niri";
  };

  # Same as upstream niri-session, but drives niri-spicy.service.
  session = pkgs.writeShellScript "niri-spicy-session" ''
    if [ -n "$SHELL" ] && grep -q "$SHELL" /etc/shells \
      && ! (echo "$SHELL" | grep -q "false") && ! (echo "$SHELL" | grep -q "nologin"); then
      if [ "$1" != '-l' ]; then
        exec "$SHELL" -l -c "exec $0 -l $*"
      else
        shift
      fi
    fi

    if systemctl --user -q is-active niri.service niri-spicy.service; then
      echo 'A niri session is already running.'
      exit 1
    fi

    systemctl --user reset-failed
    systemctl --user import-environment
    dbus-update-activation-environment --all

    systemctl --user --wait start niri-spicy.service

    # niri-shutdown.target comes from the stock niri package.
    systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
    systemctl --user unset-environment WAYLAND_DISPLAY DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
  '';

  # Session entry + user unit, shipped as a package so NixOS doesn't inject
  # its minimal PATH into the unit (same as upstream niri.service).
  sessionPackage =
    pkgs.runCommand "niri-spicy-session" { passthru.providedSessions = [ "niri-spicy" ]; }
      ''
        install -Dm644 /dev/stdin $out/share/wayland-sessions/niri-spicy.desktop <<EOF
        [Desktop Entry]
        Name=Niri Spicy
        Comment=niri with HDR (niri-spicy)
        Exec=${session}
        Type=Application
        DesktopNames=niri
        EOF

        install -Dm644 /dev/stdin $out/lib/systemd/user/niri-spicy.service <<EOF
        [Unit]
        Description=niri-spicy, a scrollable-tiling Wayland compositor with HDR
        BindsTo=graphical-session.target
        Before=graphical-session.target
        Wants=graphical-session-pre.target
        After=graphical-session-pre.target
        Wants=xdg-desktop-autostart.target
        Before=xdg-desktop-autostart.target

        [Service]
        Slice=session.slice
        Type=notify
        ExecStart=${lib.getExe niri-spicy} --config %h/.config/niri/spicy.kdl --session
        EOF
      '';
in
{
  config = {
    services.displayManager.sessionPackages = [ sessionPackage ];
    systemd.packages = [ sessionPackage ];
  };

  # `nix build .#nixosConfigurations.guillaume-desktop.config.desktop.niri-spicy`
  options.desktop.niri-spicy = lib.mkOption {
    type = lib.types.package;
    readOnly = true;
    default = niri-spicy;
    description = "The niri-spicy build used by the Niri Spicy session.";
  };
}
