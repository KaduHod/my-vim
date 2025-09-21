-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

    use 'wbthomason/packer.nvim'
    use 'wellle/context.vim'
    use('f-person/git-blame.nvim')
    use('nvim-lua/plenary.nvim')
    use { 'gen740/SmoothCursor.nvim' }
    -- Menu de atalhos nvim
    -- comentarios
    use 'numToStr/Comment.nvim'

    -- Procurar arquivos
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    -- TEMAS
    use { "ficcdaf/ashen.nvim" , as = "ashen" }
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
    use 'DaikyXendo/nvim-material-icon'
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
    -- IA
    --    use {'github/copilot.vim', branch = 'release' }
    use {
        "Exafunction/codeium.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
                enable_chat = true,
                enable_local_search = true,
            })
        end
    }
    -- Screen shots de codigo
--[[    use {
        "mistricky/codesnap.nvim",
        build = "make build_generator",
        keys = {
            { "<leader>ft", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
            { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
        },
        opts = {
            save_path = "~/code-pictures",
            has_breadcrumbs = true,
            bg_theme = "bamboo",
        },
    }]]--
    use {
        'mistricky/codesnap.nvim',
        run = 'make',
    }
    -- DEBUGGER
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }
    use {
        'mfussenegger/nvim-dap',
        requires = {
            "rcarriga/nvim-dap-ui",
        }
    }
    -- codecompanion
    use {
        "olimorris/codecompanion.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "j-hui/fidget.nvim"
        },
        config = function()
            require("kadu.fidget-spinner"):init()
        end,
        window = {
            layout = "vsplit"
        }
    }
    use {
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
	config = function()
        print("loading render-markdown!")
		require("render-markdown").setup({
			file_types = { "markdown", "codecompanion" },
			heading = {
				enabled = true,
				render_modes = false,
				sign = true,
				icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
				position = 'overlay',
				signs = { '󰫎 ' },
				width = 'full',
				left_margin = 0,
				left_pad = 0,
				right_pad = 0,
				min_width = 0,
				border = false,
				border_virtual = false,
				border_prefix = false,
				above = '▄',
				below = '▀',
				backgrounds = {
					'RenderMarkdownH1Bg',
					'RenderMarkdownH2Bg',
					'RenderMarkdownH3Bg',
					'RenderMarkdownH4Bg',
					'RenderMarkdownH5Bg',
					'RenderMarkdownH6Bg',
				},
				foregrounds = {
					'RenderMarkdownH1',
					'RenderMarkdownH2',
					'RenderMarkdownH3',
					'RenderMarkdownH4',
					'RenderMarkdownH5',
					'RenderMarkdownH6',
				},
				custom = {},
			},
		})
	end
}

end)

