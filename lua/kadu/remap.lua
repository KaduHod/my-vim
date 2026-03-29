vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", function() vim.cmd("Ex") end, { desc = "Arvore de arquivos" })
vim.api.nvim_set_keymap('n', '<C-j>', ':m+1<CR>',  { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', ':m-2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':m-1<CR>',  { noremap = true, silent = true })
