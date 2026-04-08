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
            layout_config = {
               vertical = {
                  prompt_position = "bottom",
                  preview_height = .6,
                  height = 0.8,
                  width = 0.7,
               },
               horizontal = {
                  prompt_position = "bottom",
                  preview_width = .6,
                  height = 0.8,
                  width = 0.8,
               },
            },
            prompt_prefix = "λ ",
            selection_caret = " ",
            borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

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
