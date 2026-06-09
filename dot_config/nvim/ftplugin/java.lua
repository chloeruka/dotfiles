--
-- jdtls launcher (Eclipse JDT Language Server for Java)
--
-- This runs once per java buffer. jdtls is heavier than the servers wired up
-- in configs/lspconfig.lua, so it lives here behind the nvim-jdtls plugin
-- rather than going through vim.lsp.enable.
--
-- Requires: a JDK on PATH (JAVA_HOME is set to JDK 17 in dot_config/zsh/dot_zshrc)
-- and the `jdtls` + `java-debug-adapter` Mason packages (see configs/overrides.lua).
--

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

-- Find the project root by walking up for any common Java/VCS marker.
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  -- Not in a recognisable project; bail rather than spin up a workspace-less server.
  return
end

-- Per-project workspace so distinct projects don't share (and corrupt) state.
local workspace_dir = vim.fn.stdpath "data" .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Mason installs jdtls here; resolve its launcher jar and platform config.
local mason_pkg = vim.fn.stdpath "data" .. "/mason/packages/jdtls"
local launcher = vim.fn.glob(mason_pkg .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local config_os = "config_mac" -- this dotfiles repo is macOS-only (see README / brew setup)

-- Reuse NvChad's shared on_attach + capabilities so keymaps and completion
-- match every other language server in this config.
local nvlsp = require "nvchad.configs.lspconfig"

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher,
    "-configuration",
    mason_pkg .. "/" .. config_os,
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  settings = {
    java = {
      -- organise imports / code actions behave better with these on
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" }, -- decompiler for jumping into deps
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
        },
      },
    },
  },
}

jdtls.start_or_attach(config)
