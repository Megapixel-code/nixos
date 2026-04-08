return {
   "thesimonho/kanagawa-paper.nvim",

   opts = {
      undercurl = true,       -- enable undercurls for underlined text
      transparent = false,    -- transparent background
      gutter = false,         -- highlight background for the left gutter
      diag_background = true, -- background for diagnostic virtual text
      dim_inactive = true,    -- dim inactive windows.
      terminal_colors = true, -- set colors for terminal buffers

      styles = {
         comment = { italic = true },                  -- style for comments
         functions = { italic = false },               -- style for functions
         keyword = { italic = false, bold = false },   -- style for keywords
         statement = { italic = false, bold = false }, -- style for statements
         type = { italic = false },                    -- style for types
      },

      -- adjust overall color balance for each theme [-1, 1]
      color_offset = {
         ink = { brightness = 0, saturation = 0 },
         canvas = { brightness = 0, saturation = 0 },
      },

      -- manually enable/disable individual plugins.
      -- check the `groups/plugins` directory for the exact names
      plugins = {},
   },
}
