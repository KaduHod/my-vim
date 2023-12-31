local lsp_zero = require('lsp-zero')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
mason.setup()

mason_lspconfig.setup({
	ensure_installed = { "apex_ls","intelephense", "quick_lint_js", "lua_ls", "clangd" }
})

lsp_zero.extend_lspconfig()

local on_attach = function(_,_)
	vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, {})
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
	vim.keymap.set('n', '<leader>s', require('telescope.builtin').lsp_references, {})
	vim.keymap.set('n', '<leader>t', vim.lsp.buf.hover, {})
end

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

lsp.apex_ls.setup {
	on_attach = on_attach,
	capabilities = capabilities
}
