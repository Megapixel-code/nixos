return {
   "projekt0n/github-nvim-theme",
   name = "github-theme",
   opts = {
      options = {
         hide_end_of_buffer = false, -- Hide the '~' character at the end of the buffer for a cleaner look
         hide_nc_statusline = true,  -- Override the underline style for non-active statuslines
         transparent = false,        -- Disable setting bg (make neovim's background transparent)
         terminal_colors = true,     -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
         dim_inactive = true,        -- Non focused panes set to alternative background
         module_default = true,      -- Default enable value for modules
         styles = {                  -- Style to be applied to different syntax groups
            comments = "italic",     -- Value is any valid attr-list value `:help attr-list`
            functions = "NONE",
            keywords = "NONE",
            variables = "NONE",
            conditionals = "NONE",
            constants = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
         },
         inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
         },
         darken = { -- Darken floating windows and sidebar-like windows
            floats = true,
            sidebars = {
               enable = true,
            },
         },
         modules = { -- List of various plugins and additional options
            "telescope",
         },
      },
      palettes = {},
      specs = {},
      groups = {},
   },
}
