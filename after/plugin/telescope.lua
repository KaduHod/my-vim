local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.api.nvim_set_keymap('n', '<Leader>ph', ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', {noremap = true, silent = true}) 


