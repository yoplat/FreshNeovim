local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("v", ";", ":", { desc = "enter command mode", nowait = true })
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "quit neovim" })
map("n", "<leader>qw", "<cmd> q <cr>", { desc = "quit window" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

-- Moving between windows
map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- Save file
map("n", "<C-s>", "<cmd>w<CR>", { desc = "file save" })

-- Buffer management
map("n", "<leader>x", function()
  require("utils").close_buffer()
end, { desc = "buffer close" })
map("n", "L", function()
  require("utils").next_buf()
end, { desc = "buffer next" })
map("n", "H", function()
  require("utils").prev_buf()
end, { desc = "buffer prev" })

-- Persistence
map("n", "<leader>qr", function()
  require("persistence").load()
end, { desc = "Restore Dir Session" })
map("n", "<leader>qs", function()
  require("persistence").select()
end, { desc = "Select Restore" })
map("n", "<leader>ql", function()
  require("persistence").load { last = true }
end, { desc = "Restore Last Session" })

-- Lazy
map("n", "<leader>l", "<cmd> Lazy <CR>", { desc = "Lazy" })

-- nvimtree
map(
  "n",
  "<leader>e",
  "<cmd>NvimTreeToggle<CR>",
  { desc = "nvimtree toggle window" }
)

-- telescope
-- stylua: ignore start
map("n", "<leader><leader>", "<cmd>Telescope find_files<CR>", { desc = "telescope find files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "telescope keymaps" })
map("n", "<leader>ft",function ()
  require("nvchad.themes").open()
end, { desc = "Find themes"})
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find recent" })
map("n", "<leader>fh", "<cmd>Telescope highlights<CR>", { desc = "telescope find highlights" })
map("n", "<leader>fp", "<cmd>Telescope zoxide list<CR>", { desc = "telescope find project" })
-- map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
-- map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
-- map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
-- map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
-- map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

-- trouble
map("n", "gr", "<cmd> Trouble lsp_references <cr>", { desc = "Goto References" })
map("n", "ge", "<cmd> Trouble diagnostics_buffer <cr>", { desc = "File Diagnostics" })
map("n", "gE", "<cmd> Trouble diagnostics <cr>", { desc = "Project Diagnostics" })
map("n", "gt", "<cmd> TodoTrouble <cr>", { desc = "Todo Trouble" })
map("n", "gd", "<cmd> Trouble lsp_definitions <cr>", { desc = "LSP Definition" })
-- stylua: ignore end

-- terminal
-- ["<C-l>"] = { "<C-\\><C-N><C-w>l", "Window Right" }, -- Not enabled to clear the screen
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Window Left" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Window Down" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Window Up" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical window" })

-- toggle terminals
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal new horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- blankline
map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(
        vim.api.nvim_get_current_win(),
        { start_row + 1, 0 }
      )
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })

-- git
map("n", "<leader>gg", "<cmd> Neogit <cr>", { desc = "Neogit" })

-- ufo: folds
-- stylua: ignore start
map("n", "zr", function() require("ufo").openAllFolds() end, { desc = "Open All Folds" })
map("n", "zm", function() require("ufo").closeAllFolds() end, { desc = "Close All Folds" })
map("n", "K", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = "Peek Fold" })
-- stylua: ignore end
