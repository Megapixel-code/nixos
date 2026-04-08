local function apply_ts_indent_if_blank()
   local buf = vim.api.nvim_get_current_buf()
   local lnum = vim.api.nvim_win_get_cursor( 0 )[1]
   local line_content = vim.api.nvim_get_current_line()

   if line_content ~= "" then
      return
   end

   local indentexpr = vim.bo.indentexpr
   if indentexpr == "" or indentexpr == nil then
      return
   end

   local temp_lnum = vim.v.lnum
   vim.v.lnum = lnum
   local indent = vim.fn.eval( vim.bo.indentexpr )
   vim.v.lnum = temp_lnum

   if indent > 0 then
      vim.api.nvim_buf_set_lines( buf, lnum - 1, lnum, false, { string.rep( " ", indent ) } )
      vim.api.nvim_feedkeys( vim.api.nvim_replace_termcodes( "<End>", true, false, true ), "n", true )
   end
end

local function remove_space_chars_empty_lines()
   local buf = vim.api.nvim_get_current_buf()
   local lnum = vim.api.nvim_win_get_cursor( 0 )[1]
   local line_content = vim.api.nvim_get_current_line()

   if line_content == "" then
      return
   end

   for char in string.gmatch( line_content, "." ) do
      if char ~= " " then
         return
      end
   end

   vim.api.nvim_buf_set_lines( buf, lnum - 1, lnum, false, { "" } )
end

vim.api.nvim_create_autocmd( "InsertEnter", {
   callback = apply_ts_indent_if_blank,
} )

vim.api.nvim_create_autocmd( "InsertLeave", {
   callback = remove_space_chars_empty_lines,
} )
