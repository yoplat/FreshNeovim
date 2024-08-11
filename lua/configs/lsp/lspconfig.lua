local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gl", function()
    vim.diagnostic.open_float { border = "rounded" }
  end, opts "Floating diagnostics")
  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  map(
    "n",
    "<leader>wa",
    vim.lsp.buf.add_workspace_folder,
    opts "Add workspace folder"
  )
  map(
    "n",
    "<leader>wr",
    vim.lsp.buf.remove_workspace_folder,
    opts "Remove workspace folder"
  )

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>cr", function()
    require "nvchad.lsp.renamer"()
  end, opts "NvRenamer")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

return function(_)
  dofile(vim.g.base46_cache .. "lsp")
  dofile(vim.g.base46_cache .. "mason")

  require("nvchad.lsp").diagnostic_config()

  -- List of servers to install
  local servers = {
    -- "html",
    -- "cssls",
    -- "tsserver",
    -- "clangd",
    "pyright",
    -- "bashls",
    "lua_ls",
  }

  -- List of tools to install (no servers)
  local ensure_installed = {
    "ruff",
    "black",
    "usort",
    "stylua",
    -- "debugpy",
  }

  require("mason").setup {
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

  vim.api.nvim_create_user_command("MasonInstallAll", function()
    vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
  end, {})

  require("mason-lspconfig").setup {
    ensure_installed = servers,
  }

  local lspconfig = require "lspconfig"

  -- This will setup lsp for servers you listed above
  -- And servers you install through mason UI
  -- So defining servers in the list above is optional
  require("mason-lspconfig").setup_handlers {
    -- Default setup for all servers, unless a custom one is defined below
    function(server_name)
      lspconfig[server_name].setup {
        on_attach = function(client, bufnr)
          M.on_attach(client, bufnr)
          -- Add your other things here
          -- Example being format on save or something
        end,
        capabilities = (function()
          M.capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          }
          return M.capabilities
        end)(),
      }
    end,

    ["lua_ls"] = function()
      lspconfig.lua_ls.setup {
        on_attach = M.on_attach,
        capabilities = M.capabilities,
        on_init = M.on_init,

        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.fn.expand "$VIMRUNTIME/lua",
                vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                "${3rd}/luv/library",
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        },
      }
    end,

    -- custom setup for a server goes after the function above
    -- Example, override rust_analyzer
    -- ["rust_analyzer"] = function ()
    --   require("rust-tools").setup {}
    -- end,

    -- ["clangd"] = function()
    --   lspconfig.clangd.setup {
    --     cmd = {
    --       "clangd",
    --       "--offset-encoding=utf-16", -- To match null-ls
    --       --  With this, you can configure server with
    --       --    - .clangd files
    --       --    - global clangd/config.yaml files
    --       --  Read the `--enable-config` option in `clangd --help` for more information
    --       -- "--enable-config",
    --     },
    --     on_attach = function(client, bufnr)
    --       on_attach(client, bufnr)
    --     end,
    --     capabilities = capabilities,
    --   }
    -- end,
  }
end
