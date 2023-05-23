local LazyReload = {
	opts = {}
}

LazyReload.default_config = {
	command_name = "ReloadPlugin",
}


LazyReload.setup = function(opts)
	LazyReload.opts = vim.tbl_deep_extend("force", LazyReload.default_config, opts or {})

	vim.api.nvim_create_user_command(LazyReload.opts.command_name, function(opts)
		local plugins = require("lazy.core.config").plugins

		local plugin_name = opts.args
		local plugin = plugins[plugin_name]

		if plugin == nil then
			vim.notify("Plugin not found", vim.log.levels.ERROR)
			return
		end

		require("lazy.core.loader").reload(plugin)
		vim.notify(plugin_name .. " reloaded", vim.log.levels.INFO)
	end, {
		complete = function()
			local names = {}
			for name, _ in pairs(require("lazy.core.config").plugins) do
				table.insert(names, name)
			end

			return names
		end,
		nargs = 1,
	})
end

LazyReload.feed = function()
	vim.api.nvim_feedkeys(":" .. LazyReload.opts.command_name .. " ", "n", true)
end


return LazyReload
