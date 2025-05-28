-- ~/.config/nvim/lua/grep-search/search.lua

local M = {}
-- Função para encontrar o diretório root do projeto
local function find_project_root()
    local markers = { ".git", ".gitignore", "package.json", "Cargo.toml", "go.mod", "requirements.txt", "Makefile" }
    local current_dir = vim.fn.expand("%:p:h")
    local current_file = vim.fn.expand("%:p")

    if _G.is_remote then
        return _G.remote_dir
    end

    -- Verificar se estamos em uma conexão SCP
    if string.match(current_file, "^scp://") then
        -- Extrair o caminho remoto do URI SCP
        local remote_path = string.match(current_file, "^scp://[^/]+/(.+)/")
        if remote_path then
            return remote_path
        end
        return current_file -- Fallback: usar o URI completo se não conseguir extrair o caminho
    end
    -- Se não há arquivo aberto, usar diretório atual
    if current_dir == "" then
        current_dir = vim.fn.getcwd()
    end

    -- Subir na hierarquia procurando por marcadores de projeto
    local function search_upward(path)
        for _, marker in ipairs(markers) do
            if vim.fn.filereadable(path .. "/" .. marker) == 1 or vim.fn.isdirectory(path .. "/" .. marker) == 1 then
                return path
            end
        end

        local parent = vim.fn.fnamemodify(path, ":h")
        if parent == path then
            return nil -- Chegou na raiz do sistema
        end

        return search_upward(parent)
    end

    local root = search_upward(current_dir)
    return root or current_dir -- Se não encontrar, usar diretório atual
end
-- Função para executar grep e formatar resultados
local function run_grep(search_terms, project_root, is_remote)
    if not search_terms or search_terms == "" then
        return { "Erro: Nenhum termo de busca fornecido" }
    end

    local grep_cmd

    -- Verificação robusta do estado remoto
    local is_actually_remote = (_G.is_remote == true) or (is_remote == true)
    if is_actually_remote then
        grep_cmd = string.format(
            'ssh %s \'grep -rn --exclude-dir=node_modules --exclude-dir=includes --exclude-dir=vendor --exclude-dir=storage --exclude-dir=logs --include=*.php --include=*.js "%s" %s\' 2>/dev/null',
        _G.host,
        search_terms,
        _G.remote_dir
        )
    else
        grep_cmd = string.format(
            'grep -rn -H --exclude-dir=.git --exclude-dir=node_modules "%s" "%s" 2>/dev/null',
            search_terms,
            project_root
        )
    end
    local output = vim.fn.system(grep_cmd)
    local exit_code = vim.v.shell_error
    if exit_code ~= 0 then
        if exit_code == 1 then
            return { "Nenhum resultado encontrado para: " .. search_terms }
        else
            return {
                string.format(
                "Erro ao executar grep (código %d):\n%s",
                exit_code,
                output
                )
            }
        end
end

local lines = {}
for line in output:gmatch("[^\r\n]+") do
    table.insert(lines, line)
end

return #lines > 0 and lines or { "Nenhum resultado encontrado para: " .. search_terms }
end

-- Função para formatar os resultados no buffer
local function format_results(search_terms, project_root, results)
    local formatted = {
        "=== Grep Search Results ===",
        "",
        -- Mostra informações específicas para sessões remotas
        _G.is_remote and ("🔗 Conexão Remota: " .. (_G.host or "Desconhecido")) or "💻 Sessão Local",
        _G.is_remote and ("📁 Diretório Remoto: " .. (_G.remote_dir or "Desconhecido")) or "📂 Projeto Local: " .. project_root,
        "",
        "🔍 Busca: " .. search_terms,
        "✅ Resultados: " .. (#results > 0 and #results or "0"),
        "",
        string.rep("─", 60),  -- Linha horizontal mais longa
        ""
    }

    -- Adicionar os resultados formatados
    for _, line in ipairs(results) do
        if _G.is_remote then
            -- Adiciona ícone de remoto aos resultados
            table.insert(formatted, "🖥️  " .. line)
        else
            table.insert(formatted, "📄 " .. line)
        end
    end

    -- Rodapé adaptado
    table.insert(formatted, "")
    table.insert(formatted, string.rep("─", 60))
    table.insert(formatted, _G.is_remote and "🚀 Pressione 'q' para fechar | Enter para abrir no remote"
                                      or "🚪 Pressione 'q' para fechar | Enter para abrir arquivo")

    return formatted
end
-- Função principal de busca que será chamada pelo init.lua
function M.search_in_project(search_terms, buffer)
    local project_root = find_project_root()
    -- Exibir mensagem de carregamento
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {
        "=== Grep Search ===",
        "",
        "Buscando por: " .. search_terms,
        "No diretório: " .. project_root,
        "",
        "Carregando..."
    })
    -- Debug adicional

    -- Executar busca em background (assíncrono)
    vim.defer_fn(function()
        local results = run_grep(search_terms, project_root, _G.is_remote)
        local formatted_results = format_results(search_terms, project_root, results)

        -- Atualizar o buffer com os resultados
        vim.schedule(function()
            vim.api.nvim_buf_set_lines(buffer, 0, -1, false, formatted_results)
            vim.notify("Busca concluída: " .. #results .. " resultado(s)", vim.log.levels.INFO)
        end)
    end, 100) -- Delay de 100ms para mostrar o loading
end

-- Função para buscar arquivos usando 'find'
function M.find_files_in_project(search_term, buffer)
    local project_root = find_project_root()

    -- Mensagem inicial
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {
        "=== Find Files ===",
        "",
        "Buscando arquivos contendo: " .. search_term,
        "No diretório: " .. project_root,
        "",
        "Carregando..."
    })

    vim.defer_fn(function()
        local find_cmd = string.format(
            'find "%s" -type f -iname "*%s*" 2>/dev/null',
            project_root,
            search_term
        )
        if _G.is_remote then
            find_cmd = string.format(
               'ssh %s \'find "%s" -not -path "*includes/*" -not -path "*vendor/*" -not -path "*storage/*" -not -path "*logs/*" -type f -iname "*%s*" 2>/dev/null\'',
               _G.host,
               _G.remote_dir,
               search_term
            )
            vim.notify(find_cmd, vim.log.INFO)
        end
        local output = vim.fn.system(find_cmd)
        local exit_code = vim.v.shell_error

        local results = {}

        if exit_code == 0 and output ~= "" then
            for line in output:gmatch("[^\r\n]+") do
                table.insert(results, line)
            end
        elseif exit_code == 1 or output == "" then
            results = { "Nenhum arquivo encontrado para: " .. search_term }
        else
            results = { "Erro ao executar find (código " .. exit_code .. ")" }
        end

        -- Atualizar o buffer com os resultados
        vim.schedule(function()
            local formatted = {
                "=== Find Files Results ===",
                "",
                "Projeto: " .. project_root,
                "Busca: " .. search_term,
                "Arquivos encontrados: " .. #results,
                "",
                string.rep("-", 50),
                "",
            }

            for _, line in ipairs(results) do
                table.insert(formatted, line)
            end

            table.insert(formatted, "")
            table.insert(formatted, string.rep("-", 50))
            table.insert(formatted, "Pressione 'q' para fechar | Enter para abrir arquivo")

            vim.api.nvim_buf_set_lines(buffer, 0, -1, false, formatted)
        end)
    end, 100)
end
-- Função utilitária para obter o diretório root (para usar em outros módulos)
function M.get_project_root()
    return find_project_root()
end

return M
