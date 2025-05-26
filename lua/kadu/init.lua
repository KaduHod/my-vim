require("kadu.remap")
require("kadu.search")
require("kadu.companion")
require("kadu.lsp_config")
require("kadu.barbar")
require("kadu.tree")
require("kadu.completions")
require("kadu.luasnip")
require("kadu.debug")
require("kadu.smoothscroll")
--require("kadu.markdown")
require("kadu.packer")
vim.api.nvim_exec([[
  augroup FiletypeDetect
    au BufNewFile,BufRead *.hbs setfiletype html
    au BufNewFile,BufRead *.tmpl setfiletype html
  augroup END
]], false)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
  callback = function()
    vim.keymap.set("n", "<leader>p", function()
      vim.cmd("!npx prettier --write %")
    end, { buffer = true })
  end,
})

vim.api.nvim_create_user_command("GrepSearch", function(opts)
    -- Criar um novo buffer flutuante para exibir os resultados
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    -- Fechar janela com 'q'
    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })

    -- Abrir arquivo ao pressionar <Enter>
    vim.keymap.set("n", "<CR>", function()
        local line = vim.api.nvim_get_current_line()
        local filepath, lineno = string.match(line, "^([^:]+):(%d+):")
        if filepath and lineno then
            vim.api.nvim_win_close(win, true) -- fecha a janela flutuante
            vim.cmd("edit " .. filepath)      -- abre o arquivo
            vim.api.nvim_win_set_cursor(0, { tonumber(lineno), 0 }) -- vai para a linha
        else
            vim.notify("Não foi possível extrair caminho/linha da linha selecionada.", vim.log.levels.WARN)
        end
    end, { buffer = buf })

    -- Chamar sua função de busca
    require("kadu.search").search_in_project(opts.args, buf)
end, {
    nargs = "+",
    desc = "Busca com grep no projeto atual",
})
print('Arquivo kaduhod carregado!')
