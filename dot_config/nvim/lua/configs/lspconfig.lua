--
-- nvim-lspconfig configures language servers
--

local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

nvlsp.defaults() -- loads nvchad's defaults

local lsp_on_attach = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  local map = vim.keymap.set

	-- define LSP specific key bindings
	-- stylua: ignore start
	map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { buffer = bufnr, desc = "Telescope: LSP defininitions" })
	map("n", "gr", "<cmd>Telescope lsp_references<CR>", { buffer = bufnr, desc = "Telescope: LSP references" })
	map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { buffer = bufnr, desc = "Telescope: LSP implementations" })
  -- stylua: ignore end
end

lspconfig.inlay_hints = {
  enabled = true,
  -- exclude = { "vue" }, -- filetypes to disable inlay hints on
}
lspconfig.codelens = {
  enabled = true,
}

-- configure language servers which ship with sufficient defaults
local servers = { "html", "cssls", "ts_ls", "yamlls", "tflint" }

-- loop through lsps that use a default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = lsp_on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configure ruff with special options
lspconfig.ruff.setup {
  on_attach = lsp_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    settings = {
      configuration = "~/.config/ruff.toml",
      -- Any extra CLI arguments for `ruff` go here.
      --args = { "--config", "~/.config/ruff.toml" },
    },
  },
}

-- configure pyright (python LSP) with special options
lspconfig.basedpyright.setup {
  on_attach = lsp_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
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

-- configure terraformls with special options
lspconfig.terraformls.setup {
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
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  flags = { debounce_text_changes = 150 },
}

-- configure jsonls to complete tsconfig and so on
lspconfig.jsonls.setup {
  on_attach = lsp_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
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
