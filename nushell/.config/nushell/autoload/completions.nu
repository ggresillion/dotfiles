let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

$env.config.completions = {
    external: {
        enable: true
        completer: $carapace_completer
    }
}
