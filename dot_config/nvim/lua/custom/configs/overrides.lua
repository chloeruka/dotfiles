local M = {}

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
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- custom stuff
    "yaml-language-server",
    "basedpyright",
    "mypy",
    "ruff",
    "terraform-ls",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",
  },
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
