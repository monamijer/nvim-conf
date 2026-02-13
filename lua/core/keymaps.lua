local keymap = vim.keymap

-- =============================================================================
-- IDE STYLE SHORTCUTS (Ctrl+S, Ctrl+Z, Copilot)
-- =============================================================================

-- Save file with Ctrl+S (Normal, Insert, and Visual modes)
keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><ESC>", { desc = "Save file" })

-- Undo with Ctrl+Z (Normal and Insert modes)
-- Note: This replaces the default 'Suspend' behavior
keymap.set("n", "<C-z>", "u", { desc = "Undo" })
keymap.set("i", "<C-z>", "<C-O>u", { desc = "Undo in insert mode" })
keymap.set("n", "<C-y>", "<C-r>", { desc = "Redo" })
keymap.set("i", "<C-y>", "<C-o><C-r>", { desc = "Redo in insert mode" })

-- GitHub Copilot: Use Ctrl+J to accept (to avoid Tab conflicts with CMP)
-- We set this here, but ensure 'copilot.lua' or 'copilot.vim' is installed.
keymap.set("i", "<C-j>", function()
  local ok, suggestion = pcall(require, "copilot.suggestion")
  if ok and suggestion.is_visible() then
    suggestion.accept()
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-j>", true, true, true),
      "n",
      false
    )
  end
end, { desc = "Copilot Accept" })
-- =============================================================================
-- EXISTING GENERAL MAPPINGS
-- =============================================================================

keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })


-- Window Navigation (Alt + Arrows)
keymap.set("n", "<A-Left>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<A-Down>", "<C-w>j", { desc = "Move to bottom split" })
keymap.set("n", "<A-Up>", "<C-w>k", { desc = "Move to top split" })
keymap.set("n", "<A-Right>", "<C-w>l", { desc = "Move to right split" })

-- Using 'v' for Vertical and 's' for Horizontal
keymap.set("n", "<leader>v", ":vsplit<CR>", { desc = "Split Vertically", silent = true })
keymap.set("n", "<leader>s", ":split<CR>", { desc = "Split Horizontally", silent = true })

-- Ctrl + B for open/close the file manager
keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer", silent = true })

-- Buffers (Tabs) navigation
keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Stay in visual mode while indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Move lines
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- =============================================================================
-- TERMINAL MAPPINGS
-- =============================================================================

-- Toggle Terminal (VS Code style)
keymap.set("n", "<leader>t", ":ToggleTerm<CR>", { desc = "Toggle Bottom Terminal" })

-- Better Terminal Navigation
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, {})
end

-- Apply these mappings only when a terminal is open
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
