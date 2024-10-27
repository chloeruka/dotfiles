--
-- conform.nvim configures formatting by filetype
-- alongside nvim-lint, this plugin helps replace null-ls
-- via format_on_save, we can fallback to the LSP provider's built-in formatting
--

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "prettier" },
    python = { "ruff_fix", "ruff_format", "black" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
