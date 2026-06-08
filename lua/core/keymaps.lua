-- =============================================================================
--  core/keymaps.lua
--  Complete keyboard strategy — VS Code muscle memory + Neovim power
--  Leader = <Space>
-- =============================================================================

local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { silent = true, noremap = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- =============================================================================
-- SECTION 1 — IDE ESSENTIALS (VS Code parity)
-- =============================================================================

-- Save
map({ "n", "i", "v" }, "<C-s>",  "<cmd>w<cr><esc>",        { desc = "Save file" })
map("n",               "<leader>w", "<cmd>w<cr>",            { desc = "Save file" })
map("n",               "<leader>W", "<cmd>wa<cr>",           { desc = "Save all buffers" })

-- Quit
map("n", "<leader>q",  "<cmd>q<cr>",                         { desc = "Quit" })
map("n", "<leader>Q",  "<cmd>qa!<cr>",                       { desc = "Force quit all" })

-- Undo / Redo (VS Code style)
map("n", "<C-z>",  "u",           { desc = "Undo" })
map("i", "<C-z>",  "<C-o>u",      { desc = "Undo (insert)" })
map("n", "<C-S-z>","<C-r>",       { desc = "Redo" })
map("i", "<C-S-z>","<C-o><C-r>",  { desc = "Redo (insert)" })

-- Select All
map({ "n", "i" }, "<C-a>", "<esc>ggVG", { desc = "Select all" })

-- New file
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New buffer" })

-- Close buffer (not window)
map("n", "<C-w>", "<cmd>bd<cr>",   { desc = "Close buffer" })

-- =============================================================================
-- SECTION 2 — WINDOW / SPLIT MANAGEMENT
-- =============================================================================

-- Navigate splits (Alt + Arrow)
map("n", "<A-Left>",  "<C-w>h", { desc = "Focus left pane" })
map("n", "<A-Down>",  "<C-w>j", { desc = "Focus pane below" })
map("n", "<A-Up>",    "<C-w>k", { desc = "Focus pane above" })
map("n", "<A-Right>", "<C-w>l", { desc = "Focus right pane" })

-- Resize splits (Ctrl + Arrow)
map("n", "<C-Up>",    "<cmd>resize -2<cr>",          { desc = "Resize up" })
map("n", "<C-Down>",  "<cmd>resize +2<cr>",          { desc = "Resize down" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Resize left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Resize right" })

-- Split creation
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<cr>",  { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=",          { desc = "Equal split sizes" })
map("n", "<leader>sc", "<cmd>close<cr>",  { desc = "Close split" })

-- =============================================================================
-- SECTION 3 — BUFFER / TAB NAVIGATION
-- =============================================================================

map("n", "<S-l>",  "<cmd>bnext<cr>",          { desc = "Next buffer" })
map("n", "<S-h>",  "<cmd>bprevious<cr>",      { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>",         { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Close other buffers" })

-- Jump to buffer by number (Alt+1 .. Alt+9)
for i = 1, 9 do
  map("n", "<A-" .. i .. ">", "<cmd>BufferLineGoToBuffer " .. i .. "<cr>",
    { desc = "Buffer " .. i })
end

-- =============================================================================
-- SECTION 4 — EDITING QUALITY OF LIFE
-- =============================================================================

-- Keep visual selection after indent
map("v", "<", "<gv", { desc = "Indent left (stay selected)" })
map("v", ">", ">gv", { desc = "Indent right (stay selected)" })

-- Move lines (Alt + J/K)
map("n", "<A-j>", "<cmd>m .+1<cr>==",        { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",        { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",        { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",        { desc = "Move selection up" })

-- Paste without overwriting register
map("v", "p", '"_dP', { desc = "Paste (keep register)" })

-- Delete without yanking to register
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete (no yank)" })

-- Better up/down on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })

-- Clear search highlight
map("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "Clear search highlight" })

-- Center on jump
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n",     "nzzzv",   { desc = "Next match (centered)" })
map("n", "N",     "Nzzzv",   { desc = "Prev match (centered)" })

-- Duplicate line
map("n", "<leader>dl", "yyp",   { desc = "Duplicate line down" })
map("n", "<leader>dL", "yyP",   { desc = "Duplicate line up" })

-- =============================================================================
-- SECTION 5 — SIDEBAR / PANELS
-- =============================================================================

-- Explorer (VS Code Ctrl+B)
map("n", "<C-b>", "<cmd>NvimTreeToggle<cr>",  { desc = "Toggle Explorer" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<cr>", { desc = "Focus Explorer" })
map("n", "<leader>ef","<cmd>NvimTreeFindFile<cr>",{ desc = "Reveal file in Explorer" })

-- =============================================================================
-- SECTION 6 — SEARCH & NAVIGATION (Telescope)
-- =============================================================================

-- Files & projects
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",              { desc = "Find files" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",                { desc = "Recent files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",               { desc = "Live grep" })
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>",             { desc = "Search word under cursor" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",                 { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",               { desc = "Help tags" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>",                 { desc = "Keymaps" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>",                { desc = "Commands" })
map("n", "<leader>fp", "<cmd>Telescope projects<cr>",                { desc = "Projects" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>",             { desc = "Diagnostics" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",    { desc = "Document symbols" })
map("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>",   { desc = "Workspace symbols" })
map("n", "<leader>fm", "<cmd>Telescope marks<cr>",                   { desc = "Marks" })

-- Git via Telescope
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>",             { desc = "Git commits" })
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>",            { desc = "Git branches" })
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>",              { desc = "Git status" })

-- =============================================================================
-- SECTION 7 — LSP (GoTo, Docs, Refactor)
-- =============================================================================

-- These fire after LSP attaches — see plugins/lsp.lua on_attach
-- They're defined here for documentation + which-key groups
map("n", "gd",         "<cmd>Telescope lsp_definitions<cr>",         { desc = "Go to definition" })
map("n", "gD",         vim.lsp.buf.declaration,                       { desc = "Go to declaration" })
map("n", "gr",         "<cmd>Telescope lsp_references<cr>",           { desc = "References" })
map("n", "gi",         "<cmd>Telescope lsp_implementations<cr>",      { desc = "Go to implementation" })
map("n", "gt",         "<cmd>Telescope lsp_type_definitions<cr>",     { desc = "Go to type definition" })
map("n", "K",          vim.lsp.buf.hover,                             { desc = "Hover docs" })
map("n", "<C-k>",      vim.lsp.buf.signature_help,                   { desc = "Signature help" })
map("n", "<leader>rn", vim.lsp.buf.rename,                            { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action,                       { desc = "Code action" })
map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format file" })
map("n", "<leader>cd", vim.diagnostic.open_float,                     { desc = "Line diagnostics" })
map("n", "[d",         vim.diagnostic.goto_prev,                      { desc = "Prev diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,                      { desc = "Next diagnostic" })
map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })
map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })

-- =============================================================================
-- SECTION 8 — TERMINAL
-- =============================================================================

-- Toggle terminal (bottom, float, vertical)
map("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>",      { desc = "Float terminal" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",   { desc = "Vertical terminal" })
map("n", "<C-`>",      "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Toggle terminal (VS Code)" })

-- Escape from terminal mode
map("t", "<esc>",        [[<C-\><C-n>]],     { desc = "Exit terminal mode" })
map("t", "<C-h>",        [[<Cmd>wincmd h<cr>]], { desc = "Terminal: focus left" })
map("t", "<C-j>",        [[<Cmd>wincmd j<cr>]], { desc = "Terminal: focus below" })
map("t", "<C-k>",        [[<Cmd>wincmd k<cr>]], { desc = "Terminal: focus above" })
map("t", "<C-l>",        [[<Cmd>wincmd l<cr>]], { desc = "Terminal: focus right" })

-- =============================================================================
-- SECTION 9 — GIT (Gitsigns)
-- =============================================================================

map("n", "<leader>gp",  "<cmd>Gitsigns preview_hunk<cr>",            { desc = "Preview hunk" })
map("n", "<leader>gr",  "<cmd>Gitsigns reset_hunk<cr>",              { desc = "Reset hunk" })
map("n", "<leader>gR",  "<cmd>Gitsigns reset_buffer<cr>",            { desc = "Reset buffer" })
map("n", "<leader>gS",  "<cmd>Gitsigns stage_hunk<cr>",              { desc = "Stage hunk" })
map("n", "<leader>gu",  "<cmd>Gitsigns undo_stage_hunk<cr>",         { desc = "Undo stage hunk" })
map("n", "<leader>gbl", "<cmd>Gitsigns blame_line<cr>",              { desc = "Blame line" })
map("n", "<leader>gd",  "<cmd>Gitsigns diffthis<cr>",                { desc = "Diff this" })
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next git hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev git hunk" })

-- =============================================================================
-- SECTION 10 — AI (Copilot + optional Avante/CodeCompanion)
-- =============================================================================

-- Copilot: accept with Ctrl+J (avoids Tab conflict with CMP)
map("i", "<C-j>", function()
  local ok, sug = pcall(require, "copilot.suggestion")
  if ok and sug.is_visible() then
    sug.accept()
  else
    local key = vim.api.nvim_replace_termcodes("<C-j>", true, true, true)
    vim.api.nvim_feedkeys(key, "n", false)
  end
end, { desc = "Copilot: accept suggestion" })

map("i", "<C-]>", function()
  local ok, sug = pcall(require, "copilot.suggestion")
  if ok then sug.next() end
end, { desc = "Copilot: next suggestion" })

map("i", "<C-[>", function()
  local ok, sug = pcall(require, "copilot.suggestion")
  if ok then sug.prev() end
end, { desc = "Copilot: prev suggestion" })

map("i", "<C-e>", function()
  local ok, sug = pcall(require, "copilot.suggestion")
  if ok then sug.dismiss() end
end, { desc = "Copilot: dismiss suggestion" })

-- AI Chat panel
map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>",  { desc = "AI: Action palette" })
map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat<cr>",     { desc = "AI: Chat" })
map("v",           "<leader>ae", "<cmd>CodeCompanion /explain<cr>",{ desc = "AI: Explain selection" })
map("v",           "<leader>af", "<cmd>CodeCompanion /fix<cr>",    { desc = "AI: Fix selection" })
map("v",           "<leader>ar", "<cmd>CodeCompanion /refactor<cr>",{ desc = "AI: Refactor selection" })
map("v",           "<leader>at", "<cmd>CodeCompanion /tests<cr>",  { desc = "AI: Generate tests" })
map("n",           "<leader>ad", "<cmd>CodeCompanion /docstring<cr>",{ desc = "AI: Generate docstring" })

-- =============================================================================
-- SECTION 11 — UTILITIES
-- =============================================================================

-- Trouble (diagnostics panel)
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>",                     { desc = "Trouble toggle" })
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",{ desc = "Workspace diagnostics" })
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",             { desc = "Quickfix list" })

-- Todo comments
map("n", "]t",  function() require("todo-comments").jump_next() end,  { desc = "Next TODO" })
map("n", "[t",  function() require("todo-comments").jump_prev() end,  { desc = "Prev TODO" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>",                      { desc = "Find TODOs" })

-- Session management
map("n", "<leader>Ss", "<cmd>SessionSave<cr>",    { desc = "Save session" })
map("n", "<leader>Sr", "<cmd>SessionRestore<cr>", { desc = "Restore session" })
map("n", "<leader>Sd", "<cmd>SessionDelete<cr>",  { desc = "Delete session" })

-- Lazy (plugin manager)
map("n", "<leader>L",  "<cmd>Lazy<cr>",            { desc = "Lazy plugin manager" })
map("n", "<leader>Lu", "<cmd>Lazy update<cr>",     { desc = "Update plugins" })

-- Mason (LSP manager)
map("n", "<leader>M",  "<cmd>Mason<cr>",           { desc = "Mason LSP manager" })

-- Dashboard
map("n", "<leader>H",  "<cmd>Alpha<cr>",           { desc = "Home dashboard" })

-- =============================================================================
-- Which-key groups (labels for the which-key popup)
-- =============================================================================
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end
    wk.register({
      ["<leader>f"]  = { name = "󰍉 Find" },
      ["<leader>g"]  = { name = " Git" },
      ["<leader>s"]  = { name = " Splits" },
      ["<leader>c"]  = { name = " Code / LSP" },
      ["<leader>a"]  = { name = " AI Assistant" },
      ["<leader>t"]  = { name = " Terminal" },
      ["<leader>x"]  = { name = "󰒡 Diagnostics" },
      ["<leader>S"]  = { name = "󰆓 Sessions" },
      ["<leader>b"]  = { name = "󰓩 Buffers" },
      ["<leader>d"]  = { name = "󱃹 Duplicate" },
      ["<leader>e"]  = { name = " Explorer" },
      ["<leader>L"]  = { name = "󰒲 Lazy" },
    })
  end,
})
