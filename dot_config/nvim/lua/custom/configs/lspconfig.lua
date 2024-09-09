local configs = require("plugins.configs.lspconfig")
local on_attach = configs.on_attach
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ts_ls", "clangd", "yamlls", "pyright", "ruff", "terraformls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.ruff.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = { "--config", "~/.config/ruff.toml" },
    }
  }
}
