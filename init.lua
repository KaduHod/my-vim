require("kadu")
print('Arquivos carregados')
vim.cmd("set relativenumber")
vim.cmd("set nowrap")
vim.cmd("set foldmethod=indent")
vim.cmd("set tabstop=4 shiftwidth=4 expandtab")
vim.cmd("set number")
vim.opt.clipboard = "unnamedplus"
vim.cmd("let g:netrw_liststyle = 3")
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})
vim.cmd([[
  highlight RenderMarkdownH1Bg guibg=#FF0000
  highlight RenderMarkdownH2Bg guibg=#00FF00
  highlight RenderMarkdownH3Bg guibg=#0000FF
  highlight RenderMarkdownH4Bg guibg=#FFFF00
  highlight RenderMarkdownH5Bg guibg=#FF00FF
  highlight RenderMarkdownH6Bg guibg=#00FFFF
]])
