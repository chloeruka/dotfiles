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
    use_languagetree = true,
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
  },
}

return M
