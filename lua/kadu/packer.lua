-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

	use 'wbthomason/packer.nvim'
	use('f-person/git-blame.nvim')
	use('nvim-lua/plenary.nvim')
    use { 'gen740/SmoothCursor.nvim',
        config = function()
            require('smoothcursor').setup({
                type = "matrix",           -- Cursor movement calculation method, choose "default", "exp" (exponential) or "matrix".
                cursor = "",              -- Cursor shape (requires Nerd Font). Disabled in fancy mode.
                texthl = "SmoothCursor",   -- Highlight group. Default is { bg = nil, fg = "#FFD400" }. Disabled in fancy mode.
                linehl = nil,              -- Highlights the line under the cursor, similar to 'cursorline'. "CursorLine" is recommended. Disabled in fancy mode.
                fancy = {
                    enable = true,        -- enable fancy mode
                    head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil }, -- false to disable fancy head
                    body = {
                        { cursor = "󰝥", texthl = "SmoothCursorRed" },
                        { cursor = "󰝥", texthl = "SmoothCursorOrange" },
                        { cursor = "●", texthl = "SmoothCursorYellow" },
                        { cursor = "●", texthl = "SmoothCursorGreen" },
                        { cursor = "•", texthl = "SmoothCursorAqua" },
                        { cursor = ".", texthl = "SmoothCursorBlue" },
                        { cursor = ".", texthl = "SmoothCursorPurple" },
                    },
                    tail = { cursor = nil, texthl = "SmoothCursor" } -- false to disable fancy tail
                },
                matrix = {  -- Loaded when 'type' is set to "matrix"
                    head = {
                        -- Picks a random character from this list for the cursor text
                        cursor = require('smoothcursor.matrix_chars'),
                        -- Picks a random highlight from this list for the cursor text
                        texthl = {
                            'SmoothCursor',
                        },
                        linehl = nil,  -- No line highlight for the head
                    },
                    body = {
                        length = 6,  -- Specifies the length of the cursor body
                        -- Picks a random character from this list for the cursor body text
                        cursor = require('smoothcursor.matrix_chars'),
                        -- Picks a random highlight from this list for each segment of the cursor body
                        texthl = {
                            'SmoothCursorGreen',
                        },
                    },
                    tail = {
                        -- Picks a random character from this list for the cursor tail (if any)
                        cursor = nil,
                        -- Picks a random highlight from this list for the cursor tail
                        texthl = {
                            'SmoothCursor',
                        },
                    },
                    unstop = false,  -- Determines if the cursor should stop or not (false means it will stop)
                },
                autostart = true,           -- Automatically start SmoothCursor
                always_redraw = true,       -- Redraw the screen on each update
                flyin_effect = "top",         -- Choose "bottom" or "top" for flying effect
                speed = 50,                 -- Max speed is 100 to stick with your current position
                intervals = 35,             -- Update intervals in milliseconds
                priority = 10,              -- Set marker priority
                timeout = 3000,             -- Timeout for animations in milliseconds
                threshold = 0,              -- Animate only if cursor moves more than this many lines
            })
    end
    }
-- Procurar arquivos
  	use {
  		'nvim-telescope/telescope.nvim', tag = '0.1.3',
		requires = { {'nvim-lua/plenary.nvim'} }
  	}
	--Tema
	use({
		use 'ramojus/mellifluous.nvim',
		as = 'mellifluous', -- MUITO BONITO
		use 'rebelot/kanagawa.nvim',
		--as = 'kanagawa',
        --as = 'kanagawa-dragon', -- MUITO BONITO
		use 'catppuccin/nvim',
		--as = 'catppuccin',
	--	'rose-pine/neovim',
	--	as = 'rose-pine',

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
