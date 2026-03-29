vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
vim.keymap.set('n', '<leader>gf', '<cmd>Gdiffsplit<cr>')
vim.keymap.set('n', '<leader>gh', ':diffget<CR>]c', { desc = 'Fugitive: Descartar hunk (pull do index)' })
vim.keymap.set('n', '<leader>ga', ':diffput<CR>]c', { desc = 'Git: Aceitar hunk e pular' })
