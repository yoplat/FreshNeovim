local opt = vim.opt

vim.g.mapleader = " "

opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.cmdheight = 0 -- Cmdline height (set to 0 by noice)
opt.colorcolumn = "80" -- Line length marker
opt.completeopt = "menu,menuone,preview"
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = { eob = " " } -- Remove strange characters for empty space
opt.foldcolumn = "0" -- Enable fold column
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.vim.treesitter.foldtext()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- Don't show status line (have autocmd to show it after alpha)
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 0 -- Popub blend (Completition window)
opt.pumheight = 12 -- Maximum number of entries in a popup (Completition window)
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Removes cursor position info in bottom-right
opt.scrolloff = 8 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shell = "/bin/zsh"
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append {
  I = true, -- No splash screen
  c = true, -- Do not give |ins-completion-menu| messages.
  C = true, -- Do not give other |ins-completion-menu| messages.
}
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 0 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.splitkeep = "screen"
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = false -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.viewoptions = { "cursor", "folds" }
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- vim.api.nvim_set_hl(0, "WinBar", { cterm = nil }) -- No dropbar bold font

-- disable some default providers
local g = vim.g
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep)
  .. delim
  .. vim.env.PATH
