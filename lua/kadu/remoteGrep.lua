local function get_remote_host()
  local current_file = vim.fn.expand('%')
  if current_file:match("^scp://") then
    local host = current_file:match("scp://([^/]+)")
    return host
  end
  return nil
end

local function remote_grep(pattern, opts)
  opts = opts or {}
  local remote_host = get_remote_host()
  if not remote_host then
    vim.notify("NÃ£o estÃ¡ em uma conexÃ£o SCP remota", vim.log.levels.ERROR)
    return
  end
  local search_dir = opts.dir or "/var/www/html/tr2"
  local grep_cmd = "grep -rn"
  local exclude_dirs = opts.exclude_dirs or {'includes'}
  for _, dir in ipairs(exclude_dirs) do
    grep_cmd = grep_cmd .. " --exclude-dir=" .. vim.fn.shellescape(dir)
  end
  local include_pattern = opts.include or "*.php*"
  grep_cmd = grep_cmd .. " --include=" .. vim.fn.shellescape(include_pattern)
  grep_cmd = grep_cmd .. " " .. vim.fn.shellescape(pattern) .. " " .. vim.fn.shellescape(search_dir)
  local ssh_cmd = "ssh " .. remote_host .. " " .. vim.fn.shellescape(grep_cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_name(buf, 'Remote Grep: ' .. pattern)
  vim.api.nvim_command('vsplit')
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Executando grep remoto para: " .. pattern,
    "Comando: " .. ssh_cmd,
    "",
    "Aguardando resultados..."
  })

  -- Executar o comando de forma sÃ­ncrona (mais confiÃ¡vel para este caso)
  vim.schedule(function()
    -- Executar o comando
    local output = vim.fn.system(ssh_cmd)
    local exit_code = vim.v.shell_error

    -- Processar a saÃ­da
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
        "Comando falhou com cÃ³digo: " .. exit_code,
        "SaÃ­da:",
        grep_cmd,
        output or "Nenhuma saÃ­da"
      })
    end
  end)
end

-- VersÃ£o alternativa usando o comando simples de sistema
local function remote_command(cmd, opts)
  opts = opts or {}

  -- Obter o host remoto da conexÃ£o atual
  local remote_host = get_remote_host()
  if not remote_host then
    vim.notify("NÃ£o estÃ¡ em uma conexÃ£o SCP remota", vim.log.levels.ERROR)
    return
  end

  -- Comando SSH completo
  local ssh_cmd = "ssh " .. remote_host .. " " .. vim.fn.shellescape(cmd)

  -- Criar buffer temporÃ¡rio para os resultados
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

  -- Executar o comando de forma sÃ­ncrona
  vim.schedule(function()
    -- Executar o comando
    local output = vim.fn.system(ssh_cmd)
    local exit_code = vim.v.shell_error

    -- Processar a saÃ­da
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
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Comando executado com sucesso, sem saÃ­da."})
      end
    else
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "Comando falhou com cÃ³digo: " .. exit_code,
        "SaÃ­da:",
        output or "Nenhuma saÃ­da"
      })
    end
  end)
end

-- Comando do Neovim para execuÃ§Ã£o fÃ¡cil
vim.api.nvim_create_user_command('RemoteGrep', function(opts)
  remote_grep(opts.args, {})
end, {
  nargs = 1,
  desc = 'Executar grep remoto para o padrÃ£o especificado',
})

-- Comando do Neovim para comandos remotos gerais
vim.api.nvim_create_user_command('RemoteCmd', function(opts)
  remote_command(opts.args, {})
end, {
  nargs = 1,
  desc = 'Executar comando remoto',
})

-- Comando com opÃ§Ãµes completas
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
  desc = 'Executar grep remoto com opÃ§Ãµes personalizadas',
  complete = function()
    return {'pattern', 'dir=', 'include=', 'exclude='}
  end,
})

