local tree = require("nvim-tree")

tree.setup({
	view = { width = 30, },
	renderer = { group_empty = true },
	filters = { dotfiles = false }
})

vim.api.nvim_set_keymap('n', '<A-t>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
