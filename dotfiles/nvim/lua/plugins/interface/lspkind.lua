return {
   "onsails/lspkind.nvim",
   opts = {
      -- defines how annotations are shown
      -- default: symbol
      -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
      mode = "symbol",

      preset = "default", -- when using nerfonts

      -- override preset symbols
      -- default: {}
      symbol_map = {
         Text = "󰉿",
         Method = "󰆧",
         Function = "󰊕",
         Constructor = "",
         Field = "󰜢",
         Variable = "󰀫",
         Class = "󰠱",
         Interface = "",
         Module = "",
         Property = "󰜢",
         Unit = "󰑭",
         Value = "󰎠",
         Enum = "",
         Keyword = "󰌋",
         Snippet = "",
         Color = "󰏘",
         File = "󰈙",
         Reference = "󰈇",
         Folder = "󰉋",
         EnumMember = "",
         Constant = "󰏿",
         Struct = "󰙅",
         Event = "",
         Operator = "󰆕",
         TypeParameter = "",
      },
   },
}
