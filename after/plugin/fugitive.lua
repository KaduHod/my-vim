vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git: Status' })
vim.keymap.set('n', '<leader>gf', '<cmd>Gdiffsplit<cr>', { desc = 'Git-Diff: Diff' })
vim.keymap.set('n', '<leader>gh', ':diffget<CR>]c', { desc = 'Git-Diff: Descartar hunk (pull do index)' })
vim.keymap.set('n', '<leader>ga', ':diffput<CR>]c', { desc = 'Git-Diff: Aceitar hunk e pular' })

-- 1. Abrir comparação: Pede o nome de um arquivo para comparar com o atual
vim.keymap.set('n', '<leader>fc', function()
    local file = vim.fn.input('Arquivo para comparar: ', '', 'file')
    if file ~= "" then
        vim.cmd('vsplit ' .. file) -- Abre em split vertical
        vim.cmd('windo diffthis')  -- Ativa o modo diff em ambas as janelas
    end
end, { desc = 'Diff: Comparar com outro arquivo' })

-- 2. PASSAR a mudança (Put): Envia do arquivo atual para o outro
vim.keymap.set('n', '<leader>dp', ':diffput<CR>', { desc = 'Diff: Enviar mudança (Put)' })

-- 3. TRAZER a mudança (Obtain): Puxa do outro arquivo para o atual
vim.keymap.set('n', '<leader>do', ':diffget<CR>', { desc = 'Diff: Trazer mudança (Get)' })

-- 4. SAIR do modo de comparação e fechar o split extra
vim.keymap.set('n', '<leader>dx', ':diffoff! | q<CR>', { desc = 'Diff: Fechar e sair' })

-- 5. Navegação rápida (opcional, mas ajuda muito)
vim.keymap.set('n', ']c', ']c', { desc = 'Diff: Próximo hunk' })
vim.keymap.set('n', '[c', '[c', { desc = 'Diff: Hunk anterior' })



