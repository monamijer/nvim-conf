-- =============================================================================
--  core/autocmds.lua
--  Autocommands — smart IDE-like behaviour without any plugins
-- =============================================================================

local function augroup(name)
  return vim.api.nvim_create_augroup("nvim_" .. name, { clear = true })
end

-- ---------------------------------------------------------------------------
-- Highlight yanked text (VS Code Ctrl+C flash equivalent)
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = augroup("yank_highlight"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- ---------------------------------------------------------------------------
-- Restore cursor position on file open
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
  group    = augroup("restore_cursor"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Auto-resize splits on window resize
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimResized", {
  group    = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- ---------------------------------------------------------------------------
-- Remove trailing whitespace on save (except markdown)
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group   = augroup("trim_whitespace"),
  pattern = { "*" },
  callback = function()
    local ft = vim.bo.filetype
    if ft ~= "markdown" and ft ~= "text" then
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[%s/\s\+$//e]])
      vim.api.nvim_win_set_cursor(0, pos)
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Auto-create parent directories on save if they don't exist
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = augroup("auto_mkdir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then return end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ---------------------------------------------------------------------------
-- Close certain utility windows with just <q>
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("close_with_q"),
  pattern = {
    "qf", "help", "man", "notify", "lspinfo",
    "startuptime", "tsplayground", "checkhealth",
    "PlenaryTestPopup", "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- ---------------------------------------------------------------------------
-- Terminal: auto-enter insert, no line numbers
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TermOpen", {
  group    = augroup("terminal"),
  callback = function()
    vim.opt_local.number         = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn     = "no"
    vim.cmd("startinsert")
  end,
})

-- ---------------------------------------------------------------------------
-- Auto-save on focus lost (like VS Code)
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group    = augroup("auto_save"),
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Detect config changes and reload (live-reload config files)
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePost", {
  group   = augroup("reload_config"),
  pattern = vim.fn.stdpath("config") .. "/lua/**/*.lua",
  callback = function()
    vim.notify("🔄 Config reloaded", vim.log.levels.INFO)
    dofile(vim.env.MYVIMRC)
  end,
})

-- ---------------------------------------------------------------------------
-- Set filetype hints for uncommon files
-- ---------------------------------------------------------------------------
vim.filetype.add({
  extension = {
    env      = "sh",
    mdx      = "markdown",
    prisma   = "prisma",
    astro    = "astro",
  },
  filename = {
    [".env"]         = "sh",
    [".env.local"]   = "sh",
    ["Dockerfile"]   = "dockerfile",
    [".babelrc"]     = "json",
    [".eslintrc"]    = "json",
  },
  pattern = {
    ["%.env%..*"]        = "sh",
    ["docker%-compose.*%.yml"] = "yaml.docker-compose",
  },
})
