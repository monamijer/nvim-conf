-- ~/.config/nvim/init.lua

-- 1. Basics first
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Bootstrap Lazy.nvim (The engine)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load Options (basic behavior, no plugins needed)
-- Wrap in pcall (protected call) to prevent crashing if file is missing
pcall(require, "core.options")

-- 4. Setup Lazy (This is what provides the :Lazy command)
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  print("Lazy is not installed! Check Step 1 above.")
  return
end

lazy.setup("plugins")

-- 5. Load Keymaps
pcall(require, "core.keymaps")
-- This makes the 'active' indentation line stand out
vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7" })
