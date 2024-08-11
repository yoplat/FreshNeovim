-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    CursorLine = {
      bg = "#222131",
    },
    PmenuSbar = {
      bg = "NONE",
      fg = "NONE",
    },
    PmenuThumb = {
      fg = "NONE",
      bg = "NONE",
    },
    FoldColumn = {
      bg = "NONE",
    },
  },

  integrations = {
    "navic",
    "rainbowdelimiters",
    "trouble",
    "notify",
    "todo",
    "dap",
  }, -- NOTE: check what is already enabled
}

M.ui = {
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  telescope = { style = "borderless" }, -- borderless / bordered

  statusline = {
    theme = "vscode_colored",
    order = { "mode", "file", "git", "diagnostics", "%=", "lsp_msg", "%=", "line", "filetype", "lsp_server", "cwd" },
    modules = {
      line = (function()
        return vim.o.columns > 140 and "%#StText# %l, %c  " or ""
      end),
      filetype = (function()
        local ft = vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)].ft
        return ft == "" and "%#St_ft#{} text  " or "%#St_ft#{} " .. ft .. " "
      end),
      lsp_server = (function() -- LSP servers
        local lsp_status = ""
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.attached_buffers[vim.api.nvim_get_current_buf()] then
            lsp_status = lsp_status .. client.name .. " "
          end
        end
        return #lsp_status > 0
          and ((vim.o.columns > 100 and "%#St_Lsp# 󰄭  [" .. lsp_status:sub(0, #lsp_status - 1) .. "] ") or "%#St_LspStatus# 󰄭  LSP  ")
          or ""
      end)
    },
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers" },
  }
}

M.term = {
  winopts = { number = false, relativenumber = false },
  sizes = { sp = 0.4, vsp = 0.4, ["bo sp"] = 0.4, ["bo vsp"] = 0.4 },
  float = {
    relative = "editor",
    row = 0.3,
    col = 0.25,
    width = 0.5,
    height = 0.4,
    border = "single",
  },
}

M.lsp = { signature = false }

M.mason = { cmd = false, pkgs = {} }

return M
