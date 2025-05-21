-- Utilitário para grep remoto no Neovim
-- Adicione este código ao seu init.lua

-- Função para extrair o host do caminho SCP atual
local function get_remote_host()
  local current_file = vim.fn.expand('%')
  if current_file:match("^scp://") then
    -- Extrai o host do caminho scp://user@host/path
    local host = current_file:match("scp://([^/]+)")
    return host
  end
  return nil
end

-- Função mais simples que usa vim.fn.system para executar comandos
-- Isso garante compatibilidade e resultados mais confiáveis
local function remote_grep(pattern, opts)
  opts = opts or {}

  -- Obter o host remoto da conexão atual
  local remote_host = get_remote_host()
  if not remote_host then
    vim.notify("Não está em uma conexão SCP remota", vim.log.levels.ERROR)
    return
  end

  -- Configurar diretório de busca (padrão é /var/www/html/tr2)
  local search_dir = opts.dir or "/var/www/html/tr2"

  -- Construir o comando grep com escapes adequados
  local grep_cmd = "grep -rn"

  -- Adicionar exclusões de diretórios
  local exclude_dirs = opts.exclude_dirs or {'includes', 'engine-tr2'}
  for _, dir in ipairs(exclude_dirs) do
    grep_cmd = grep_cmd .. " --exclude-dir=" .. vim.fn.shellescape(dir)
  end

  -- Adicionar include de arquivos
  local include_pattern = opts.include or "*.php*"
  grep_cmd = grep_cmd .. " --include=" .. vim.fn.shellescape(include_pattern)

  -- Adicionar o padrão de busca e o diretório
  grep_cmd = grep_cmd .. " " .. vim.fn.shellescape(pattern) .. " " .. vim.fn.shellescape(search_dir)

  -- Comando SSH completo
  local ssh_cmd = "ssh " .. remote_host .. " " .. vim.fn.shellescape(grep_cmd)

  -- Criar buffer temporário para os resultados
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_name(buf, 'Remote Grep: ' .. pattern)

  -- Abrir o buffer em uma nova janela
  vim.api.nvim_command('vsplit')
  vim.api.nvim_win_set_buf(0, buf)

  -- Mensagem de carregamento
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Executando grep remoto para: " .. pattern,
    "Comando: " .. ssh_cmd,
    "",
    "Aguardando resultados..."
  })

  -- Executar o comando de forma síncrona (mais confiável para este caso)
  vim.schedule(function()
    -- Executar o comando
    local output = vim.fn.system(ssh_cmd)
    local exit_code = vim.v.shell_error

    -- Processar a saída
    local results = {}
    if output and output ~= "" then
      results = vim.split(output, "\n")
      -- Remover linhas vazias do final
      while #results > 0 and results[#results] == "" do
        table.remove(results)
      end
    end

    -- Mostrar os resultados
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

    if exit_code == 0 then
      if #results > 0 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, results)

        -- Configurar o buffer para que os resultados possam ser clicados
        vim.api.nvim_buf_set_option(buf, 'filetype', 'grep')

        -- Configurar a quickfix list com os resultados
        vim.fn.setqflist({}, 'r', {title = 'Remote Grep: ' .. pattern, lines = results})
      else
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Nenhum resultado encontrado para: " .. pattern})
      end
    else
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "Comando falhou com código: " .. exit_code,
        "Saída:",
        output or "Nenhuma saída"
      })
    end
  end)
end

-- Versão alternativa usando o comando simples de sistema
local function remote_command(cmd, opts)
  opts = opts or {}

  -- Obter o host remoto da conexão atual
  local remote_host = get_remote_host()
  if not remote_host then
    vim.notify("Não está em uma conexão SCP remota", vim.log.levels.ERROR)
    return
  end

  -- Comando SSH completo
  local ssh_cmd = "ssh " .. remote_host .. " " .. vim.fn.shellescape(cmd)

  -- Criar buffer temporário para os resultados
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_name(buf, 'Remote Command: ' .. cmd:sub(1, 20) .. (cmd:len() > 20 and "..." or ""))

  -- Abrir o buffer em uma nova janela
  vim.api.nvim_command('vsplit')
  vim.api.nvim_win_set_buf(0, buf)

  -- Mensagem de carregamento
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Executando comando remoto: " .. cmd,
    "Comando SSH completo: " .. ssh_cmd,
    "",
    "Aguardando resultados..."
  })

  -- Executar o comando de forma síncrona
  vim.schedule(function()
    -- Executar o comando
    local output = vim.fn.system(ssh_cmd)
    local exit_code = vim.v.shell_error

    -- Processar a saída
    local results = {}
    if output and output ~= "" then
      results = vim.split(output, "\n")
      -- Remover linhas vazias do final
      while #results > 0 and results[#results] == "" do
        table.remove(results)
      end
    end

    -- Mostrar os resultados
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

    if exit_code == 0 then
      if #results > 0 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, results)
      else
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Comando executado com sucesso, sem saída."})
      end
    else
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "Comando falhou com código: " .. exit_code,
        "Saída:",
        output or "Nenhuma saída"
      })
    end
  end)
end

-- Comando do Neovim para execução fácil
vim.api.nvim_create_user_command('RemoteGrep', function(opts)
  remote_grep(opts.args, {})
end, {
  nargs = 1,
  desc = 'Executar grep remoto para o padrão especificado',
})

-- Comando do Neovim para comandos remotos gerais
vim.api.nvim_create_user_command('RemoteCmd', function(opts)
  remote_command(opts.args, {})
end, {
  nargs = 1,
  desc = 'Executar comando remoto',
})

-- Comando com opções completas
vim.api.nvim_create_user_command('RemoteGrepFull', function(opts)
  -- Parse arguments: RemoteGrepFull pattern dir=path include=*.ext exclude=dir1,dir2
  local args = vim.split(opts.args, ' ', {trimempty = true})
  local pattern = args[1] or ""

  local options = {}
  for i = 2, #args do
    local param = args[i]
    local key, value = param:match("([^=]+)=(.*)")
    if key and value then
      if key == "dir" then
        options.dir = value
      elseif key == "include" then
        options.include = value
      elseif key == "exclude" then
        options.exclude_dirs = vim.split(value, ',', {trimempty = true})
      end
    end
  end

  remote_grep(pattern, options)
end, {
  nargs = '+',
  desc = 'Executar grep remoto com opções personalizadas',
  complete = function()
    return {'pattern', 'dir=', 'include=', 'exclude='}
  end,
})

-- Mapeamentos de teclas sugeridos
vim.keymap.set('n', '<leader>rg', ':RemoteGrep ', {noremap = true, desc = 'Remote Grep'})
vim.keymap.set('n', '<leader>rf', ':RemoteGrepFull ', {noremap = true, desc = 'Remote Grep with options'})
vim.keymap.set('n', '<leader>rc', ':RemoteCmd ', {noremap = true, desc = 'Remote Command'})
