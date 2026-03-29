function ColorMyPencils(color)
    color = color or 'vscode'
    vim.cmd.colorscheme(color)
    -- Deixa o fundo transparente
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- Chama a função ao iniciar
ColorMyPencils()

-- Cria o comando :Color dentro do Neovim
vim.api.nvim_create_user_command('Color', function(opts)
    local c = opts.args ~= "" and opts.args or nil
    ColorMyPencils(c)
end, { nargs = '?' })

