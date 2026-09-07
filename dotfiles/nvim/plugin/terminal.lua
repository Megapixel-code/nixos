local term_state = {
   win = -1,
   buf = -1,
};

local create_win = function()
   if ! vim.api.nvim_buf_is_valid( term_state.buf ) then
      term_state.buf = vim.api.nvim_create_buf( true, true );
   end;

   term_state.win = vim.api.nvim_open_win( term_state.buf, true, {
      split = "below",
      win = -1,
      height = 15,
   } );

   if vim.bo[term_state.buf].buftype ~= "terminal" then
      vim.cmd.term();
   end;
end;

local toggle_terminal = function()
   if vim.api.nvim_win_is_valid( term_state.win ) then
      vim.api.nvim_win_hide( term_state.win );
   else
      create_win();
   end;
end;

vim.api.nvim_create_user_command( "ToggleTerminal", toggle_terminal, {} );
vim.keymap.set( "n", "<leader>t<BS>", toggle_terminal, { desc = "Toggle terminal" } );

local autocmd_group = vim.api.nvim_create_augroup( "CustomTerm", { clear = true } );
vim.api.nvim_create_autocmd( "TermOpen", {
   group = autocmd_group,
   callback = function()
      vim.api.nvim_buf_set_keymap( 0, "t", "<C-H>", "<C-\\><C-n>", { desc = "Exit terminal mode" } );
      vim.opt.number = false;
      vim.opt.relativenumber = false;
   end,
} );
