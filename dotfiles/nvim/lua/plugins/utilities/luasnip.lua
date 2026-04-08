return {
   "L3MON4D3/LuaSnip",
   -- version = "v2.*", -- enable this back if problems

   build = "make install_jsregexp",

   opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
   },
}
