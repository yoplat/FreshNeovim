dofile(vim.g.base46_cache .. "blink")

local opts = {
  snippets = { preset = "luasnip" },
  cmdline = {
    enabled = true,
    keymap = { preset = "inherit" },
  },
  appearance = { nerd_font_variant = "normal" },
  fuzzy = { implementation = "prefer_rust" },
  sources = { default = { "lsp", "snippets", "buffer", "path" } },

  keymap = {
    preset = "default",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<Tab>"] = {
      "show_and_insert_or_accept_single",
      "snippet_forward",
      "accept",
      "fallback",
    },
    ["<S-Tab>"] = {
      "show_and_insert_or_accept_single",
      "snippet_backward",
      "accept",
      "fallback",
    },
  },

  completion = {
    -- ghost_text = { enabled = true },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "single" },
    },

    -- from nvchad/ui plugin
    -- exporting the ui config of nvchad blink menu
    -- helps non nvchad users
    menu = require("nvchad.blink").menu,
  },
}

return opts
