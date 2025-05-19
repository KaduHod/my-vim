-- Importar o plugin
local barbar = require('barbar')
--
-- Configuração do Barbar.nvim
barbar.setup {
	-- Opção para fechar o Neovim quando o último buffer é fechado
	close_on_last_tab = true,
	icons = { filetype = { enabled = false } },
	-- Mostrar números nas guias
	show_numbers = true,
	-- Configuração de realce das guias
	show_tabpages = true,
	show_filename_only = true,

}

-- Configurar os mapeamentos (teclas de atalho) para navegar entre as guias
vim.api.nvim_set_keymap('n', '<leader>,', '<cmd>BufferPrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>.', '<cmd>BufferNext<CR>', { noremap = true, silent = true })

-- Opcional: Configurar um atalho para fechar o buffer atual
vim.api.nvim_set_keymap('n', '<A-c>', '<cmd>BufferClose<CR>', { noremap = true, silent = true })

