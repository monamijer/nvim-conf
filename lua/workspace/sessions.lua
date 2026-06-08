-- =============================================================================
--  workspace/sessions.lua
--  Auto-restore last session when Neovim opens a directory (not a file)
-- =============================================================================

local M = {}

function M.setup()
  -- Only auto-restore when nvim is opened with no file arguments
  -- and there is a session saved for the current directory
  if vim.fn.argc() == 0 and vim.fn.getcwd() ~= vim.env.HOME then
    local ok, persistence = pcall(require, "persistence")
    if ok then
      -- Restore after the UI is fully loaded
      vim.api.nvim_create_autocmd("VimEnter", {
        once     = true,
        callback = function()
          -- Only restore if a session file exists for this dir
          local session_file = persistence.current()
          if session_file and vim.fn.filereadable(session_file) == 1 then
            persistence.load()
          end
        end,
      })
    end
  end
end

M.setup()
return M
