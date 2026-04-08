local term_state = {
   win = -1,
   buf = -1,
}

local create_win = function()
   local buf = nil
   if vim.api.nvim_buf_is_valid( term_state.buf ) then
      buf = term_state.buf
   else
      buf = vim.api.nvim_create_buf( true, true )
      term_state.buf = buf
   end

   term_state.win = vim.api.nvim_open_win( buf, true, {
      split = "below",
      win = -1,
      height = 15,
   } )

   if vim.bo[term_state.buf].buftype ~= "terminal" then
      vim.cmd.term()
   end
end

local toggle_terminal = function()
   if vim.api.nvim_win_is_valid( term_state.win ) then
      vim.api.nvim_win_hide( term_state.win )
   else
      create_win()
   end
end

vim.api.nvim_create_user_command( "ToggleTerminal", toggle_terminal, {} )
