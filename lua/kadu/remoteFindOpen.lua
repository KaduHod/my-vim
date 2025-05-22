local M = {}

function M.get_remote_host()
  local current_file = vim.fn.expand('%')
  if current_file:match("^scp://") then
    return current_file:match("scp://([^/]+)")
  end
  return nil
end

function M.open_remote_file()
  local line = vim.api.nvim_get_current_line()
  if not line or line == "" then return end

  line = line:gsub("^%s+", ""):gsub("%s+$", "")
  local remote_host = M.get_remote_host()
  if not remote_host then
    vim.notify("Not in a remote SCP connection", vim.log.levels.ERROR)
    return
  end

  local file_path = "scp://" .. remote_host .. line
  vim.cmd("edit " .. vim.fn.fnameescape(file_path))
end

function M.remote_find_open(name_pattern, opts)
  opts = opts or {}
  local remote_host = M.get_remote_host()
  if not remote_host then
    vim.notify("Not in a remote SCP connection", vim.log.levels.ERROR)
    return
  end

  local search_dir = opts.dir or "/var/www/html/tr2"
  local find_cmd = {"find", vim.fn.shellescape(search_dir), "-regextype", "posix-extended", "-regex", name_pattern}

  if opts.type then
    table.insert(find_cmd, "-type")
    table.insert(find_cmd, opts.type)
  end

  if opts.maxdepth then
    table.insert(find_cmd, "-maxdepth")
    table.insert(find_cmd, opts.maxdepth)
  end

  local exclude_dirs = opts.exclude_dirs or {'includes', 'engine-tr2'}
  for _, dir in ipairs(exclude_dirs) do
      table.insert(find_cmd, "!")
      table.insert(find_cmd, "-path")
      table.insert(find_cmd, vim.fn.shellescape(string.format("*/%s/*", dir)))
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_name(buf, 'Remote Find (Open): ' .. name_pattern)
  vim.api.nvim_command('vsplit')
  vim.api.nvim_win_set_buf(0, buf)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Running remote find for: " .. name_pattern,
    "Command: ssh " .. remote_host .. " " .. table.concat(find_cmd, " "),
    "",
    "Waiting for results...",
    "",
    "Press <Enter> or 'o' to open a file"
  })

  -- Build the SSH command parts
  local ssh_cmd = {"ssh", remote_host}
  for _, part in ipairs(find_cmd) do
    table.insert(ssh_cmd, part)
  end
  vim.notify("Running SSH command: " .. table.concat(ssh_cmd, " "), vim.log.levels.INFO)

  vim.fn.jobstart(ssh_cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then return end
      local results = {}
      for _, line in ipairs(data) do
        if line ~= "" then table.insert(results, line) end
      end

      vim.schedule(function()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
        if #results > 0 then
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, results)
          vim.api.nvim_buf_set_option(buf, 'filetype', 'find')
          vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>lua require("kadu.remoteFindOpen").open_remote_file()<CR>',
            {noremap = true, silent = true})
          vim.api.nvim_buf_set_keymap(buf, 'n', 'o', '<cmd>lua require("kadu.remoteFindOpen").open_remote_file()<CR>',
            {noremap = true, silent = true})
        else
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"No results found", "Command used: " .. table.concat(find_cmd, " ")})
        end
      end)
    end,
    on_stderr = function(_, err)
      vim.schedule(function()
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, {"Error:"})
        for _, line in ipairs(err) do
          if line ~= "" then
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
          end
        end
      end)
    end
  })
end
vim.api.nvim_create_user_command('RemoteFindOpen', function(opts)
  require('kadu.remoteFindOpen').remote_find_open(opts.args, {})
end, {nargs = 1, desc = 'Remote find with file opening'})

vim.api.nvim_create_user_command('RemoteFindOpenFull', function(opts)
  local args = vim.split(opts.args, ' ', {trimempty = true})
  local pattern = args[1] or ""
  local options = {}

  for i = 2, #args do
    local key, value = args[i]:match("([^=]+)=(.*)")
    if key and value then
      if key == "dir" then options.dir = value
      elseif key == "type" then options.type = value
      elseif key == "maxdepth" then options.maxdepth = value
      elseif key == "exclude" then options.exclude_dirs = vim.split(value, ',', {trimempty = true})
      end
    end
  end

  require('kadu.remoteFindOpen').remote_find_open(pattern, options)
end, {
  nargs = '+',
  desc = 'Remote find with options and file opening',
  complete = function() return {'pattern', 'dir=', 'type=', 'maxdepth=', 'exclude='} end
})

vim.keymap.set('n', '<leader>ro', ':RemoteFindOpen ', {noremap = true, desc = 'Remote Find and Open'})

return M
