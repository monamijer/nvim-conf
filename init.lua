-- ============================================================================
--  Modern Neovim IDE Bootstrap
--  Entry point for the entire configuration
--  Designed for clarity, safety, and contributor friendliness
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Leader Keys (must be set BEFORE plugins load)
-- ----------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ----------------------------------------------------------------------------
-- 2. Bootstrap Lazy.nvim (plugin manager engine)
--    Safe clone + cross-platform compatible
-- ----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.notify("Installing Lazy.nvim…", vim.log.levels.INFO)

  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to install Lazy.nvim:\n" .. result, vim.log.levels.ERROR)
    return
  end
end

vim.opt.rtp:prepend(lazypath)

-- ----------------------------------------------------------------------------
-- 3. Core Configuration (editor behavior — no plugins required)
--    Protected load prevents startup crashes for new contributors
-- ----------------------------------------------------------------------------
local function safe_require(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify("Module failed to load: " .. module .. "\n" .. err, vim.log.levels.WARN)
  end
end

safe_require("core.options")

-- ----------------------------------------------------------------------------
-- 4. Lazy Setup (plugin system initialization)
-- ----------------------------------------------------------------------------
local ok, lazy = pcall(require, "lazy")
if not ok then
  vim.notify("Lazy.nvim failed to load!", vim.log.levels.ERROR)
  return
end

lazy.setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- ----------------------------------------------------------------------------
-- 5. Keymaps (after plugin manager is initialized)
-- ----------------------------------------------------------------------------
safe_require("core.keymaps")

-- ----------------------------------------------------------------------------
-- 6. UI Enhancements / Highlight tweaks
-- ----------------------------------------------------------------------------
vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7" })

-- ----------------------------------------------------------------------------
-- End of bootstrap
-- ----------------------------------------------------------------------------
