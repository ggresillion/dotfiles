export def --wrapped kulala [...args] {
    let data_home = $env.XDG_DATA_HOME? | default ($env.HOME | path join ".local/share")
    let kulala_path = $data_home | path join "nvim/site/pack/core/opt/kulala.nvim/lua/cli/kulala_cli.lua"
    ^$kulala_path -m ...$args | parse-kulala-output
}

# First capture group `v` of `pattern` in `line`, or `fallback`
def capture [line: string, pattern: string, fallback: any] {
    $line | parse -r $pattern | get 0?.v? | default $fallback
}

def parse-kulala-output [] {
    let lines = ($in | lines)
    let request_line = ($lines | where $it =~ "^Request:" | first | default "")
    let url_line = ($lines | where $it =~ "^URL:" | first | default "")
    let buffer_line = ($lines | where $it =~ "^Buffer:" | first | default "")
    let status_line = ($lines | where $it =~ "^Status:" | first | default "")
    let json_lines = ($lines | where $it =~ '^\s*[{\[]')
    let body = if ($json_lines | is-empty) {
        null
    } else {
        let json_start = ($lines | enumerate | where $it.item =~ '^\s*[{\[]' | first | get index)
        let json_end = ($lines | enumerate | where $it.item =~ '[}\]]\s*$' | last | get index)
        let json_str = ($lines | slice $json_start..$json_end | str join "\n")
        try { $json_str | from json } catch { null }
    }
    {
        http_status: (capture $url_line 'Status:\s*(?<v>\d+)' 0 | into int),
        code: (capture $request_line 'Code:\s*(?<v>\d+)' 0 | into int),
        duration_ms: (capture $request_line 'Duration:\s*(?<v>[\d.]+)\s*ms' 0 | into float),
        method: (capture $url_line 'URL:\s*(?<v>\w+)' ""),
        url: (capture $url_line 'URL:\s*\w+\s+(?<v>[^\s]+)' ""),
        env: (capture $url_line 'Env:\s*(?<v>\w+)' ""),
        buffer: (capture $buffer_line 'Buffer:\s*(?<v>[^\s]+)' ""),
        name: (capture $buffer_line 'Name:\s*(?<v>.+)$' ""),
        status: (capture $status_line 'Status:\s*(?<v>\w+)' ""),
        body: $body
    }
}
