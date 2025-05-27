require("kadu.remap")
require("kadu.companion")
require("kadu.lsp_config")
require("kadu.search")
require("kadu.init_search")
require("kadu.barbar")
require("kadu.tree")
require("kadu.completions")
require("kadu.luasnip")
require("kadu.debug")
require("kadu.smoothscroll")
require("kadu.remoteGrep")
require("kadu.remoteFindOpen")
--require("kadu.markdown")
require("kadu.packer")
vim.api.nvim_exec([[
  augroup FiletypeDetect
    au BufNewFile,BufRead *.hbs setfiletype html
    au BufNewFile,BufRead *.tmpl setfiletype html
  augroup END
]], false)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
  callback = function()
    vim.keymap.set("n", "<leader>p", function()
      vim.cmd("!npx prettier --write %")
    end, { buffer = true })
  end,
})
print('Arquivo kaduhod carregado!')
