-- ê a chave de API de um arquivo
local api_key = vim.fn.readfile(vim.fn.expand("/Users/carlosribas/.config/nvim/companion.key"), "l")  -- lê o arquivo e pega a primeira linha
local deep_seek_key = api_key[1]
local anthropic_key = api_key[2]
-- Configuração do codecompanion com a chave da API
require("codecompanion").setup({
    opts = {
        strategies = {
            chat = { enabled = true },
            commit = {
                enabled = false,
                provider = function()
                    -- Aqui vamos capturar o git diff manualmente
                    local ok, Job = require("plenary.job")
                    if not ok then
                        vim.notify("plenary.job not found", vim.log.levels.ERROR)
                        return nil
                    end
                    local diff = ""

                    Job:new({
                        command = "git",
                        args = { "diff", "--cached" }, -- <-- usa o staged
                        on_exit = function(j, _)
                            diff = table.concat(j:result(), "\n")
                        end,
                    }):sync()

                    if diff == "" then
                        Job:new({
                            command = "git",
                            args = { "diff" }, -- <-- se não houver staged, pega unstaged
                            on_exit = function(j, _)
                                diff = table.concat(j:result(), "\n")
                            end,
                        }):sync()
                    end

                    if diff == "" then
                        vim.notify("[CodeCompanion] Nenhum diff encontrado.", vim.log.levels.WARN)
                        return nil
                    end

                    return {
                        context = "Please generate a commit message based on the following diff:",
                        code = diff,
                    }
                end,
            },
        },
    },
    strategies = {
        chat = {
            adapter = "deepseek", -- Usa o adaptador deepseek para chat
            slash_commands = {
                ["file"] = {
                    -- Location to the slash command in CodeCompanion
                    callback = "strategies.chat.slash_commands.file",
                    description = "Select a file using Telescope",
                    opts = {
                        provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                        contains_code = true,
                    },
                },
            },
        },
        inline = {
            adapter = "deepseek",
            keymaps = {
                accept_change = {
                    modes = { n = "ga" },
                    description = "Accept the suggested change",
                },
                reject_change = {
                    modes = { n = "gr" },
                    description = "Reject the suggested change",
                },
            },
            layout = "vertical", -- vertical|horizontal|buffer
        },
    },
    adapters = {
        deepseek = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                    url = "https://api.deepseek.com",
                    api_key = deep_seek_key,
                    chat_url = "/v1/chat/completions",
                },
                headers = {
                    ["Content-Type"] = "application/json",
                    ["Authorization"] = "Bearer ${api_key}",
                },
                schema = {
                    model = {
                        default = "deepseek-chat",  -- define llm model to be used
                    },
                    temperature = {
                        order = 2,
                        mapping = "parameters",
                        type = "number",
                        optional = true,
                        default = 0.8,
                        desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
                        validate = function(n)
                            return n >= 0 and n <= 2, "Must be between 0 and 2"
                        end,
                    },
                    max_completion_tokens = {
                        order = 3,
                        mapping = "parameters",
                        type = "integer",
                        optional = true,
                        default = nil,
                        desc = "An upper bound for the number of tokens that can be generated for a completion.",
                        validate = function(n)
                            return n > 0, "Must be greater than 0"
                        end,
                    },
                    stop = {
                        order = 4,
                        mapping = "parameters",
                        type = "string",
                        optional = true,
                        default = nil,
                        desc = "Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.",
                        validate = function(s)
                            return s:len() > 0, "Cannot be an empty string"
                        end,
                    },
                    logit_bias = {
                        order = 5,
                        mapping = "parameters",
                        type = "map",
                        optional = true,
                        default = nil,
                        desc = "Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.",
                        subtype_key = {
                            type = "integer",
                        },
                        subtype = {
                            type = "integer",
                            validate = function(n)
                                return n >= -100 and n <= 100, "Must be between -100 and 100"
                            end,
                        },
                    }
                },
            })
        end,
        anthropic = function()
            return require("codecompanion.adapters").extend('anthropic',{
                env = {
                    api_key = anthropic_key
                }
            })
        end,
    },
    display = {
        chat = {
            window = {
                layout = "vertical",
                position = "right",
                height = 1,
                width = 0.3
            }
        },
        diff = {
            enabled = true,
            close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
            layout = "vertical", -- vertical|horizontal split for default provider
            opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
            provider = "default", -- default|mini_diff
        },
    }
})
-- Mapeamento de teclas
vim.keymap.set('n', '<leader>c', '<cmd>CodeCompanionChat<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>C', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true})
-- vim.keymap.set('v', '<leader>rf', ':CodeCompanion Refactor<CR>', { desc = 'Refatorar seleção' })
--vim.keymap.set('v', '<leader>im', ':CodeCompanion Improve<CR>', { desc = 'Melhorar seleção' })
--vim.keymap.set('v', '<leader>fx', ':CodeCompanion Fix<CR>', { desc = 'Corrigir seleção' })
--vim.keymap.set('v', '<leader>ex', ':CodeCompanion Explain<CR>', { desc = 'Explicar seleção' })
--vim.keymap.set('v', '<leader>ts', ':CodeCompanion Tests<CR>', { desc = 'Gerar testes para seleção' })
--vim.keymap.set('v', '<leader>cc', function()
--  require('codecompanion').chat()
--end, { desc = "Abrir chat com seleção" })
