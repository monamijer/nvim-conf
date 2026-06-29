-- =============================================================================
--  core/options.lua
-- =============================================================================

local opt = vim.opt

-- ---------------------------------------------------------------------------
-- Appearance
-- ---------------------------------------------------------------------------
opt.termguicolors  = true
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes:2"
opt.colorcolumn    = "100"
opt.showmode       = false
opt.cmdheight      = 0
opt.pumheight      = 12
opt.winblend       = 0
opt.conceallevel   = 2

-- ---------------------------------------------------------------------------
-- Behaviour
-- ---------------------------------------------------------------------------
opt.mouse          = "a"
opt.clipboard      = "unnamedplus"
opt.updatetime     = 200
opt.timeoutlen     = 300
opt.splitbelow     = true
opt.splitright     = true
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.virtualedit    = "block"
opt.confirm        = true
opt.undofile       = true
opt.undolevels     = 10000
opt.backup         = false
opt.swapfile       = false

-- ---------------------------------------------------------------------------
-- Search
-- ---------------------------------------------------------------------------
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = true
opt.incsearch      = true

-- ---------------------------------------------------------------------------
-- Indentation
-- ---------------------------------------------------------------------------
opt.tabstop        = 2
opt.shiftwidth     = 2
opt.softtabstop    = 2
opt.expandtab      = true
opt.smartindent    = true
opt.shiftround     = true
opt.formatoptions  = "jcroqlnt"

-- ---------------------------------------------------------------------------
-- Folding
-- ---------------------------------------------------------------------------
opt.foldmethod     = "expr"
opt.foldexpr       = "nvim_treesitter#foldexpr()"
opt.foldlevel      = 99
opt.foldlevelstart = 99

-- ---------------------------------------------------------------------------
-- Completion
-- ---------------------------------------------------------------------------
opt.completeopt    = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- ---------------------------------------------------------------------------
-- Wild menu
-- ---------------------------------------------------------------------------
opt.wildmode       = "longest:full,full"
opt.wildignorecase = true

-- ---------------------------------------------------------------------------
-- File handling
-- ---------------------------------------------------------------------------
opt.fileencoding   = "utf-8"
opt.fixendofline   = true

-- ---------------------------------------------------------------------------
-- Providers
-- FIX: explicitly disable unused providers → removes checkhealth warnings
-- ---------------------------------------------------------------------------
vim.g.loaded_python_provider = 0   -- Python 2: not used
vim.g.loaded_ruby_provider   = 0   -- Ruby:     not used
vim.g.loaded_perl_provider   = 0   -- Perl:     not used

-- Python3: disable if pynvim not installed (avoids warning on startup)
-- Once you run: pip install neovim --break-system-packages
-- you can remove the line below
vim.g.loaded_python3_provider = 0

-- Node: disable if neovim npm package not installed (avoids warning)
-- Once you run: npm install -g neovim
-- you can remove the line below
-- vim.g.loaded_node_provider = 0

-- ---------------------------------------------------------------------------
-- Filetype-specific tab widths
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern  = { "python", "rust", "go" },
  callback = function()
    vim.opt_local.tabstop     = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- ---------------------------------------------------------------------------
-- Filetype detection
-- ---------------------------------------------------------------------------
vim.filetype.add({
  extension = {
    env    = "sh",
    mdx    = "markdown",
    prisma = "prisma",
    astro  = "astro",
  },
  filename = {
    [".env"]       = "sh",
    [".env.local"] = "sh",
    ["Dockerfile"] = "dockerfile",
    [".babelrc"]   = "json",
    [".eslintrc"]  = "json",
  },
  pattern = {
    ["%.env%..*"]              = "sh",
    ["docker%-compose.*%.yml"] = "yaml.docker-compose",
  },
})
