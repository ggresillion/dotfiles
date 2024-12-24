return {
    "HTMLDecode",
    function()
        -- Get current buffer content
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local decoded = {}

        -- Common HTML escape sequences
        local escape_chars = {
            ['&quot;'] = '"',
            ['&apos;'] = "'",
            ['&lt;'] = '<',
            ['&gt;'] = '>',
            ['&amp;'] = '&',
            ['&#39;'] = "'",
            ['&#x27;'] = "'",
            ['&#x2F;'] = '/',
            ['&#x60;'] = '`',
            ['&#x3D;'] = '='
        }

        -- Decode each line
        for _, line in ipairs(lines) do
            for escaped, char in pairs(escape_chars) do
                line = line:gsub(escaped, char)
            end
            table.insert(decoded, line)
        end

        -- Replace buffer content
        vim.api.nvim_buf_set_lines(0, 0, -1, false, decoded)
    end
}
