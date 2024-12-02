-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

	use 'wbthomason/packer.nvim'
	use('f-person/git-blame.nvim')
	use('nvim-lua/plenary.nvim')
    use { 'gen740/SmoothCursor.nvim' }
    -- Menu de atalhos nvim

    -- Procurar arquivos
  	use {
  		'nvim-telescope/telescope.nvim', tag = '0.1.3',
		requires = { {'nvim-lua/plenary.nvim'} }
  	}
    -- TEMAS
    use { 'Mofiqul/vscode.nvim', as = "vscode"}
    use { "EdenEast/nightfox.nvim", as = "nightfox" }
    use { "sainnhe/everforest", as = "everforest" }
    use { "projekt0n/github-nvim-theme", as="github" }
    use { 'rebelot/kanagawa.nvim', as = "kanagawa" }
    use { 'catppuccin/nvim', as = 'catppuccin' }
    use { 'rose-pine/neovim', as = 'rose-pine' }
    use { "sonjiku/yawnc.nvim", as = "yawnc" }
    use { 'Mofiqul/adwaita.nvim', as="adwaita"}
    use { "scottmckendry/cyberdream.nvim", as="cyberdream" }
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	--use('nvim-treesitter/playground')
	-- atalho de arquivos
	use('theprimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	-- lsp
	use {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		'VonHeikemen/lsp-zero.nvim',
	}
	-- Janelas
	use 'romgrk/barbar.nvim'
    -- Barra de navegação e icones
    use 'nvim-tree/nvim-web-devicons'
	use { 'nvim-tree/nvim-tree.lua' }
	-- autocomplete
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	-- snippets de codigo
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	-- vscode like snippets
	use 'rafamadriz/friendly-snippets'
	use 'mfussenegger/nvim-jdtls'

    --smoth scroll
    use 'karb94/neoscroll.nvim'

end)
