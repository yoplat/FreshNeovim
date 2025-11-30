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
  }

  -- Merge diagnostics opts into vim
  vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

  local ns = vim.api.nvim_create_namespace "my_namespace"
  local virt_hand = vim.diagnostic.handlers.virtual_text
  vim.diagnostic.handlers.virtual_text = {
    show = function(_, bufnr, _, opt)
      local diagnostics = vim.diagnostic.get(bufnr)

      -- Same namespace for all diagnostics
      for _, d in pairs(diagnostics) do
        d["namespace"] = ns
      end
      -- Sort by severity
      if opts.diagnostics.severity_sort then
        table.sort(diagnostics, function(a, b)
          return a.severity > b.severity
        end)
      end

      virt_hand.show(ns, bufnr, diagnostics, opt)
    end,
    hide = function(_, bufnr)
      virt_hand.hide(ns, bufnr)
    end,
  }
end
