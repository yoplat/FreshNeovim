return {
  -- Nvchad statusline, tabline, terminal and more...
  {
    "NvChad/ui",
    lazy = false,
    config = function()
      require "nvchad"
      require "configs.tabufline_fix"
      vim.schedule(function()
        -- vim.api.nvim_del_user_command "MasonInstallAll"
        vim.api.nvim_create_user_command("MasonInstallAll", function()
          require("configs.lsp.mason_commands").install_all()
        end, {})
      end)
    end,
  },

  -- Nvchad themes!!
  {
    "NvChad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  "nvchad/volt",

  -- Beautiful icons
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  -- Dropbar: navic like winbar
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPre",
    opts = require "configs.dropbar",
  },

  -- Dressing: better input and select
  {
    "stevearc/dressing.nvim", -- TODO: check if needs to be loaded earlier
    opts = function()
      return require("configs.noice").dressing
    end,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },

  -- Noice: better ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        config = function()
          dofile(vim.g.base46_cache .. "notify")
          require("notify").setup(require("configs.noice").notify)
        end,
      },
    },
    opts = function()
      return require("configs.noice").noice
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },

  -- Trouble: better diagnostics
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TodoTrouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      dofile(vim.g.base46_cache .. "trouble")
      local opts = require "configs.trouble"
      require("trouble").setup(opts)
    end,
  },

  {
    "chrisgrieser/nvim-origami",
    event = "BufRead",
    opts = require("configs.fold").origami,
    dependencies = {
      {
        "kevinhwang91/nvim-ufo",
        dependencies = {
          "kevinhwang91/promise-async",
        },
        opts = require("configs.fold").ufo,
      },
    },
  },

  -- Ufo: better folds
}
