use std/util "path add"

# In PATH precedence order (first wins)
path add ...[
    $"/etc/profiles/per-user/($env.USER)/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
    "~/.bun/bin"
    "/usr/local/bin"
    "~/.cargo/bin"
    "~/scripts"
    "~/.orbstack/bin"
    "/opt/homebrew/bin"
    "~/go/bin"
    "~/.local/bin"
]
