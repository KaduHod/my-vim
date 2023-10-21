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

require("lspconfig").intelephense.setup {
	on_attach = on_attach
}
require("lspconfig").tsserver.setup {
	on_attach = on_attach
}
require("lspconfig").lua_ls.setup {
	on_attach = on_attach
}

require("lspconfig").clangd.setup {
	on_attach = on_attach
}
