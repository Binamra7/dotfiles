return {
	on_attach = function(client)
		-- vtsls handles renames; angularls renaming causes duplicate prompts
		client.server_capabilities.renameProvider = false
	end,
}