-- Mapeamentos de teclas sugeridos
vim.keymap.set('n', '<leader>rg', ':RemoteGrep ', {noremap = true, desc = 'Remote Grep'})
vim.keymap.set('n', '<leader>rf', ':RemoteGrepFull ', {noremap = true, desc = 'Remote Grep with options'})
vim.keymap.set('n', '<leader>rc', ':RemoteCmd ', {noremap = true, desc = 'Remote Command'})



local function remote_find(name_pattern, opts)
  opts = opts or {}

  -- Get remote host from current connection
  local remote_host = get_remote_host()
  if not remote_host then
    vim.notify("Não está em uma conexão SCP remota", vim.log.levels.ERROR)
    return
  end

  -- Set search directory (default is /var/www/html/tr2)
  local search_dir = opts.dir or "/var/www/html/tr2"
  local find_cmd = "find " .. vim.fn.shellescape(search_dir)
  if opts.type then
    find_cmd = find_cmd .. " -type " .. opts.type
  end
  find_cmd = find_cmd .. " -name " .. vim.fn.shellescape(name_pattern)
  if opts.maxdepth then
    find_cmd = find_cmd .. " -maxdepth " .. opts.maxdepth
  end
  local exclude_dirs = opts.exclude_dirs or {'includes', 'engine-tr2'}
  for _, dir in ipairs(exclude_dirs) do
    find_cmd = find_cmd .. " -not -path " .. vim.fn.shellescape("*/" .. dir .. "/*")
  end
  local ssh_cmd = "ssh " .. remote_host .. " " .. vim.fn.shellescape(find_cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_name(buf, 'Remote Find: ' .. name_pattern)
  vim.api.nvim_command('vsplit')
  vim.api.nvim_win_set_buf(0, buf)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Executando find remoto para: " .. name_pattern,
    "Comando: " .. ssh_cmd,
    "",
    "Aguardando resultados..."
  })
  vim.schedule(function()
    local output = vim.fn.system(ssh_cmd)
    local exit_code = vim.v.shell_error

    -- Process output
    local results = {}
    if output and output ~= "" then
      results = vim.split(output, "\n")
      while #results > 0 and results[#results] == "" do
        table.remove(results)
      end
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

    if exit_code == 0 then
      if #results > 0 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, results)
        vim.api.nvim_buf_set_option(buf, 'filetype', 'find')
        vim.fn.setqflist({}, 'r', {title = 'Remote Find: ' .. name_pattern, lines = results})
      else
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Nenhum resultado encontrado para: " .. name_pattern})
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
vim.api.nvim_create_user_command('RemoteFind', function(opts)
  remote_find(opts.args, {})
end, {
  nargs = 1,
  desc = 'Executar find remoto para procurar arquivos/diretórios',
})

vim.api.nvim_create_user_command('RemoteFindFull', function(opts)
  local args = vim.split(opts.args, ' ', {trimempty = true})
  local pattern = args[1] or ""

  local options = {}
  for i = 2, #args do
    local param = args[i]
    local key, value = param:match("([^=]+)=(.*)")
    if key and value then
      if key == "dir" then
        options.dir = value
      elseif key == "type" then
        options.type = value
      elseif key == "maxdepth" then
        options.maxdepth = value
      elseif key == "exclude" then
        options.exclude_dirs = vim.split(value, ',', {trimempty = true})
      end
    end
  end
  local log_msg = "Executing RemoteFind with:"
  log_msg = log_msg .. "\n  pattern: " .. pattern
  for k, v in pairs(options) do
    if type(v) == "table" then
      log_msg = log_msg .. "\n  " .. k .. ": " .. table.concat(v, ", ")
    else
      log_msg = log_msg .. "\n  " .. k .. ": " .. v
    end
  end
  vim.notify(log_msg, vim.log.levels.INFO)

  remote_find(pattern, options)
end, {
  nargs = '+',
  desc = 'Executar find remoto com opções personalizadas',
  complete = function()
    return {'pattern', 'dir=', 'type=', 'maxdepth=', 'exclude='}
  end,
})
vim.keymap.set('n', '<leader>rf', ':RemoteFind ', {noremap = true, desc = 'Remote Find'})




