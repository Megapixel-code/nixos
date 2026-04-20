return {
   {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate",

      main = "nvim-treesitter.configs",
      opts = {
         ensure_installed = {
            "c",
            "bash",

            "cpp",
            "python",
            "java",
            "lua",
            "pascal",

            "scala",
            "nix",

            "html",
            "css",
            "javascript",

            "yaml",
            "typst",
            "markdown",
            "markdown_inline",
            "gitcommit",
            "editorconfig",
         },

         indent = {
            enable = true,
         },
         highlight = {
            enable = true,
         },
      },
   },
}
