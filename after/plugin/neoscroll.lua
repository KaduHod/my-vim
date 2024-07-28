require('neoscroll').setup({
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,           -- Ocultar o cursor enquanto rola
    stop_eof = true,              -- Parar na última linha
    use_local_scrolloff = false,  -- Usar valor local de scrolloff em vez de global
    respect_scrolloff = false,    -- Respeitar o valor de scrolloff ao rolar
    cursor_scrolls_alone = true,  -- O cursor se move sozinho quando a janela rola
    easing_function = 'quadratic' -- Função de suavização para rolagem
})
