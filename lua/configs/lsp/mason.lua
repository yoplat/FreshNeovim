-- List of servers to install
local servers = {
  -- "html",
  -- "cssls",
  -- "tsserver",
  "clangd",
  "pyright",
  -- "bashls",
  "lua_ls",
  "rust_analyzer",
}

return {
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
