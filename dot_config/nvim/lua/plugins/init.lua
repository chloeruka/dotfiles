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
    event = "BufWritePre", -- comment to prevent format on save
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
    opts = overrides.mason,
  },

  -- code-aware syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  -- LazyDev lazily updates workplace libraries for lua_ls
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files

    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- inlay-hints simplifies enabling neovim inlay hints
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end,
  },

  -- nvim+tmux pane navigation and resizing
  { "mrjones2014/smart-splits.nvim" },

  -- session management
  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      -- log_level = 'debug',
    },
  },
}
