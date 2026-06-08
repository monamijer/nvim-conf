-- =============================================================================
--  core/options.lua
--  All vim.opt settings — sensible defaults for a next-gen IDE
-- =============================================================================

local opt = vim.opt

-- ---------------------------------------------------------------------------
-- Appearance
-- ---------------------------------------------------------------------------
opt.termguicolors  = true         -- 24-bit RGB colour
opt.number         = true         -- Absolute line number on current line
opt.relativenumber = true         -- Relative numbers for fast jump targeting
opt.cursorline     = true         -- Highlight the active line
opt.signcolumn     = "yes:2"      -- Always-on gutter (2-wide: LSP + git)
opt.colorcolumn    = "100"        -- Ruler at 100 chars
opt.showmode       = false        -- Mode shown in statusline, not command area
opt.cmdheight      = 0            -- Hide cmdline when not in use (Neovim 0.8+)
opt.pumheight      = 12           -- Max items in completion popup
opt.winblend       = 0            -- Opaque floating windows (theme-consistent)
opt.conceallevel   = 2            -- Hide markup in Markdown/JSON

-- ---------------------------------------------------------------------------
-- Behaviour
-- ---------------------------------------------------------------------------
opt.mouse          = "a"          -- Full mouse support
opt.clipboard      = "unnamedplus"-- Sync with OS clipboard
opt.updatetime     = 200          -- Faster CursorHold (diagnostics / git signs)
opt.timeoutlen     = 300          -- Faster which-key popup
opt.splitbelow     = true         -- Horizontal splits open below
opt.splitright     = true         -- Vertical splits open to the right
opt.scrolloff      = 8            -- Keep 8 lines above/below cursor
opt.sidescrolloff  = 8            -- Keep 8 cols left/right of cursor
opt.wrap           = false        -- No line wrapping
opt.virtualedit    = "block"      -- Free cursor in visual-block mode
opt.confirm        = true         -- Ask to save instead of failing
opt.undofile       = true         -- Persistent undo across sessions
opt.undolevels     = 10000        -- Deep undo history
opt.backup         = false        -- Don't keep backup files
opt.swapfile       = false        -- Don't use swapfiles (git is enough)

-- ---------------------------------------------------------------------------
-- Search
-- ---------------------------------------------------------------------------
opt.ignorecase     = true         -- Case-insensitive search…
opt.smartcase      = true         -- …unless uppercase letter typed
opt.hlsearch       = true         -- Highlight matches
opt.incsearch      = true         -- Incremental search

-- ---------------------------------------------------------------------------
-- Indentation & Formatting
-- ---------------------------------------------------------------------------
opt.tabstop        = 2            -- Tab = 2 spaces wide
opt.shiftwidth     = 2            -- Indent step
opt.softtabstop    = 2
opt.expandtab      = true         -- Convert tabs to spaces
opt.smartindent    = true         -- Smart auto-indent
opt.shiftround     = true         -- Round indent to shiftwidth multiple
opt.formatoptions  = "jcroqlnt"   -- Sensible auto-format flags

-- ---------------------------------------------------------------------------
-- Folding (uses Treesitter when available)
-- ---------------------------------------------------------------------------
opt.foldmethod     = "expr"
opt.foldexpr       = "nvim_treesitter#foldexpr()"
opt.foldlevel      = 99           -- Start with all folds open
opt.foldlevelstart = 99

-- ---------------------------------------------------------------------------
-- Completion
-- ---------------------------------------------------------------------------
opt.completeopt    = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")         -- No completion messages in cmdline

-- ---------------------------------------------------------------------------
-- Wild menu / command-line
-- ---------------------------------------------------------------------------
opt.wildmode       = "longest:full,full"
opt.wildignorecase = true

-- ---------------------------------------------------------------------------
-- File handling
-- ---------------------------------------------------------------------------
opt.fileencoding   = "utf-8"
opt.fixendofline   = true

-- ---------------------------------------------------------------------------
-- Neovim provider: Python / Node (faster startup)
-- ---------------------------------------------------------------------------
-- Uncomment and set your Python3 path for faster provider detection:
-- vim.g.python3_host_prog = "/usr/bin/python3"
-- Disable providers you don't use:
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider   = 0
vim.g.loaded_perl_provider   = 0

-- ---------------------------------------------------------------------------
-- Filetype → tab-width overrides
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "rust", "go" },
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})
