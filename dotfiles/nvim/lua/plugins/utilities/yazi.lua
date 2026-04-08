return {
   "mikavilpas/yazi.nvim",
   version = "*", -- use the latest stable version
   event = "VeryLazy",
   dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
   },
   opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      hooks = {
         yazi_opened = function( preselected_path, yazi_buffer_id, config )
            -- remove escaping the terminal for the yazi buffer
            vim.api.nvim_buf_del_keymap( 0, "t", "<Esc><Esc>" )
         end,
      },
      keymaps = {
         show_help = "<f1>",
      },
   },
}
