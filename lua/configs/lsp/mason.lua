local M = {}

M.servers = {
  -- "html",
  -- "cssls",
  -- "tsserver",
  "clangd",
  "pyright",
  -- "bashls",
  "lua-language-server",
  "rust-analyzer",
}

M.opts = {
  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },

  max_concurrent_installers = 10,
}

return M
