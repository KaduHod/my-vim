-- ê a chave de API de um arquivo
local api_key = vim.fn.readfile(vim.fn.expand("/home/carlos/.config/nvim/companion.key"), "l")  -- lê o arquivo e pega a primeira linha
local deep_seek_key = api_key[1]
local anthropic_key = api_key[2]
-- Configuração do codecompanion com a chave da API
require("codecompanion").setup({
    strategies = {
        chat = {
            adapter = "deepseek", -- Usa o adaptador deepseek para chat
        },
        -- Adicione outras estratégias se necessário
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
        }
    }
})
-- Mapeamento de teclas
vim.keymap.set('n', '<leader>c', '<cmd>CodeCompanionChat<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>C', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true})
