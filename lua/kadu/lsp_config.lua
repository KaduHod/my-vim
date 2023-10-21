require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "intelephense", "quick_lint_js", "lua_ls", "clangd" }
})

local on_attach = function(_,_)
	vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, {})
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
	vim.keymap.set('n', '<leader>s', require('telescope.builtin').lsp_references, {})
	vim.keymap.set('n', '<leader>t', vim.lsp.buf.hover, {})
end

local lsp = require("lspconfig")

lsp.intelephense.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

lsp.tsserver.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

lsp.lua_ls.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

lsp.clangd.setup {
	on_attach = on_attach,
	capabilities = capabilities
}
