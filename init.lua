require("kadu")
print('Arquivos carregados')

vim.cmd("set relativenumber")
vim.cmd("set nowrap")

vim.cmd("set foldmethod=syntax")
vim.cmd("set foldlevelstart=0")
vim.cmd("set tabstop=4 shiftwidth=4 expandtab")
vim.cmd("set number")
vim.opt.clipboard = "unnamedplus"
vim.cmd("let g:netrw_liststyle = 3")
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = { "*" },
--   command = [[%s/\s\+$//e]],
-- })
--
vim.g.clipboard = {
    name = "macos-clipboard",
    copy = {
        ["+"] = "pbcopy",
        ["*"] = "pbcopy",
    },
    paste = {
        ["+"] = "pbpaste",
        ["*"] = "pbpaste",
    },
}

vim.cmd([[
  highlight RenderMarkdownH1Bg guibg=#FF0000
  highlight RenderMarkdownH2Bg guibg=#00FF00
  highlight RenderMarkdownH3Bg guibg=#0000FF
  highlight RenderMarkdownH4Bg guibg=#FFFF00
  highlight RenderMarkdownH5Bg guibg=#FF00FF
  highlight RenderMarkdownH6Bg guibg=#00FFFF
]])
local function getRemotePwd()
    if not _G.host then
        return nil
    end

    local cmd = string.format("ssh %s 'pwd'", _G.host)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()

    -- Clean up the result (remove newlines and extra spaces)
    result = result:gsub("[\n\r]", ""):gsub("^%s*(.-)%s*$", "%1")

    return result
end
local function checkRemote()
  -- Itera por todos os argumentos passados ao Neovim
  for _, arg in ipairs(vim.v.argv) do
    if arg:match("^scp://") then  -- Verifica se o argumento começa com scp://
      print("🔍 Sessão remota SCP detectada no argumento:", arg)

      -- Extrai informações úteis (opcional)
      local host = arg:match("^scp://([^/]+)/")
      local path = arg:match("^scp://[^/]+/(.+)")

      print(string.format(
        "📡 Host: %s\n📂 Caminho remoto: %s",
        host or "não identificado",
        path or "não especificado"
      ))
      _G.is_remote = true
      _G.host = host
      _G.remote_dir = path
      _G.home_dir = getRemotePwd()
      _G.os = "w"
      print("🖥️ remote home ", _G.home_dir)
      return  -- Sai após encontrar o primeiro argumento SCP
    end
      _G.is_remote = false
  end

  print("🖥️  Sessão local detectada (nenhum argumento SCP encontrado)")
end
checkRemote()
checkRemote()
--[[vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        if vim.bo.fileencoding ~= 'latin1' then
            vim.bo.fileencoding = 'latin1'
            vim.cmd('e!')
        end
    end
})
vim.o.fileencoding = 'latin1'
vim.o.fileencodings = 'latin1'
vim.bo.fileencoding = 'latin1']]--
local args = vim.fn.argv()
if #args > 0 then
    print("Argumentos recebidos pelo Neovim:")
    for i, arg in ipairs(args) do
        print(string.format("[%d]: %s", i, arg))
    end
else
    print("Nenhum argumento de arquivo foi detectado.")
end

