-- Command to fetch, parse, and pretty-print a GCS object **without temp files**
vim.api.nvim_create_user_command("GCSFetch", function(opts)
	local url = opts.args
	local gs_path = url:gsub("^https://storage.cloud.google.com/", "gs://")

	---------------------------------------------------------------------------
	-- 1. Fetch the object directly into Lua (no file on disk)
	---------------------------------------------------------------------------
  local raw_lines = vim.fn.systemlist(string.format("gcloud storage cat '%s'", gs_path))
  if vim.v.shell_error ~= 0 then
	  vim.api.nvim_err_writeln("Failed to fetch GCS file:\n" .. table.concat(raw_lines, "\n"))
	  return
  end

	---------------------------------------------------------------------------
	-- 2. Split headers / JSON (empty line = separator)
	---------------------------------------------------------------------------
	local json_start = nil
	for i, line in ipairs(raw_lines) do
		if vim.trim(line):sub(1, 1) == "{" or vim.trim(line):sub(1, 1) == "[" then
			json_start = i
			break
		end
	end

	if not json_start then
		vim.api.nvim_err_writeln("Could not find JSON body in response.")
		return
	end

	local header_lines = {}
	for i = 1, json_start - 1 do
		table.insert(header_lines, raw_lines[i])
	end
	local json_lines = {}
	for i = json_start, #raw_lines do
		table.insert(json_lines, raw_lines[i])
	end

	---------------------------------------------------------------------------
	-- 3. Pretty-print JSON using jq (stdin → stdout, still no files)
	---------------------------------------------------------------------------
	local formatted = vim.fn.systemlist("jq .", table.concat(json_lines, "\n"))
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("jq failed:\n" .. table.concat(formatted, "\n"))
		return
	end

	---------------------------------------------------------------------------
	-- 4. Show JSON in a scratch, read-only buffer
	---------------------------------------------------------------------------
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)

	-- make it scratch-like and immune to swap/save prompts
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.readonly = true
	vim.bo.modified = false
	vim.bo.filetype = "json"

	---------------------------------------------------------------------------
	-- 5. Optional: show headers in a split, same scratch rules
	---------------------------------------------------------------------------
	if #header_lines > 0 then
		vim.cmd("vnew")
		local hbuf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_lines(hbuf, 0, -1, false, header_lines)

		vim.bo.buftype = "nofile"
		vim.bo.bufhidden = "wipe"
		vim.bo.swapfile = false
		vim.bo.readonly = true
		vim.bo.modified = false
		vim.bo.filetype = "http"
	end
end, {
	nargs = 1,
	desc = "Fetch from GCS, split headers if any, pretty-print JSON (no temp files)",
})

-- <leader>zf → prompt for URL and run GCSFetch
vim.keymap.set("n", "<leader>zf", function()
	vim.ui.input({ prompt = "Enter GCS URL: " }, function(input)
		if input and input ~= "" then
			vim.cmd("GCSFetch " .. input)
		end
	end)
end, { desc = "Fetch and process GCS file" })

local html_entities = {
  ["&quot;"] = '"',
  ["&apos;"] = "'",
  ["&amp;"] = "&",
  ["&lt;"] = "<",
  ["&gt;"] = ">",
  ["&nbsp;"] = " ",
  ["&iexcl;"] = "¡",
  ["&cent;"] = "¢",
  ["&pound;"] = "£",
  ["&copy;"] = "©",
  ["&reg;"] = "®",
  -- Add more named entities here if needed
}

local function decode_numeric_entity(entity)
  local num = entity:match("&#(%d+);")
  if num then
    return utf8.char(tonumber(num))
  end
  local hex = entity:match("&#x(%x+);")
  if hex then
    return utf8.char(tonumber(hex, 16))
  end
  return entity
end

local function unescape_html(str)
  -- First replace named entities
  str = (str:gsub("(&%a+;)", function(entity)
    return html_entities[entity] or entity
  end))
  -- Then replace numeric entities (decimal and hex)
  str = (str:gsub("&#%d+;", decode_numeric_entity))
  str = (str:gsub("&#x%x+;", decode_numeric_entity))
  return str
end

local function unescape_html_in_range(start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  for i, line in ipairs(lines) do
    lines[i] = unescape_html(line)
  end
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end

vim.api.nvim_create_user_command("UnescapeHTML", function(opts)
  local start_line, end_line

  if opts.range and opts.range > 0 then
    start_line = opts.line1
    end_line = opts.line2
  else
    start_line = 1
    end_line = vim.api.nvim_buf_line_count(0)
  end

  unescape_html_in_range(start_line, end_line)
end, { range = true, desc = "Unescape HTML entities in buffer or selection" })

vim.keymap.set({ "n", "v" }, "<leader>zu", function()
  if vim.fn.mode():match("[vV]") then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    unescape_html_in_range(start_line, end_line)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  else
    unescape_html_in_range(1, vim.api.nvim_buf_line_count(0))
  end
end, { desc = "Unescape HTML entities (buffer or selection)" })
