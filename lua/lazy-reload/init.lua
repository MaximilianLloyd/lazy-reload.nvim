local LazyReload = {
	opts = {}
}

LazyReload.default_config = {
	name = "ReloadPlugin",
}


LazyReload.setup = function(opts)
	LazyReload.opts = vim.tbl_deep_extend("force", LazyReload.default_config, opts or {})

	vim.api.nvim_create_user_command(LazyReload.opts.name, function(args)
		local plugins = require("lazy.core.config").plugins
		local plugin_name = args[1]
		local plugin = plugins[plugin_name]

		if plugin == nil then
			vim.notify("Plugin not found", vim.log.levels.ERROR)
			return
		end

		require("lazy.core.loader").reload(plugin)
	end, {
		-- args = { "-nargs=1" },
		complete = function()
			-- Get the plugin names
			local names = {}
			for name, _ in pairs(require("lazy.core.config").plugins) do
				table.insert(names, name)
			end

			return names
		end,
		nargs = 1,
	})
end


return LazyReload
