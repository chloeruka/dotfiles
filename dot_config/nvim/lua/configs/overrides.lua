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
    "python",
    "terraform",
    "tsx",
    "typescript",
    "vim",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },
}

M.mason = {
  -- -- OLD CONFIG
  -- ensure_installed = {
  --   -- lua stuff
  --   "lua-language-server",
  --   "stylua",
  --
  --   -- custom stuff
  --   "yaml-language-server",
  --   "basedpyright",
  --   "mypy",
  --   "ruff",
  --   "terraform-ls",
  --
  --   -- web dev stuff
  --   "css-lsp",
  --   "html-lsp",
  --   "typescript-language-server",
  --   "deno",
  --   "prettier",
  --
  --   -- c/cpp stuff
  --   "clangd",
  --   "clang-format",
  -- },
  pkgs = {
    -- common language servers
    "yaml-language-server",
    "terraform-ls",
    "prettier",

    -- python development
    "basedpyright",
    "mypy",
    "ruff",
  }
}

-- git support in nvimtree
M.nvimtree = {
  filters = {
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = { '^.null-ls$', '^.git$' },
  },
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
