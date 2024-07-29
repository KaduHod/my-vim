local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.snippets = {
  lua = {
    s("doc", {
      t({ "/**", " * " }),
      i(1, "Descrição da função"),
      t({ "", " * ", " * @param " }),
      i(2, "param"),
      t({ "", " * @return " }),
      i(3, "return"),
      t({ "", " */" }),
    }),
  },
}
