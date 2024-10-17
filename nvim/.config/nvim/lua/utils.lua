local function extract_json(text)
    local json_start = text:find("{")

    if json_start then
        local json_content = text:sub(json_start)
        return json_content
    else
        error("No JSON content found")
    end
end

local function run_jq(json)
    local jq_handle = io.popen('echo \'' .. json .. '\' | jq .')
    if jq_handle == nil then
        error("jq command not found")
    end
    local formatted_json = jq_handle:read("*a")
    jq_handle:close()
    return formatted_json
end

local function get_json(arg)
    local content = ""

    -- Check if the argument is a URL or a local file path
    if arg:match("^https?://") then
        -- It's a URL, use curl to fetch the content
        local handle = io.popen("curl -s -L '" .. arg .. "'")
        if handle == nil then
            error("curl command not found")
        end
        content = handle:read("*a")
        handle:close()
    else
        -- It's a local file path, read the file
        local file = io.open(arg, "r")
        if file then
            content = file:read("*a")
            file:close()
        else
            print("Error: Unable to open file " .. arg)
            return
        end
    end

    local json_content = extract_json(content)
    local formatted_json = run_jq(json_content)

    -- Create a new buffer and set its content
    vim.cmd("new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(formatted_json, "\n"))
    vim.bo.filetype = "json"
end

vim.api.nvim_create_user_command("GetJSON", function(opts)
    get_json(opts.args)
end, { nargs = 1 })
