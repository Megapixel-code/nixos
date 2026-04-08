return {
   "iamcco/markdown-preview.nvim",
   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
   build = "cd app && yarn install",
   init = function()
      vim.g.mkdp_filetypes = { "markdown" }

      -- set to 1, nvim will open the preview window after entering the Markdown buffer
      vim.g.mkdp_auto_start = 0
      -- set to 1, the nvim will auto close current preview window when changing
      -- from Markdown buffer to another buffer
      vim.g.mkdp_auto_close = 0

      -- set to 1, Vim will refresh Markdown when saving the buffer or
      -- when leaving insert mode. Default 0 is auto-refresh Markdown as you edit or
      -- move the cursor
      vim.g.mkdp_refresh_slow = 0

      -- use custom IP to open preview page.
      -- Useful when you work in remote Vim and preview on local browser.
      -- For more details see: https://github.com/iamcco/markdown-preview.nvim/pull/9
      -- default empty
      vim.g.mkdp_open_ip = ""

      -- use a custom Markdown style. Must be an absolute path
      -- like '/Users/username/markdown.css' or expand('~/markdown.css')
      vim.g.mkdp_markdown_css = ""

      -- use a custom port to start server or empty for random
      vim.g.mkdp_port = "6969"

      -- preview page title
      -- ${name} will be replace with the file name
      vim.g.mkdp_page_title = "${name}"

      -- use a custom location for images
      -- vim.g.mkdp_images_path = "/home/user/.markdown_images"

      -- set default theme (dark or light)
      vim.g.mkdp_theme = "dark"

      -- auto refetch combine preview contents when change markdown buffer
      -- only when g:mkdp_combine_preview is 1
      vim.g.mkdp_combine_preview_auto_refresh = 1
   end,
   ft = { "markdown" },
}
