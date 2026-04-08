-- ~~~ [[ Basic Keymaps ]] ~~~


-- [Source file]
vim.keymap.set( "n", "<leader>o", "<cmd>update<CR><cmd>source<CR>", { desc = "Rel[O]ad file" } )


-- [Toggle settings]
vim.keymap.set( "n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "Toggle Spelling" } )
vim.keymap.set( "n", "<leader>tf", function()
                   local current_spelllang = vim.o.spelllang
                   if current_spelllang == "en_us" then
                      vim.o.spelllang = "fr"
                   else
                      vim.o.spelllang = "en_us"
                   end
                end, { desc = "Toggle French spelling" } )
vim.keymap.set( "n", "<leader>tv", "<cmd>ToggleDiagnosticsVirtualLines<CR>",
                { desc = "Toggle diagnostics virtual lines" } )


-- [Clear highlights]
vim.keymap.set( "n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clears higlighting of search" } )


-- [lsp]
vim.keymap.set( "n", "K", vim.lsp.buf.hover, { desc = "Hover Information" } )


-- [Quickfix]
vim.keymap.set( "n", "<leader>j", "<cmd>cnext<CR>", { desc = "next element in the quickfix list" } )
vim.keymap.set( "n", "<leader>k", "<cmd>cprev<CR>", { desc = "previous element in the quickfix list" } )


-- [terminal movement]
local tmux = require( "tmux" )

vim.keymap.set( "n", "<C-space>h", tmux.move_left,     { desc = "Move left" } )
vim.keymap.set( "n", "<C-space>j", tmux.move_bottom,   { desc = "Move bottom" } )
vim.keymap.set( "n", "<C-space>k", tmux.move_top,      { desc = "Move top" } )
vim.keymap.set( "n", "<C-space>l", tmux.move_right,    { desc = "Move right" } )

vim.keymap.set( "n", "<M-h>",      tmux.resize_left,   { desc = "Resize left" } )
vim.keymap.set( "n", "<M-j>",      tmux.resize_bottom, { desc = "Resize bottom" } )
vim.keymap.set( "n", "<M-k>",      tmux.resize_top,    { desc = "Resize top" } )
vim.keymap.set( "n", "<M-l>",      tmux.resize_right,  { desc = "Resize right" } )

vim.keymap.set( "n", "<C-M-h>",    tmux.swap_left,     { desc = "Swap left" } )
vim.keymap.set( "n", "<C-M-j>",    tmux.swap_bottom,   { desc = "Swap bottom" } )
vim.keymap.set( "n", "<C-M-k>",    tmux.swap_top,      { desc = "Swap top" } )
vim.keymap.set( "n", "<C-M-l>",    tmux.swap_right,    { desc = "Swap right" } )


-- ~~~ [[ Plugins Keymaps ]] ~~~


-- [luasnip]
local luasnip = require( "luasnip" )
-- disable tab and s-tab keymap that would otherwise expand the snippet
vim.keymap.set( { "i", "s" }, "<Tab>",   "<Tab>" )
vim.keymap.set( { "i", "s" }, "<S-Tab>", "<S-Tab>" )
vim.keymap.set( { "i", "s" }, "<c-j>", function()
                   if luasnip.expand_or_jumpable() then
                      luasnip.expand_or_jump()
                   end
                end, { silent = true, desc = "go to next snippet jump" } )

vim.keymap.set( { "i", "s" }, "<c-k>", function()
                   if luasnip.jumpable( -1 ) then
                      luasnip.jump( -1 )
                   end
                end, { silent = true, desc = "go to previous snippet jump" } )


