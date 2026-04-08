return {
   "vague-theme/vague.nvim",
   opts = {
      transparent = false, -- don't set background
      -- disable bold/italic globally in `style`
      bold = true,
      italic = true,
      style = {
         -- "none" is the same thing as default. But "italic" and "bold" are also valid options
         boolean = "bold",
         number = "none",
         float = "none",
         error = "bold",
         comments = "italic",
         conditionals = "none",
         functions = "none",
         headings = "bold",
         operators = "none",
         strings = "italic",
         variables = "none",

         -- keywords
         keywords = "none",
         keyword_return = "italic",
         keywords_loop = "none",
         keywords_label = "none",
         keywords_exception = "none",

         -- builtin
         builtin_constants = "bold",
         builtin_functions = "none",
         builtin_types = "bold",
         builtin_variables = "none",
      },
   },
}
