export def --wrapped kulala [...args] {
    let kulala_path = $"($env.HOME)/.local/share/nvim/site/pack/core/opt/kulala.nvim/lua/cli/kulala_cli.lua"
    ^$kulala_path -m ...$args | parse-kulala-output
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
    let http_status = if ($url_line | str contains "Status:") {
        $url_line | parse -r 'Status:\s*(\d+)' | get capture0?.0? | default 0 | into int
    } else { 0 }
    let duration = if ($request_line | str contains "Duration:") {
        $request_line | parse -r 'Duration:\s*([\d.]+)\s*ms' | get capture0?.0? | default 0 | into float
    } else { 0.0 }
    let code = if ($request_line | str contains "Code:") {
        $request_line | parse -r 'Code:\s*(\d+)' | get capture0?.0? | default 0 | into int
    } else { 0 }
    let method = if ($url_line | str contains "URL:") {
        $url_line | parse -r 'URL:\s*(\w+)' | get capture0?.0? | default ""
    } else { "" }
    let url = if ($url_line | str contains "URL:") {
        $url_line | parse -r 'URL:\s*\w+\s+([^\s]+)' | get capture0?.0? | default ""
    } else { "" }
    let env_name = if ($url_line | str contains "Env:") {
        $url_line | parse -r 'Env:\s*(\w+)' | get capture0?.0? | default ""
    } else { "" }
    let buffer_path = if ($buffer_line | str contains "Buffer:") {
        $buffer_line | parse -r 'Buffer:\s*([^\s]+)' | get capture0?.0? | default ""
    } else { "" }
    let request_name = if ($buffer_line | str contains "Name:") {
        $buffer_line | parse -r 'Name:\s*(.+)$' | get capture0?.0? | default ""
    } else { "" }
    let final_status = if ($status_line | str contains "Status:") {
        $status_line | parse -r 'Status:\s*(\w+)' | get capture0?.0? | default ""
    } else { "" }
    {
        http_status: $http_status,
        code: $code,
        duration_ms: $duration,
        method: $method,
        url: $url,
        env: $env_name,
        buffer: $buffer_path,
        name: $request_name,
        status: $final_status,
        body: $body
    }
}
