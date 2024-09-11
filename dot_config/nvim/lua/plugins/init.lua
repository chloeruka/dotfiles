-- this is a lazy.nvim configuration for nvim plugins
-- lazy runs each plugin setup() method with the content of opts
-- if config is set, then that will be used exclusively
-- you can also access opts via `config  = func(_, opts) ...` if needed
-- docs: https://lazy.folke.io/usage/structuring
local overrides = require "configs.overrides"

return {
  -- code formatting
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- comment to prevent format on save
    opts = require "configs.conform",
  },

  -- code linting
  -- {
  --   "mfussenegger/nvim-lint",
  --   config = function()
  --     require("configs.lint").setup()
  --   end,
  --   opts = require "configs.lint"
  -- },

  -- LSP server integration on buffers
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Mason is a portable package manager
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  -- code-aware syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  -- navigation sidebar / project directory list
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
}
