local lsp = require('lsp-zero')
lsp.extend_lspconfig()
lsp.preset('recommended')

lsp.setup()

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)
