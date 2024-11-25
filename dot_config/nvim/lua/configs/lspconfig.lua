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
  -- exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
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
