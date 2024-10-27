--
-- nvim-lspconfig configures language servers
--

-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- configure language servers which ship with sufficient defaults
local servers = { "html", "cssls", "ts_ls", "yamlls", "tflint" }
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

-- configure pyright (python LSP) with special options
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

-- configure terraformls with special options
lspconfig.terraformls.setup({
  on_attach = function(client, bufnr)
    -- fixes commentstrings for terraform and HCL
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
      callback = function(ev)
        vim.bo[ev.buf].commentstring = "# %s"
      end,
      -- pattern = { "terraform", "hcl" }, -- shouldn't be necessary given we bind on_attach
    })
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  flags = { debounce_text_changes = 150 },
})
