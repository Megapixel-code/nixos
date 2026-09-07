--- @return string | nil
local function get_content()
   vim.treesitter.get_parser( 0 ):parse();
   local node = vim.treesitter.get_node();
   if (node == nil) then
      return nil;
   end;

   return vim.treesitter.get_node_text( node, 0 );
end;

--- function that returns the link
--- @param content string
--- @return string | nil
local function parse( content )
   if (content == "") then
      return nil;
   end;
   local link = nil;

   local origin = "https://github.com/"; -- default
   local matches = {
      ["github:"] = "https://github.com/",
      ["gitlab:"] = "https://gitlab.com/",
      ["codeberg:"] = "https://codeberg.org/",
   };
   local pathname;
   for match, m_origin in pairs( matches ) do
      pathname = string.gsub( content, match, "" );
      if (content ~= pathname) then
         origin = m_origin;
         break;
      end;
   end;

   local exclusions = {
      " ",
      ":",
   };
   for _, exclusion in ipairs( exclusions ) do
      if (string.find( pathname, exclusion )) then
         return nil;
      end;
   end;

   if string.match( pathname, "%a+/%a+" ) == nil then
      return nil;
   end;

   link = origin .. pathname;
   return link;
end;

local function open_link( link )
   local cmd, err = vim.ui.open( link );
   if (cmd) then
      cmd:wait();
   end;

   if (err ~= nil) then
      vim.print( "error: goto-link: " .. err );
   end;
   return err;
end;

local function goto_link()
   local content = get_content();
   if (content == nil) then
      return;
   end;

   local link = parse( content );
   if (link ~= nil) then
      local err = open_link( link );
      if (err == nil) then
         return;
      end;
   end;

   open_link( content );
end;

vim.keymap.set( "n", "gx", goto_link, { desc = "go to link" } );
