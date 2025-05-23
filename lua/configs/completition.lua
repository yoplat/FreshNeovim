return function(_)
  dofile(vim.g.base46_cache .. "cmp")

  local cmp = require "cmp"
  local luasnip = require "luasnip"
  local opts = {

    completion = { completeopt = "menu,menuone" },

    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },

    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
    },

    mapping = {
      ["<C-n>"] = cmp.mapping.select_next_item {
        behavior = cmp.SelectBehavior.Insert,
      },
      ["<C-p>"] = cmp.mapping.select_prev_item {
        behavior = cmp.SelectBehavior.Insert,
      },
      ["<C-j>"] = cmp.mapping.select_next_item {
        behavior = cmp.SelectBehavior.Insert,
      },
      ["<C-k>"] = cmp.mapping.select_prev_item {
        behavior = cmp.SelectBehavior.Insert,
      },
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        local copilot = require "copilot.suggestion"

        if copilot.is_visible() then
          copilot.accept()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif cmp.visible() then
          cmp.confirm { select = true }
        else
          fallback()
        end
      end, { "i", "s" }),
    },

    enabled = function()
      local buftype =
          vim.api.nvim_get_option_value("buftype", { scope = "local" })
      if buftype == "prompt" then
        return false
      end
      -- disable completion in comments
      local context = require "cmp.config.context"
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == "c" then
        return true
      else
        return not context.in_treesitter_capture "comment"
            and not context.in_syntax_group "Comment"
      end
    end
  }

  -- Add the NvChad/ui config
  opts = vim.tbl_deep_extend("force", opts, require "nvchad.cmp")

  cmp.setup(opts)

  -- Disable snippet expansion in normal mode
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = vim.api.nvim_create_augroup(
      "UnlinkSnippetOnModeChange",
      { clear = true }
    ),
    pattern = { "s:n", "i:*" },
    callback = function(event)
      if
          luasnip.session
          and luasnip.session.current_nodes[event.buf]
          and not luasnip.session.jump_active
      then
        luasnip.unlink_current()
      end
    end,
  })
end
