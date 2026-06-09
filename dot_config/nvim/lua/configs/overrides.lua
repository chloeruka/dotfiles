local M = {}

pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

M.treesitter = {
  ensure_installed = {
    "c",
    "css",
    "html",
    "java",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "terraform",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },
  indent = {
    enable = true,
  },

  highlight = {
    enable = true,
  },
}

M.mason = {
  pkgs = {
    -- common language servers
    "yaml-language-server",
    "terraform-ls",

    -- node/typescript development
    "biome",
    "prettier",
    "jsonls",
    "vtsls", -- uses VSCode LSP for typescript development

    -- java development (jdtls is driven by the nvim-jdtls plugin, not vim.lsp.enable)
    "jdtls",
    "java-debug-adapter",
  },
}

return M
