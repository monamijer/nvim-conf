-- =============================================================================
--  nvim-conf · Next-Generation IDE
--  Entry Point: init.lua
-- =============================================================================

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- Disable netrw (nvim-tree replaces it)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- ---------------------------------------------------------------------------
-- 1. Bootstrap Lazy.nvim
-- ---------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.notify("⚡ Installing Lazy.nvim – first-run setup…", vim.log.levels.INFO)
  local result = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("❌ Lazy.nvim install failed:\n" .. result, vim.log.levels.ERROR)
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------------------------
-- 2. Core modules
-- ---------------------------------------------------------------------------
local function safe_require(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify("⚠  Module failed: " .. mod .. "\n" .. err, vim.log.levels.WARN)
  end
end

safe_require("core.options")
safe_require("core.autocmds")
safe_require("core.keymaps")

-- ---------------------------------------------------------------------------
-- 3. Plugin system
-- ---------------------------------------------------------------------------
require("lazy").setup("plugins", {
  defaults = { lazy = true },

  install = {
    colorscheme = { "tokyonight", "habamax" },
  },

  -- FIX: disable luarocks/hererocks (not needed, removes checkhealth warning)
  rocks = {
    enabled   = false,
    hererocks = false,
  },

  checker = {
    enabled   = true,
    notify    = false,
    frequency = 3600,
  },

  change_detection = { notify = false },

  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },

  ui = {
    border = "rounded",
    title  = "  Plugin Manager",
    icons  = {
      cmd     = "⌘ ", config  = "🛠 ",
      event   = "📅", ft      = "📂",
      init    = "⚙ ", keys    = "🗝 ",
      plugin  = "🔌", runtime = "💻",
      source  = "📄", start   = "🚀",
      task    = "📌", lazy    = "💤 ",
    },
  },
})

-- ---------------------------------------------------------------------------
-- 4. Session management
-- ---------------------------------------------------------------------------
safe_require("workspace.sessions")
