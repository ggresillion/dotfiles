local M = {}

function M.auto_attach(bin)
	local dap = require("dap")
	local uv = vim.loop
	local interval = 1000

	local current_pid = nil
	local attaching = false

	local function find_pid(bin)
		local handle = io.popen("pgrep -f " .. bin)
		if not handle then
			return nil
		end

		local result = handle:read("*l")
		handle:close()

		if result and tonumber(result) then
			return tonumber(result)
		end
		return nil
	end

	local timer = uv.new_timer()
	if not timer then
		return
	end

	timer:start(0, interval, function()
		local pid = find_pid(bin)

		if pid and pid ~= current_pid and not attaching then
			attaching = true
			current_pid = pid

			vim.schedule(function()
				dap.run({
					buildFlags = "",
					mode = "local",
					name = "Attach",
					request = "attach",
					type = "go",
					processId = pid,
					program = bin,
				})

				vim.notify("[DAP] attached to PID " .. pid)
				attaching = false
			end)
		end

		if not pid and current_pid ~= nil then
			local pid_str = tostring(current_pid)
			vim.schedule(function()
				vim.notify("[DAP] process died (PID " .. pid_str .. ") — waiting…")
			end)
			current_pid = nil
		end
	end)
end

return M
