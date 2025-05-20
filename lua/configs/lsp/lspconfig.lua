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
    require "nvchad.lsp.renamer" ()
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

  require("configs.lsp.diagnostics")()

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      M.on_attach(_, args.buf)
    end,
  })

  local lua_lsp_settings = {
    Lua = {
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
      },
    },
  }

  vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
  vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
  vim.lsp.enable "lua_ls"

  --     -- ["rust_analyzer"] = function()
  --     --   lspconfig.rust_analyzer.setup {
  --     --     on_attach = M.on_attach,
  --     --     capabilities = M.capabilities,
  --     --     on_init = M.on_init,
  --     --
  --     --     settings = {
  --     --       ["rust-analyzer"] = {
  --     --         diagnostics = {
  --     --           enable = false,
  --     --         },
  --     --         inlayHints = {
  --     --           typeHints = false,
  --     --           parameterHints = false,
  --     --         },
  --     --       },
  --     --     },
  --     --   }
  --     -- end,
  --
  --     ["clangd"] = function()
  --       lspconfig.clangd.setup {
  --         on_attach = M.on_attach,
  --         capabilities = M.capabilities,
  --         -- on_init = M.on_init,
  --         cmd = {
  --           "clangd",
  --           "--offset-encoding=utf-16", -- To match null-ls
  --           --  With this, you can configure server with
  --           --    - .clangd files
  --           --    - global clangd/config.yaml files
  --           --  Read the `--enable-config` option in `clangd --help` for more information
  --           -- "--enable-config",
  --         },
  --       }
  --     end,
end
