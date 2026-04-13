return {
   "nvim-telescope/telescope.nvim",
   version = "*",
   dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
   },
   config = function()
      local telescope = require( "telescope" )

      telescope.setup( {
         defaults = {
            layout_strategy = "flex",
            sorting_strategy = "ascending",
            layout_config = {
               prompt_position = "top",
               height = 100000,
               width = 100000,
               vertical = {
                  preview_height = .6,
                  mirror = true,
               },
               horizontal = {
                  preview_width = .6,
               },
            },
            prompt_prefix = "λ ",
            selection_caret = " ",
            path_display = { "truncate" },
            borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            preview = { treesitter = true },

            file_ignore_patterns = {
               ".git/",
               "%.pdf",
               "%.mp4",
               "%.mkv",
               "%.png",
            },
         },

         pickers = {
            find_files = {
               hidden = true,
            },
         },
         fzf = {},
      } )

      telescope.load_extension( "fzf" )
   end,
}
