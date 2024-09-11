-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- configure language servers to load
local servers = { "html", "cssls", "ts_ls", "yamlls", "terraformls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- loop through lsps that use a default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configure ruff with special options
lspconfig.ruff.setup {
  on_attach = nvlsp.on_attach,
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

lspconfig.basedpyright.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    basedpyright = {
      analysis = {
        -- typeCheckingMode = "basic",
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
    },
  },
}
