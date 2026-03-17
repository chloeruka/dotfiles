--
-- nvim-lspconfig configures language servers
--

require("nvchad.configs.lspconfig").defaults()

-- local nvlsp = require "nvchad.configs.lspconfig"
-- local lspconfig = -- require "lspconfig"
--
-- nvlsp.defaults() -- loads nvchad's defaults

-- local lsp_on_attach = function(client, bufnr)
--   nvlsp.on_attach(client, bufnr)
--   local map = vim.keymap.set
--
-- 	-- define LSP specific key bindings
-- 	-- stylua: ignore start
-- 	map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { buffer = bufnr, desc = "Telescope: LSP defininitions" })
-- 	map("n", "gr", "<cmd>Telescope lsp_references<CR>", { buffer = bufnr, desc = "Telescope: LSP references" })
-- 	map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { buffer = bufnr, desc = "Telescope: LSP implementations" })
--   -- stylua: ignore end
-- end

-- vim.lsp.inlay_hint.enable(true)
-- vim.lsp.codelens.enable(true)

-- configure language servers which ship with sufficient defaults
vim.lsp.enable { "html", "cssls", "yamlls", "jsonls", "tflint" }

-- vim.lsp.config["copilot"] = {
--   cmd = { "copilot-language-server", "--stdio" },
--   root_markers = { ".git" },
-- }
-- vim.lsp.enable "copilot"

vim.lsp.config["vtsls"] = {
  settings = {
    typescript = {
      tsserver = {
        -- this is a workaround to resolve tsserver failures in large projects (e.g. monorepos)
        -- other strategies to consider: enable tree-sitter, disable eslint/prettier
        maxTsServerMemory = 5192,
        -- nodePath = "$XDG_DATA_HOME/mise/installs/bun/1.3.5/bin/bun",
        nodePath = "/Users/ruka/.local/share/mise/installs/bun/1.3.5/bin/bun",
      },
    },
  },
}
vim.lsp.enable "vtsls"

-- configure ruff with special options
vim.lsp.config["ruff"] = {
  init_options = {
    settings = {
      configuration = "~/.config/ruff.toml",
      -- Any extra CLI arguments for `ruff` go here.
      --args = { "--config", "~/.config/ruff.toml" },
    },
  },
}
vim.lsp.enable "ruff"

-- configure pyright (python LSP) with special options
vim.lsp.config["basedpyright"] = {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        reportMissingTypeStubs = false,
        typeCheckingMode = "basic",
        -- Ignore all files for analysis to exclusively use Ruff for linting
        -- ignore = { "*" },
      },
    },
  },
}
vim.lsp.enable "basedpyright"

-- configure terraformls with special options
vim.lsp.config["terraformls"] = {
  on_attach = function(client, bufnr)
    -- fixes commentstrings for terraform and HCL
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
      callback = function(ev)
        vim.bo[ev.buf].commentstring = "# %s"
      end,
      -- pattern = { "terraform", "hcl" }, -- shouldn't be necessary given we bind on_attach
    })
    lsp_on_attach(client, bufnr)
  end,
  flags = { debounce_text_changes = 150 },
}

vim.lsp.enable "terraformls"

-- configure jsonls to complete tsconfig and so on
vim.lsp.config["jsonls"] = {
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json",
          },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
          url = "https://json.schemastore.org/babelrc.json",
        },
        {
          fileMatch = { "lerna.json" },
          url = "https://json.schemastore.org/lerna.json",
        },
        {
          fileMatch = { "now.json", "vercel.json" },
          url = "https://json.schemastore.org/now.json",
        },
        {
          fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json",
          },
          url = "http://json.schemastore.org/stylelintrc.json",
        },
      },
    },
  },
}
vim.lsp.enable "jsonls"
