# config.nu
#
# Installed by:
# version = "0.108.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# Imports
use std/util "path add"
use ($nu.config-path | path dirname | path join 'zellij.nu') *

# Config
$env.XDG_CONFIG_HOME = $env.HOME | path join ".config/"
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.cursor_shape = {
    vi_insert: underscore
    vi_normal: block
    emacs: line
}

# Path
path add "~/.local/bin"
path add "~/go/bin"
path add "/opt/homebrew/bin"
path add "~/.orbstack/bin"
path add "~/scripts"
path add "~/.cargo/bin"
path add "/usr/local/bin"
path add "~/.bun/bin"

# Completers
let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        nu => $fish_completer
        git => $fish_completer
        asdf => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
    completions: {
        external: {
            enable: true
            completer: $external_completer
        }
    }
}

# Abbreviations
let abbreviations = {
    "cd..": 'cd ..'
    dc: 'docker compose'
}

$env.config = {
    keybindings: [
      {
        name: abbr_menu
        modifier: none
        keycode: enter
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { send: menu name: abbr_menu }
            { send: enter }
        ]
      }
      {
        name: abbr_menu
        modifier: none
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { send: menu name: abbr_menu }
            { edit: insertchar value: ' '}
        ]
      }
    ]

    menus: [
        {
            name: abbr_menu
            only_buffer_difference: false
            marker: none
            type: {
                layout: columnar
                columns: 1
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
                let match = $abbreviations | columns | where $it == $buffer
                if ($match | is-empty) {
                    { value: $buffer }
                } else {
                    { value: ($abbreviations | get $match.0) }
                }
            }
        }
    ]
}

$env.config = {
  hooks: {
    pre_prompt: [
      { ||
        if (which direnv | is-empty) {
          return
        }
        direnv export json | from json | default {} | load-env
        if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
          $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
        }
      }
      {
        zellij_update_tabname_prompt
      }
    ]
    pre_execution: [{
        zellij_update_tabname_execution
    }]
  }
}

# Plugins
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
