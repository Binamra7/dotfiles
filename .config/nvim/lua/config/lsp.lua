-- Native LSP setup (:h lsp-config). Server definitions come from
-- nvim-lspconfig's lsp/<server>.lua files; project overrides live in
-- <config>/lsp/<server>.lua and are merged automatically.

-- Mason: pure binary installer (no mason-lspconfig needed) ------------------
require("mason").setup()

local mason_tools = {
	"vtsls",
	"angular-language-server",
	"css-lsp",
	"tailwindcss-language-server",
	"yaml-language-server",
	"lua-language-server",
	"gopls",
	"prettier",
	"stylua",
}

vim.defer_fn(function()
	local registry = require("mason-registry")
	registry.refresh(function()
		for _, tool in ipairs(mason_tools) do
			local ok, pkg = pcall(registry.get_package, tool)
			if ok and not pkg:is_installed() then
				pkg:install():once("install:success", function()
					vim.schedule(function()
						vim.notify("mason: installed " .. tool)
					end)
				end)
			end
		end
	end)
end, 100)

-- Diagnostics ----------------------------------------------------------------
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
	float = { source = "if_many" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})

-- Servers ----------------------------------------------------------------
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Launch ruby-lsp through mise so it runs under the project's Ruby
-- (.ruby-version; idiomatic version files enabled for ruby in mise settings).
-- Plain `ruby-lsp` ran under mise `latest` and died with RubyVersionMismatch
-- in projects pinning an older Ruby. The ruby-lsp gem must be installed in
-- each mise Ruby. NOTE: this must be an explicit vim.lsp.config() call — an
-- lsp/ruby_lsp.lua file loses the cmd key to nvim-lspconfig's own file.
-- --use-launcher: boot gracefully when project gems aren't installed locally
-- (gems live in Docker containers here); project-code navigation still works.
vim.lsp.config("ruby_lsp", {
	cmd = { "mise", "x", "--", "ruby-lsp", "--use-launcher" },
})

-- gopls runs under mise so it sees the mise-managed Go toolchain (go is not on
-- the base PATH here) even when Neovide is launched from a desktop entry rather
-- than a mise-active shell. The gopls binary itself still comes from mason (on
-- nvim's PATH); `mise x` only injects `go` into the PATH gopls shells out to.
vim.lsp.config("gopls", {
	cmd = { "mise", "x", "--", "gopls" },
})

vim.lsp.enable({
	-- Ruby / Rails: ruby-lsp (gem-installed via mise; auto-loads its Rails
	-- addon in Rails apps). Replaced solargraph, whose gem indexing blocked
	-- definition requests for minutes per session.
	"ruby_lsp",
	"vtsls", -- TypeScript (see lsp/vtsls.lua for Angular wiring)
	"angularls",
	"cssls",
	"tailwindcss",
	"yamlls",
	"lua_ls", -- settings come from .luarc.json per project
	"gopls", -- Go (needs the Go toolchain on PATH; mason installs the gopls binary)
})

-- Buffer-local keymaps and features on attach ------------------------------
-- (grn = rename, gra = code action, grr = references are nvim defaults)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
		end

		-- Note: don't gate these on client:supports_method() — solargraph
		-- registers capabilities dynamically *after* attach, so the check
		-- is false here even though the server supports it.
		local builtin = require("telescope.builtin")
		map("gd", function()
			builtin.lsp_definitions({ reuse_win = false })
		end, "Goto Definition")
		map("gr", builtin.lsp_references, "References")
		map("gI", builtin.lsp_implementations, "Goto Implementation")
		map("gy", builtin.lsp_type_definitions, "Goto Type Definition")

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
	end,
})
