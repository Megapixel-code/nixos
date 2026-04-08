-- help ibl config
return {
   "lukas-reineke/indent-blankline.nvim",
   main = "ibl",
   opts = {
      scope = {
         show_start = false, -- shows an underline on the first line of the scope
         show_end = false,   -- shows an underline on the last line of the scope
      },
      exclude = {
         filetypes = {
            "lspinfo",
            "packer",
            "checkhealth",
            "help",
            "man",
            "gitcommit",
            "TelescopePrompt",
            "TelescopeResults",
            "text",
         },
         buftypes = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
         },
      },
   },
}
