vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git: Status' })
vim.keymap.set('n', '<leader>gf', '<cmd>Gdiffsplit<cr>', { desc = 'Git-Diff: Diff' })
vim.keymap.set('n', '<leader>gh', ':diffget<CR>]c', { desc = 'Git-Diff: Descartar hunk (pull do index)' })
vim.keymap.set('n', '<leader>ga', ':diffput<CR>]c', { desc = 'Git-Diff: Aceitar hunk e pular' })

-- 1. Abrir comparação: Pede o nome de um arquivo para comparar com o atual
-- vim.keymap.set('n', '<leader>fc', function()
--     local file = vim.fn.input('Arquivo para comparar: ', '', 'file')
--     if file ~= "" then
--         vim.cmd('vsplit ' .. file) -- Abre em split vertical
--         vim.cmd('windo diffthis')  -- Ativa o modo diff em ambas as janelas
--     end
-- end, { desc = 'Diff: Comparar com outro arquivo' })
--
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fc', function()
  local search_dirs = {
    vim.fn.getcwd(),
    vim.fn.expand("~/Library/Application Support/Cyberduck"),
    "/private/var/folders"
  }

  builtin.find_files({
    path_display = { "truncate" },
    prompt_title = "Diff com arquivo",
    search_dirs = search_dirs,
    hidden = true, -- importante pra pegar arquivos temporários
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      local function diff_with_file()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection and selection.path then
          vim.cmd('vsplit ' .. vim.fn.fnameescape(selection.path))
          vim.cmd('windo diffthis')
        end
      end

      map('i', '<CR>', diff_with_file)
      map('n', '<CR>', diff_with_file)

      return true
    end,
  })
end, { desc = 'Diff: Diff com arquivo (inclui Cyberduck)' })-- 2. PASSAR a mudança (Put): Envia do arquivo atual para o outro
vim.keymap.set('n', '<leader>dp', ':diffput<CR>', { desc = 'Diff: Enviar mudança (Put)' })

-- 3. TRAZER a mudança (Obtain): Puxa do outro arquivo para o atual
vim.keymap.set('n', '<leader>do', ':diffget<CR>', { desc = 'Diff: Trazer mudança (Get)' })

-- 4. SAIR do modo de comparação e fechar o split extra
vim.keymap.set('n', '<leader>dx', ':diffoff! | q<CR>', { desc = 'Diff: Fechar e sair' })

-- 5. Navegação rápida (opcional, mas ajuda muito)
vim.keymap.set('n', ']c', ']c', { desc = 'Diff: Próximo hunk' })
vim.keymap.set('n', '[c', '[c', { desc = 'Diff: Hunk anterior' })



