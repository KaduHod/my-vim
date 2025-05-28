vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
  callback = function()
    vim.keymap.set("n", "<leader>p", function()
      vim.cmd("!npx prettier --write %")
    end, { buffer = true })
  end,
})
local function from_first_slash(str)
    -- Encontra a posição da primeira barra
    local slash_pos = str:find('/')

    -- Se encontrou, retorna a barra e tudo depois dela
    if slash_pos then
        return str:sub(slash_pos)
    end

    -- Se não encontrou barra, retorna string vazia
    return ''
end
function RemoteEditCommand(user_host, file_path)
    -- Remove espaços em branco extras e normaliza barras
    user_host = user_host:gsub("%s+", "")
    file_path = file_path:gsub("%s+", ""):gsub("^/*", "")

    -- Constrói o comando garantindo o formato correto
    local command = string.format("e scp://%s//%s", user_host, file_path)

    -- Retorna o comando pronto para uso
    return command
end
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
            local sanitized_filepath = from_first_slash(filepath)
            vim.api.nvim_win_close(win, true) -- fecha a janela flutuante
            local cmd = RemoteEditCommand(_G.host, sanitized_filepath)
            vim.api.nvim_command(cmd)      -- abre o arquivo
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
vim.api.nvim_create_user_command("FindFiles", function(opts)
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

    local close_win = function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    -- Fechar janela com 'q' ou <Esc>
    vim.keymap.set("n", "q", close_win, { buffer = buf })
    vim.keymap.set("n", "<Esc>", close_win, { buffer = buf })

    -- Abrir arquivo e fechar janela ao pressionar <CR>
    vim.keymap.set("n", "<CR>", function()
        local line = vim.api.nvim_get_current_line()
        local filepath = line:match("^(.-)$")
        if filepath and vim.fn.filereadable(filepath) == 1 then
            close_win()
            local sanitized_filepath = from_first_slash(filepath)
            local cmd = RemoteEditCommand(_G.host, sanitized_filepath)
            vim.api.nvim_command(cmd)
        end
    end, { buffer = buf })

    require("kadu.search").find_files_in_project(opts.args, buf)
end, {
    nargs = 1,
    desc = "Busca arquivos por nome no projeto atual",
})
vim.api.nvim_set_keymap('n', '<leader>rg', ':GrepSearch ', {
    noremap = true,
    silent = false,  -- Mostra o comando
    desc = "Interactive grep search (excludes vendor,storage,logs)"
})
