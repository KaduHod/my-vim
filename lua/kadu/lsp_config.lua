local lsp_zero = require('lsp-zero')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
mason.setup()

mason_lspconfig.setup({
	ensure_installed = {"tailwindcss", "ts_ls", "gopls", "intelephense", "quick_lint_js", "lua_ls", "clangd", "bashls", "kotlin_language_server", "pyright", "cssls", "jdtls", "ast_grep", "htmx"}
})

lsp_zero.extend_lspconfig()

local on_attach = function(_,_)
	vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, { desc = 'LSP: Go to definition'})
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'LSP: Go to implementation'})
	vim.keymap.set('n', '<leader>s', require('telescope.builtin').lsp_references, { desc = 'LSP: Show references'})
	vim.keymap.set('n', '<leader>t', vim.lsp.buf.hover, { desc = 'LSP: Hover'})
end

vim.lsp.config('ast_grep', {
    on_attach = on_attach,
	capabilities = capabilities
})
vim.lsp.config('htmx', {
    filetypes = { "html", "tmpl" },
    on_attach = on_attach,
	capabilities = capabilities
})
vim.lsp.config('ts_ls', {
    on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('quick_lint_js', {
    on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('jdtls', {
    on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('tailwindcss', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('buf_ls', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('gopls', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('cssls', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('pyright', {
	on_attach = on_attach,
	capabilities = capabilities
})


vim.lsp.config('kotlin_language_server', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('intelephense', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('bashls', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('angularls', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('lua_ls', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('clangd', {
	on_attach = on_attach,
	capabilities = capabilities
})

vim.lsp.config('apex_ls', {
	on_attach = on_attach,
	capabilities = capabilities
})
