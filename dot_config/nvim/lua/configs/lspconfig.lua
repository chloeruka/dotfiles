--
-- nvim-lspconfig configures language servers
--

require("nvchad.configs.lspconfig").defaults()

-- configure language servers which ship with sufficient defaults
vim.lsp.enable { "html", "cssls", "yamlls", "jsonls", "tflint" }

vim.lsp.config["vtsls"] = {
  settings = {
    typescript = {
      tsserver = {
        -- this is a workaround to resolve tsserver failures in large projects (e.g. monorepos)
        -- other strategies to consider: enable tree-sitter, disable eslint/prettier
        maxTsServerMemory = 5192,
        nodePath = vim.fn.exepath("bun") ~= "" and vim.fn.exepath("bun") or vim.fn.exepath("node"),
      },
    },
  },
}
vim.lsp.enable "vtsls"

-- configure terraformls with special options
vim.lsp.config["terraformls"] = {
  on_attach = function(client, bufnr)
    -- fixes commentstrings for terraform and HCL
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
      callback = function(ev)
        vim.bo[ev.buf].commentstring = "# %s"
      end,
    })
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
