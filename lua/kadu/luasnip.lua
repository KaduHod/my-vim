local ls = require 'luasnip'
ls.filetype_extend("ejs", { "html" })
ls.filetype_extend("tmpl", { "html" })
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
ls.add_snippets("html", {
  s("pr", {
    t("<%= "),
    i(1),
    t(" %>"),
  }),
})
