local capabilities = require('cmp_nvim_lsp').default_capabilities()
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
vim.env.PATH = vim.fn.expand("~/.local/share/nvim/mason/bin") .. ":" .. vim.env.PATH

mason_lspconfig.setup({
  ensure_installed = {
    "intelephense", "tailwindcss", "ts_ls", "gopls",
    "quick_lint_js", "lua_ls", "clangd", "bashls",
    "kotlin_language_server", "pyright", "cssls", "jdtls", "ast_grep"
  }
})

local on_attach = function(_, _)
  vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition,        { desc = 'LSP: Go to definition' })
  vim.keymap.set('n', 'gi',        vim.lsp.buf.implementation,    { desc = 'LSP: Go to implementation' })
  vim.keymap.set('n', '<leader>s', require('telescope.builtin').lsp_references, { desc = 'LSP: Show references' })
  vim.keymap.set('n', '<leader>t', vim.lsp.buf.hover,             { desc = 'LSP: Hover' })
end

-- ═══════════════════════════════════════════
--  Configs individuais
-- ═══════════════════════════════════════════

local servers = {
  'quick_lint_js', 'jdtls', 'tailwindcss', 'buf_ls',
  'gopls', 'cssls', 'pyright', 'kotlin_language_server',
  'bashls', 'angularls', 'lua_ls', 'clangd', 'apex_ls',
}

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable(server)
end

-- ═══════════════════════════════════════════
--  Intelephense — config especial com root_dir
-- ═══════════════════════════════════════════

vim.lsp.config('intelephense', {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "intelephense", "--stdio" },
  single_file_support = true,
  filetypes = { 'php' },

  root_dir = function(fname)
    local root = vim.fs.root(fname, { 'composer.json', '.git', '.phpcs.xml' })
    return root or vim.fn.expand('~/.php-workspace')
  end,

  settings = {
    intelephense = {
      files = { maxSize = 5000000 },
      stubs = {
        "bcmath", "bz2", "calendar", "Core", "curl", "date",
        "dom", "filter", "fileinfo", "gd", "gettext", "hash",
        "iconv", "imap", "intl", "json", "libxml", "mbstring",
        "mcrypt", "mysqli", "openssl", "pcre",
        "PDO", "pdo_mysql", "Phar", "Reflection",
        "session", "SimpleXML", "soap", "sockets", "sodium",
        "SPL", "standard", "tokenizer", "xml", "xmlreader",
        "xmlwriter", "xsl", "zip", "zlib", "superglobals",
      },
    },
  },
})

vim.lsp.config('phpactor', { enabled = false })
vim.lsp.enable('intelephense')
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  callback = function()
    vim.lsp.start({
      name = 'intelephense',
      cmd = { 'intelephense', '--stdio' },
      root_dir = (function()
        local root = vim.fs.root(0, { 'composer.json', '.git', '.phpcs.xml' })
        return root or vim.fn.expand('~/.php-workspace')
      end)(),
      single_file_support = true,
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        intelephense = {
          files = { maxSize = 5000000 },
          stubs = {
            "bcmath", "bz2", "calendar", "Core", "curl", "date",
            "dom", "filter", "fileinfo", "gd", "gettext", "hash",
            "iconv", "imap", "intl", "json", "libxml", "mbstring",
            "mcrypt", "mysqli", "openssl", "pcre",
            "PDO", "pdo_mysql", "Phar", "Reflection",
            "session", "SimpleXML", "soap", "sockets", "sodium",
            "SPL", "standard", "tokenizer", "xml", "xmlreader",
            "xmlwriter", "xsl", "zip", "zlib", "superglobals",
          },
        },
      },
    })
  end,
})
