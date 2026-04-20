return {
   "kevinhwang91/nvim-ufo",
   event = "VeryLazy",
   dependencies = {
      "kevinhwang91/promise-async",
   },
   init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"
      vim.o.foldenable = true
   end,
   opts = {
      provider_selector = function()
         return { "lsp", "indent" }
      end,
   },
}
