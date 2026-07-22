if status is-interactive
    set -x ZELLIJ_AUTO_ATTACH true
    eval (zellij setup --generate-auto-start fish | string collect)
end
