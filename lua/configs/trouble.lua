return {
  auto_open = false, -- automatically open the list when you have diagnostics
  auto_close = true, -- automatically close the list when you have no diagnostics
  auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
  indent_guides = true, -- add an indent guide below the fold icons
  multiline = true, -- render multi-line messages
  focus = true,
  icons = {
    indent = {
      fold_open = "", -- icon used for open folds
      fold_closed = "", -- icon used for closed folds
    },
  },
  keys = {
    p = "preview",
    P = "toggle_preview",
    s = { -- example of a custom action that toggles the severity
      action = function(view)
        local f = view:get_filter "severity"
        local severity = ((f and f.filter.severity or 0) + 1) % 5
        view:filter({ severity = severity }, {
          id = "severity",
          template = "{hl:Title}Filter:{hl} {severity}",
          del = severity == 0,
        })
      end,
      desc = "Toggle Severity Filter",
    },
    m = { -- example of a custom action that toggles the active view filter
      action = function(view)
        view:filter({ buf = 0 }, {
          toggle = true,
          template = "{hl:Title}Current buffer",
        })
      end,
      desc = "Toggle Current Buffer Filter",
    },
  },
  modes = {
    diagnostics_buffer = {
      mode = "diagnostics", -- inherit from diagnostics mode
      filter = { buf = 0 }, -- filter diagnostics to the current buffer
    },
  },
  -- position = "bottom", -- position of the list can be: bottom, top, left, right
  -- height = 15, -- height of the trouble list when position is top or bottom
  -- width = 50, -- width of the list when position is left or right
  -- mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  -- padding = false, -- add an extra new line on top of the list
  -- cycle_results = true, -- cycle item list when reaching beginning or end of list
  -- action_keys = { -- key mappings for actions in the trouble list
  --   toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
  --   switch_severity = "s", -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
  --   toggle_preview = "P", -- toggle auto_preview
  --   hover = "K", -- opens a small popup with the full multiline message
  -- },
  -- win_config = { border = "single" }, -- window configuration for floating windows. See |nvim_open_win()|.
  -- use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
}
