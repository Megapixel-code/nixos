return {
   "RRethy/base16-nvim",
   config = function()
      require( "base16-colorscheme" ).with_config( {
         telescope = false,
         telescope_borders = true,
      } )
   end,
}
