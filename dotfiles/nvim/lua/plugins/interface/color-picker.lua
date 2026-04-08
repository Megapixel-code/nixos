return {
   "uga-rosa/ccc.nvim",
   config = function()
      local ccc = require( "ccc" )

      ccc.setup( {
         highlighter = {
            auto_enable = true, -- start the highlighter on file open
            excludes = {},      -- ft to deactivate highlight
         },
         outputs = {
            ccc.output.hex,
            ccc.output.hex_short,
            ccc.output.css_rgb,
            ccc.output.css_rgba,
            ccc.output.css_hsl,
         },
         convert = {
            { ccc.picker.hex,     ccc.output.css_rgb },
            { ccc.picker.css_rgb, ccc.output.css_hsl },
            { ccc.picker.css_hsl, ccc.output.hex },
         },
         pickers = {
            ccc.picker.hex,
            ccc.picker.css_rgb,
            ccc.picker.css_hsl,
            ccc.picker.css_hwb,
            ccc.picker.css_lab,
            ccc.picker.css_lch,
            ccc.picker.css_oklab,
            ccc.picker.css_oklch,

            ccc.picker.custom_entries( { -- custom pickers when a word apears
               red = "#FF0000",
               RED = "#FF0000",
               green = "#00FF00",
               GREEN = "#00FF00",
               blue = "#0000FF",
               BLUE = "#0000FF",
               yellow = "#FFFF00",
               YELLOW = "#FFFF00",
               cyan = "#00FFFF",
               CYAN = "#00FFFF",
               purple = "#FF00FF",
               PURPLE = "#FF00FF",
            } ),
         },
      } )
      -- set the hex to uppercase
      ccc.output.hex.setup( { uppercase = true } )
      ccc.output.hex_short.setup( { uppercase = true } )
   end,
}
