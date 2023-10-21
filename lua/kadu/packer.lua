-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

	use 'wbthomason/packer.nvim'
	use('nvim-lua/plenary.nvim')
	-- Procurar arquivos
  	use {
  		'nvim-telescope/telescope.nvim', tag = '0.1.3',
		requires = { {'nvim-lua/plenary.nvim'} }
  	}
	--Tema
	use({
		--'rose-pine/neovim',
		--as = 'rose-pine',
		'catppuccin/nvim',
		as = 'catppuccin',
		config = function()
			vim.cmd('colorscheme catppuccin')
		end
	})
	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use('nvim-treesitter/playground')
	-- atalho de arquivos
	use('theprimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	use {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		'VonHeikemen/lsp-zero.nvim',
	}
	-- Janelas
	use 'romgrk/barbar.nvim'
	use { 'nvim-tree/nvim-tree.lua' }
	-- autocomplete
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	-- snippets de codigo
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	-- vscode like snippets
	use 'rafamadriz/friendly-snippets'

end)
