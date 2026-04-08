return {
   "folke/flash.nvim",
   event = "VeryLazy",
   --- @type Flash.Config
   opts = {
      search = {
         multi_window = true, -- search/jump in all windows
         forward = true,      -- search direction
         wrap = true,         -- when `false`, find only matches in the given direction

         --- @type Flash.Pattern.Mode
         -- Each mode will take ignorecase and smartcase into account.
         -- * exact: exact match
         -- * search: regular search
         -- * fuzzy: fuzzy search
         -- * fun(str): custom function that returns a pattern
         --   For example, to only match at the beginning of a word:
         --   mode = function(str)
         --     return "\\<" .. str
         --   end,
         mode = "fuzzy",
      },
      label = {
         -- flash tries to re-use labels that were already assigned to a position,
         -- when typing more characters. By default only lower-case labels are re-used.
         reuse = "lowercase", --- @type "lowercase" | "all" | "none"
         distance = true,     -- for the current window, label targets closer to the cursor first

         rainbow = {
            enabled = true, -- Enable this to use rainbow colors to highlight labels
            shade = 5,      -- number between 1 and 9
         },
      },
      highlight = {
         backdrop = true, -- show a backdrop with hl FlashBackdrop
         matches = true,  -- Highlight the search matches
         groups = {
            match = "FlashMatch",
            current = "FlashCurrent",
            backdrop = "FlashBackdrop",
            label = "FlashLabel",
         },
      },
      modes = {
         -- options used when flash is activated through
         -- `f`, `F`, `t`, `T`, `;` and `,` motions
         char = {
            enabled = true,
            multi_line = false, -- set to `false` to use the current line only
            search = { wrap = false },
            highlight = { backdrop = false },
         },
      },

      -- options for the floating window that shows the prompt,
      -- for regular jumps
      -- `require("flash").prompt()` is always available to get the prompt text
      prompt = {
         enabled = true,
         prefix = { { "", "FlashPromptIcon" } },
      },
   },

   keys = {
      { "zk", mode = { "n", "x", "o" }, function() require( "flash" ).jump() end, desc = "Flash" },
   },
}