-- [typst/markdown]
-- NOTE: more info :h expand
-- % file path relative to CWD
-- %:p full path from /
-- %:t file name alone (tail)
-- %:h file directory alone (head)
-- %:r file with one less extension
-- %:e file extension
-- %:p:h directory of the file from /
-- %:t:r the file name alone without the extension
vim.keymap.set( "n", "<leader>tc", "", {
   callback = function()
      local ft = vim.o.filetype
      if ft == "typst" then
         local file_dir = vim.fn.expand( "%:p:h" )
         print( file_dir )
         os.execute( "mkdir -p " .. file_dir .. "/out" )
         vim.cmd( "!typst compile %:p %:p:h/out/%:t:r.pdf" )
      elseif ft == "markdown" then
         -- TODO: look pandoc
      end
   end,
   desc = "Compile typ or md file",
} )

vim.keymap.set( "n", "<leader>tp", "", {
   callback = function()
      local ft = vim.o.filetype
      if ft == "typst" then
         vim.cmd( "TypstPreview" )
      elseif ft == "markdown" then
         vim.cmd( "MarkdownPreview" )
      end
   end,
   desc = "Preview md or typ file",
} )


-- [todo-comments]
local todo_keywords = {
   "FIX",
   "FIXME",
   "BUG",
   "FIXIT",
   "ISSUE",
   "WARN",
   "WARNING",
   "XXX",
   "OPTIMIZE",
   "TODO",
}
vim.keymap.set( "n", "<leader>st",
                "<cmd>TodoTelescope keywords=" .. table.concat( todo_keywords, "," ) .. "<CR>",
                {
                   desc = "Search TODOS",
                } )


-- [color-skimer]
local color_skimer = require( "color-skimer" )
vim.keymap.set( "n", "<leader>sc", "<cmd>ColorSkimerToggle<CR>", {
   desc =
   "Search Colorschemes",
} )
vim.keymap.set( "n", "<leader>cs", color_skimer.set_random_colorscheme, { desc = "Set random colorscheme" } )


-- [telescope]
local telescope_builtins = require( "telescope.builtin" )
local telescope_config = require( "config.telescope" )
vim.keymap.set( "n", "<leader>sf", telescope_builtins.find_files,    { desc = "Search Files" } )
vim.keymap.set( "n", "<leader>sh", telescope_builtins.help_tags,     { desc = "Search Help" } )
vim.keymap.set( "n", "<leader>sm", telescope_builtins.marks,         { desc = "Search Marks" } )
vim.keymap.set( "n", "<leader>ss", telescope_builtins.spell_suggest, { desc = "Search Spelling" } )
vim.keymap.set( "n", "<leader>sn", function()
                   telescope_builtins.find_files( {
                      cwd = vim.fn.stdpath( "config" ),
                   } )
                end, { desc = "Search Neovim" } )
vim.keymap.set( "n", "<leader>sp", function()
                   telescope_builtins.find_files( {
                      cwd = vim.fs.joinpath( vim.fn.stdpath( "data" ), "lazy" ),
                   } )
                end, { desc = "Search Plugins" } )
vim.keymap.set( "n", "<leader>sg", telescope_config.multigrep, { desc = "Search Grep" } )


-- [gitsigns]
vim.keymap.set( "n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>",                  { desc = "toggle Git Diff" } )
vim.keymap.set( "n", "<leader>gh", "<cmd>Gitsigns toggle_linehl<CR>",             { desc = "toggle Git Highlights" } )
vim.keymap.set( "n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "toggle Git line Blame" } )
-- TODO: git Preview hunk, go to next hunk in the git *project*, etc...

-- [ccc]
vim.keymap.set(
   "n",
   "<leader>cr",
   "<cmd>CccHighlighterDisable<CR><cmd>CccHighlighterEnable<CR>",
   { desc = "Refresh CCC plugin" }
)
vim.keymap.set( "n", "<leader>cc", ":CccPick<CR>", { desc = "Pick color" } )


-- [yazi]
vim.keymap.set( "n", "<leader>yy", "<cmd>Yazi<cr>",        { desc = "open Yazi at the current file" } )
vim.keymap.set( "n", "<leader>ys", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" } )
vim.keymap.set( "n", "<leader>yc", function()
                   require( "yazi" ).yazi( { change_neovim_cwd_on_close = true } )
                end, { desc = "Yazi Change CWD" } )
