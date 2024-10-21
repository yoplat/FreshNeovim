dofile(vim.g.base46_cache .. "nvimtree")

local options = {
  -- filters = { dotfiles = false },
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    width = 30,
    preserve_window_proportions = true,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = false,
    indent_markers = { enable = true },
    icons = {
      show = {
        git = false,
        folder_arrow = false,
      },
      glyphs = {
        default = "󰈚",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
        },
        -- git = { unmerged = "" },
      },
    },
  },
  git = {
    enable = false,
  },
  actions = {
    change_dir = {
      enable = true,
      global = true,
    },
  },
  on_attach = function(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
      return {
        desc = "nvim-tree: " .. desc,
        buffer = bufnr,
        noremap = true,
        silent = true,
        nowait = true,
      }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set("n", "<bs>", api.tree.change_root_to_parent, opts "Up")
    vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
    vim.keymap.set("n", ".", api.tree.change_root_to_node, opts "CD")
    vim.keymap.set("n", "r", api.fs.rename_basename, opts "Rename")
    vim.keymap.set("n", "R", api.fs.rename, opts "Rename")
  end,
}

return options
