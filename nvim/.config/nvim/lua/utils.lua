local M = {}

function M.extract_json(text)
    local json_start = text:find("{")

    if json_start then
        local json_content = text:sub(json_start)
        return json_content
    else
        error("No JSON content found")
    end
end

function M.run_jq(json)
    local jq_handle = io.popen('echo \'' .. json .. '\' | jq .')
    if jq_handle == nil then
        error("jq command not found")
    end
    local formatted_json = jq_handle:read("*a")
    jq_handle:close()
    return formatted_json
end

function M.filter_dap_logs()
    -- Get the current buffer number
    local bufnr
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(b, 'filetype') == 'dap-repl' then
            bufnr = b
        end
    end

    -- Get all lines in the current buffer
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Filter lines and extract service names
    local matching_logs = {}
    for _, line in ipairs(lines) do
        local full_log = line:match("logs push at (.+)")
        local display = line:match("(.+)logs push at")

        if full_log then
            table.insert(matching_logs, {
                value = full_log,
                display = display,
                ordinal = full_log,
            })
        end
    end

    -- Revert the order of matching_logs
    local reversed_logs = {}
    for i = #matching_logs, 1, -1 do
        table.insert(reversed_logs, matching_logs[i])
    end
    matching_logs = reversed_logs

    -- If no logs found, notify user
    if #matching_logs == 0 then
        vim.notify("No matching log entries found", vim.log.levels.WARN)
        return
    end

    -- Create a selection UI using Telescope
    local ok_telescope, telescope = pcall(require, 'telescope.pickers')
    if not ok_telescope then
        vim.notify("Telescope is required for log selection", vim.log.levels.ERROR)
        return
    end

    local finders = require('telescope.finders')
    local conf = require('telescope.config').values

    telescope.new({}, {
        prompt_title = "Log Entries",
        finder = finders.new_table({
            results = matching_logs,
            entry_maker = function(entry)
                return entry
            end
        }),
        attach_mappings = function(prompt_bufnr)
            local actions = require('telescope.actions')
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = require('telescope.actions.state').get_selected_entry()

                if not selection then
                    vim.notify("No log selected", vim.log.levels.WARN)
                    return
                end

                -- Find the corresponding full log entry
                local selected_log = selection.value

                if selected_log then
                    -- Extract the URL
                    local url = selected_log:match("https://[%w%p]+"):gsub(":$", "")
                    if not url then
                        vim.notify("No URL found in log entry", vim.log.levels.ERROR)
                        return
                    end

                    local content = M.fetch_from_gcloud(url)
                    if not content then
                        vim.notify("Failed to fetch content from URL", vim.log.levels.ERROR)
                        return
                    end
                    local json_content = M.extract_json(content)
                    local formatted_json = M.run_jq(json_content)
                    if formatted_json == "" then
                        vim.notify("No JSON content found", vim.log.levels.ERROR)
                        formatted_json = content
                    end
                    -- Create a new buffer and set the content
                    local new_buf = vim.api.nvim_create_buf(true, false)                               -- Create a listed, modifiable buffer
                    vim.api.nvim_buf_set_option(new_buf, "filetype", "json")
                    vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, vim.split(formatted_json, "\n")) -- Set content line by line

                    -- Open the buffer in a new window
                    vim.api.nvim_set_current_buf(new_buf)
                end
            end)
            return true
        end,
        sorter = conf.generic_sorter({})
    }):find()
end

function M.fetch_from_gcloud(url)
    -- Convert to gs:// format
    local gs_url = url:gsub("https://storage.cloud.google.com/", "gs://")

    -- Run gsutil cat to fetch the content
    local handle = io.popen("gsutil cat " .. gs_url)
    if not handle then
        vim.notify("Failed to run gsutil cat", vim.log.levels.ERROR)
        return
    end
    local content = handle:read("*a") -- Read the entire binary content
    handle:close()

    return content
end

vim.api.nvim_create_user_command('FetchFromLogs', M.filter_dap_logs, {})
