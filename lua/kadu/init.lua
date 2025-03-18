require("kadu.remap")
require("kadu.lsp_config")
require("kadu.barbar")
require("kadu.tree")
require("kadu.completions")
require("kadu.luasnip")
require("kadu.debug")
require("kadu.smoothscroll")
require("kadu.packer")
vim.api.nvim_exec([[
  augroup FiletypeDetect
    au BufNewFile,BufRead *.hbs setfiletype html
    au BufNewFile,BufRead *.tmpl setfiletype html
  augroup END
]], false)
print('Arquivo kaduhod carregado!')
