return function()
  local x = vim.diagnostic.severity

  local opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      signs = {
        text = {
          [x.ERROR] = "󰅙",
          [x.WARN] = "",
          [x.INFO] = "󰋼",
          [x.HINT] = "󰌵",
        },
      },
      float = { border = "single" },
      virtual_text = {
        prefix = "",
        spacing = 5,
        -- only show sources name if multiple available
        -- source = "if_many",
      },
      -- Show error -> warning -> info
      severity_sort = true,
    },
    -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the inlay hints.
    inlay_hints = {
      enabled = false,
    },
  }

  if opts.inlay_hints.enabled then
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.supports_method "textDocument/inlayHint" then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end,
    })
  end

  -- Merge diagnostics opts into vim
  vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
end
