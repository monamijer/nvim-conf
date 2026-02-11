local opt = vim.opt
-- Appearance
opt.number = true            -- Show absolute line number
opt.relativenumber = true    -- Show relative line numbers for easy jumping
opt.termguicolors = true     -- Enable 24-bit RGB colors
opt.cursorline = true        -- Highlight the current line
opt.signcolumn = "yes"       -- Always show icons column (prevents flickering)

-- Behavior
opt.mouse = "a"              -- Enable mouse support
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.splitbelow = true        -- Horizontal splits open below
opt.splitright = true        -- Vertical splits open to the right
opt.scrolloff = 8            -- Keep 8 lines visible above/below cursor
opt.updatetime = 250         -- Faster completion and diagnostics display

-- Tabs & Indentation
opt.tabstop = 2              -- Number of spaces a tab counts for
opt.shiftwidth = 2           -- Number of spaces for auto-indent
opt.expandtab = true         -- Convert tabs to spaces
opt.smartindent = true       -- Make indenting smart

-- Search
opt.ignorecase = true        -- Case insensitive search...
opt.smartcase = true         -- ...unless capital letters are used

vim.opt.scrollof = 8
