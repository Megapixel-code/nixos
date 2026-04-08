-- ~~~ [[ Autocommands ]] ~~~

-- [[ highlight when yanking text ]]
vim.api.nvim_create_autocmd( "TextYankPost", {
   desc = "Highlight when yanking text",
   group = vim.api.nvim_create_augroup( "kickstart-highlight-yank", { clear = true } ),
   callback = function()
      vim.hl.on_yank()
   end,
} )

-- [[ Auto-format ("lint") on save ]]
vim.api.nvim_create_autocmd( "BufWritePre", {
   group = vim.api.nvim_create_augroup( "formatting", { clear = false } ),
   pattern = "*",
   callback = function( args )
      require( "conform" ).format( {
         bufnr = args.buf,
         timeout_ms = 1000,
         lsp_format = "fallback",
         formatting_options = {
            tabSize = 3,
         },
      } )
   end,
} )

-- [[ options when opening a terminal ]]
vim.api.nvim_create_autocmd( "TermOpen", {
   group = vim.api.nvim_create_augroup( "term-open", { clear = true } ),
   callback = function()
      vim.api.nvim_buf_set_keymap( 0, "t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" } )
      vim.opt.number = false
      vim.opt.relativenumber = false
   end,
} )

-- [[ restore cursor position when opening file ]]
vim.api.nvim_create_autocmd( "BufReadPost", {
   callback = function( args )
      -- we want the cursor on top when commiting messages
      if (vim.bo.ft == "gitcommit") then
         return
      end

      local mark = vim.api.nvim_buf_get_mark( args.buf, '"' ) -- last position when exited the buffer
      local line_count = vim.api.nvim_buf_line_count( args.buf )

      -- if the last position is out of bounds
      if mark[1] <= 0 or mark[1] > line_count then
         return
      end

      vim.api.nvim_win_set_cursor( 0, mark )

      -- if we are in terminal mode (important if we are in yazi)
      if (vim.api.nvim_get_mode().mode == "t") then
         return
      end

      -- defer centering so its applyed after render
      vim.schedule( function()
         vim.cmd( "normal! zz" )
      end )
   end,
} )

-- [[ resize splits when window size changes ]]
vim.api.nvim_create_autocmd( "VimResized", {
   command = "wincmd =",
} )

-- [[ treesitter syntax highlighting on config files ]]
vim.api.nvim_create_autocmd( "BufRead", {
   pattern = { ".env", ".env.*", "*.conf" },
   callback = function()
      vim.bo.filetype = "dosini"
   end,
} )

-- [[ document-higligting ]]
local hover_highlight_group = vim.api.nvim_create_augroup( "hover-highlight", { clear = false } )
local no_highlight_table = { "json", "jsonc", "cmake", "yaml" }

vim.api.nvim_create_autocmd( { "CursorHold", "CursorHoldI" }, {
   group = hover_highlight_group,
   callback = function()
      for _, no_highlight_ft in pairs( no_highlight_table ) do
         if vim.bo.filetype == no_highlight_ft then
            return
         end
      end
      vim.lsp.buf.document_highlight()
   end,
} )

vim.api.nvim_create_autocmd( { "CursorMoved", "CursorMovedI" }, {
   group = hover_highlight_group,
   callback = function()
      for _, no_highlight_ft in pairs( no_highlight_table ) do
         if vim.bo.filetype == no_highlight_ft then
            return
         end
      end
      vim.lsp.buf.clear_references()
   end,
} )

-- [[ help menu ]]

vim.api.nvim_create_autocmd( "FileType", {
   pattern = "help",
   callback = function()
      local editor_columns = vim.api.nvim_get_option_value( "columns", {} )
      if editor_columns > 125 then
         vim.cmd( "wincmd L" )
      else
         vim.cmd( "wincmd J" )
      end
   end,
} )
