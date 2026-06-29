-- =============================================================================
--  core/autocmds.lua
-- =============================================================================

local function augroup(name)
  return vim.api.nvim_create_augroup("nvim_" .. name, { clear = true })
end

-- ---------------------------------------------------------------------------
-- Highlight yanked text
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
    local mark   = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Auto-resize splits on terminal resize
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimResized", {
  group    = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- ---------------------------------------------------------------------------
-- FIX: Remove trailing whitespace on save
-- Guard: only run on normal modifiable buffers (avoids E21 on read-only bufs)
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = augroup("trim_whitespace"),
  callback = function()
    -- Skip non-modifiable, special buffers, and markdown
    if not vim.bo.modifiable then return end
    if vim.bo.buftype ~= "" then return end
    local ft = vim.bo.filetype
    if ft == "markdown" or ft == "text" then return end

    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
  end,
})

-- ---------------------------------------------------------------------------
-- Auto-create parent directories on save
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
-- Close utility windows with <q>
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("close_with_q"),
  pattern = {
    "qf", "help", "man", "notify", "lspinfo",
    "startuptime", "checkhealth", "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>",
      { buffer = event.buf, silent = true })
  end,
})

-- ---------------------------------------------------------------------------
-- Terminal: no line numbers, auto start insert
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
-- Auto-save on focus lost (only for normal named buffers)
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group    = augroup("auto_save"),
  callback = function()
    if vim.bo.modified
      and vim.bo.modifiable
      and vim.bo.buftype == ""
      and vim.fn.expand("%") ~= ""
    then
      vim.cmd("silent! write")
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Live-reload config on save (only for your own nvim lua files)
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePost", {
  group   = augroup("reload_config"),
  pattern = vim.fn.stdpath("config") .. "/lua/**/*.lua",
  callback = function()
    -- Don't reload during plugin install
    if vim.g.lazy_did_setup then
      vim.notify("🔄 Config saved", vim.log.levels.INFO)
    end
  end,
})
