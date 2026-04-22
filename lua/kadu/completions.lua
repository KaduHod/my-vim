local cmp = require('cmp')
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }, -- dispara ao digitar
    },
    experimental = {
        ghost_text = true
    },
    sources = cmp.config.sources(
        {
            -- { name = "codeium" },
            { name = "nvim_lsp" },
            { name = 'codecompanion' },
            { name = 'luasnip' },
        },
        {
            { name = "buffer" },
        }
    )
})
