<div align="center">

# ⚡ nvim-conf

**Next-Generation IDE built on Neovim**

*JetBrains intelligence · VS Code usability · AI-native workflows · Neovim speed*

[![Neovim](https://img.shields.io/badge/Neovim-0.10%2B-57A143?style=flat-square&logo=neovim)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Config-Lua-2C2D72?style=flat-square&logo=lua)](https://www.lua.org)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)
[![Last Updated](https://img.shields.io/badge/Updated-Daily-green?style=flat-square)](#changelog)

</div>

---

## Table of Contents

- [Philosophy](#philosophy)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [First Launch](#first-launch)
- [Directory Structure](#directory-structure)
- [Configuration](#configuration)
  - [Theme](#theme)
  - [AI Providers](#ai-providers)
  - [LSP Servers](#lsp-servers)
  - [Keybindings](#keybindings)
  - [Panels & Layout](#panels--layout)
- [Language Support](#language-support)
- [AI Integration](#ai-integration)
- [Keyboard Shortcuts](#keyboard-shortcuts)
- [Workspace Management](#workspace-management)
- [Debugging](#debugging)
- [Testing](#testing)
- [Plugin Architecture](#plugin-architecture)
- [Performance](#performance)
- [Updating](#updating)
- [Troubleshooting](#troubleshooting)
- [Changelog](#changelog)

---

## Philosophy

This configuration treats Neovim not as a text editor, but as a **development platform**. Every decision is guided by three principles:

1. **Speed first** — startup under 80ms, every plugin lazy-loaded
2. **IDE parity** — nothing you can do in VS Code or IntelliJ that you can't do here
3. **AI-native** — AI assistance woven into every workflow, not bolted on

---

## Features

| Category | What's included |
|---|---|
| **UI** | Tokyo Night theme · Premium dashboard · VS Code-style bufferline · Breadcrumb winbar · Scrollbar with diagnostics |
| **Explorer** | nvim-tree with git status · diagnostics · file icons |
| **Statusline** | Lualine with git branch · LSP diagnostics · Copilot status · build info |
| **Language Intel** | Native LSP · Treesitter · Inlay hints · Auto-format on save · Semantic highlighting |
| **AI** | GitHub Copilot inline · CodeCompanion chat (Claude/GPT-4/Gemini/Ollama) |
| **Completion** | nvim-cmp · Copilot · Snippets (VS Code compatible) · Signature help |
| **Git** | Gitsigns · Inline blame · Hunk preview · LazyGit TUI |
| **Search** | Telescope fuzzy finder · Live grep · Project-wide find & replace (Spectre) |
| **Debugging** | DAP with UI · JS/TS/PHP/Python/Go/C++ · Breakpoints · Virtual text |
| **Testing** | Neotest · Jest · PHPUnit · Pytest · Vitest |
| **Refactoring** | Extract function/variable · Inline variable · Multi-cursor (Ctrl+D) |
| **Navigation** | Harpoon bookmarks · Flash jump · Treesitter text objects |
| **Terminals** | ToggleTerm · Float / horizontal / vertical · Multiple instances |
| **Sessions** | Auto-save/restore per project directory |
| **Notifications** | Noice · nvim-notify · Beautiful floating messages |

---

## Requirements

### Required

| Tool | Version | Install |
|---|---|---|
| **Neovim** | ≥ 0.10 | [neovim.io](https://neovim.io) |
| **Git** | ≥ 2.38 | Package manager |
| **Node.js** | ≥ 18 LTS | [nodejs.org](https://nodejs.org) |
| **A Nerd Font** | Any v3 | [nerdfonts.com](https://www.nerdfonts.com) |
| **ripgrep** | Latest | `brew install ripgrep` / `apt install ripgrep` |
| **fd** | Latest | `brew install fd` / `apt install fd-find` |

### Recommended

| Tool | Purpose |
|---|---|
| **lazygit** | Full git TUI (`<leader>gg`) |
| **Python 3** | Python LSP + DAP |
| **PHP 8.2+** | PHP LSP + formatter |
| **Go** | Go LSP + debugger |
| **Rust / cargo** | Rust LSP |
| **clang** | C/C++ LSP + formatter |

### Optional (AI)

| Tool | Purpose |
|---|---|
| `ANTHROPIC_API_KEY` env var | Claude (recommended) |
| `OPENAI_API_KEY` env var | GPT-4o |
| `GEMINI_API_KEY` env var | Gemini 2.0 |
| **Ollama** | Local LLMs (100% private) |

---

## Installation

### Step 1 — Back up existing config

```bash
# Back up if you have an existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

### Step 2 — Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/nvim-conf.git ~/.config/nvim
```

### Step 3 — Set your API keys (optional but recommended)

Add to your `~/.bashrc`, `~/.zshrc`, or `~/.profile`:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."   # Claude
export OPENAI_API_KEY="sk-..."          # GPT-4o
export GEMINI_API_KEY="AIza..."         # Gemini
```

### Step 4 — Launch Neovim

```bash
nvim
```

**On first launch**, Lazy.nvim will automatically:
- Install all plugins (~60 packages)
- Download and compile Treesitter parsers
- Open Mason to install LSP servers

This takes 2–4 minutes. **Do not quit** until it's complete.

### Step 5 — Install LSP servers

After the first-launch setup, install language servers:

```vim
:Mason
```

Press `i` on any server to install it, or use the auto-install (all servers in `ensure_installed` are installed automatically).

### Step 6 — Activate Copilot (optional)

```vim
:Copilot auth
```

Follow the browser prompt to authenticate with GitHub.

---

## First Launch

When you open Neovim with no file, you see the **Dashboard**:

```
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
...
        ⚡  Next-Generation IDE  ·  nvim-conf

  n  New file
  SPC ff  Find file
  SPC fr  Recent files
  SPC fg  Live grep
  SPC fp  Projects
  SPC Sr  Restore session
  L   Plugin manager
  M   Mason (LSPs)
  q   Quit
```

The footer shows your Neovim version and how many plugins are loaded.

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                    ← Entry point (bootstrap + load order)
├── lazy-lock.json              ← Plugin version lock file (commit this!)
├── coc-settings.json           ← Legacy compatibility (not used)
│
└── lua/
    ├── core/
    │   ├── options.lua         ← Editor settings (indent, search, UI)
    │   ├── keymaps.lua         ← All keyboard shortcuts
    │   └── autocmds.lua        ← Autocommands (format-on-save, etc.)
    │
    ├── plugins/
    │   ├── ui.lua              ← Theme, dashboard, statusline, explorer
    │   ├── lsp.lua             ← LSP, Mason, Treesitter, completion
    │   ├── utils.lua           ← Git, search, DAP, test, refactoring
    │   └── ai.lua              ← Copilot, CodeCompanion, AI workflows
    │
    └── workspace/
        └── sessions.lua        ← Auto session restore
```

---

## Configuration

### Theme

Change the theme in `lua/plugins/ui.lua`:

```lua
-- Available styles: "night" | "storm" | "moon" | "day"
opts = {
  style = "night",
  transparent = false,  -- Set true for transparent background
}
```

To switch to a completely different theme, replace the `tokyonight` block with your preferred plugin (catppuccin, gruvbox, rose-pine, etc.) and update `vim.cmd("colorscheme ...")`.

### AI Providers

Configure in `lua/plugins/ai.lua` under `strategies`:

```lua
strategies = {
  chat   = { adapter = "anthropic" },  -- Chat panel provider
  inline = { adapter = "copilot" },    -- Inline ghost text
  agent  = { adapter = "anthropic" },  -- Agentic tasks
},
```

Available adapters: `"anthropic"`, `"openai"`, `"gemini"`, `"ollama"`

To use Ollama with a specific model:

```lua
ollama = function()
  return require("codecompanion.adapters").extend("ollama", {
    schema = { model = { default = "deepseek-coder:6.7b" } },
  })
end,
```

### LSP Servers

LSP servers are defined in `lua/plugins/lsp.lua` under `ensure_installed`:

```lua
ensure_installed = {
  "ts_ls",       -- TypeScript/JavaScript
  "intelephense", -- PHP
  "lua_ls",      -- Lua
  -- add more from: https://mason-registry.dev/registry/list
},
```

Add a new server with custom config:

```lua
handlers = {
  my_server = function()
    lspconfig.my_server.setup({
      capabilities = capabilities,
      on_attach    = make_on_attach(),
      settings = { ... },
    })
  end,
}
```

### Keybindings

All keybindings are in `lua/core/keymaps.lua`. They're organized in sections:

- `SECTION 1` — IDE essentials (save, quit, undo)
- `SECTION 2` — Window/split management
- `SECTION 3` — Buffer/tab navigation
- `SECTION 4` — Editing quality of life
- `SECTION 5` — Sidebar/panels
- `SECTION 6` — Search & navigation (Telescope)
- `SECTION 7` — LSP (goto, docs, refactor)
- `SECTION 8` — Terminal
- `SECTION 9` — Git (Gitsigns)
- `SECTION 10` — AI (Copilot + CodeCompanion)
- `SECTION 11` — Utilities

Add a custom keybinding anywhere:

```lua
map("n", "<leader>xx", "<cmd>MyCommand<cr>", { desc = "My command" })
```

### Panels & Layout

| Panel | Toggle | Focus |
|---|---|---|
| File Explorer | `Ctrl+B` | `<leader>e` |
| Terminal (float) | `<leader>tt` or `Ctrl+\`` | — |
| Terminal (split) | `<leader>th` | — |
| Diagnostics (Trouble) | `<leader>xx` | — |
| AI Chat | `<leader>ac` | — |
| Git (LazyGit) | `<leader>gg` | — |
| Debug UI | `<leader>du` | — |
| Test Summary | `<leader>ts` | — |

---

## Language Support

### JavaScript / TypeScript / React / Next.js

- **LSP**: `ts_ls` — completions, go-to-def, refactoring, inlay hints
- **Linting**: ESLint (auto-fix on save)
- **Formatting**: Prettier
- **Snippets**: ES6, React hooks, JSX
- **Debug**: Chrome + Node via `js-debug-adapter`
- **Test**: Jest / Vitest via Neotest

### PHP / Laravel / Filament

- **LSP**: Intelephense with Laravel stubs
- **Formatting**: PHP-CS-Fixer (PSR-12)
- **Linting**: phpcs
- **Debug**: Xdebug via `php-debug-adapter`
- **Test**: PHPUnit via Neotest
- **Blades**: Syntax + Emmet expansions

### Vue / Svelte

- **Vue**: Volar (Vue 3 + Composition API)
- **Svelte**: svelte-language-server
- Both support CSS/SCSS/TypeScript embedded blocks

### HTML / CSS / SCSS / TailwindCSS

- **HTML**: htmlls + Emmet
- **CSS/SCSS**: cssls
- **Tailwind**: Full class completion + color preview + linting
- **Color highlighting**: Inline hex/rgb/named color preview

### C / C++

- **LSP**: clangd (background indexing, tidy checks, include-what-you-use)
- **Formatting**: clang-format
- **Debug**: codelldb

### Python

- **LSP**: Pyright (strict type checking)
- **Formatting**: Black + isort
- **Debug**: debugpy
- **Test**: Pytest

### Lua (Neovim config)

- **LSP**: lua-language-server (knows Neovim API)
- **Formatting**: stylua

---

## AI Integration

### Inline Completions (Copilot)

Copilot suggests code as ghost text as you type.

| Action | Key |
|---|---|
| Accept suggestion | `Ctrl+J` |
| Accept next word | `Ctrl+Right` |
| Accept next line | `Ctrl+Down` |
| Next suggestion | `Ctrl+]` |
| Prev suggestion | `Ctrl+[` |
| Dismiss | `Ctrl+E` |

### AI Chat Panel

Open with `<leader>ac`. Type your question. The panel opens as a vertical split.

**Switch models mid-chat:**

Type `/model` in the chat to switch between Claude, GPT-4, Gemini, or Ollama.

### AI Quick Actions

Select code in Visual mode, then:

| Key | Action |
|---|---|
| `<leader>ae` | Explain the selected code |
| `<leader>af` | Fix bugs in the selection |
| `<leader>ar` | Refactor the selection |
| `<leader>at` | Generate tests for the selection |
| `<leader>ao` | Optimize the selection |
| `<leader>aR` | Code review the selection |

On a function (Normal mode):

| Key | Action |
|---|---|
| `<leader>ad` | Generate JSDoc/PHPDoc/docstring |
| `<leader>aa` | Open full AI action palette |

### Using Ollama (Offline / Private)

1. Install Ollama: https://ollama.com
2. Pull a model: `ollama pull codellama`
3. In `lua/plugins/ai.lua`, set `strategies.chat.adapter = "ollama"`

No API key needed. Runs 100% locally.

---

## Keyboard Shortcuts

### Essential (learn these first)

| Key | Action |
|---|---|
| `Space` | Leader key |
| `Ctrl+S` | Save file |
| `Ctrl+B` | Toggle file explorer |
| `Ctrl+\`` | Toggle terminal |
| `Space ff` | Find files |
| `Space fg` | Live grep (search in project) |
| `Space fr` | Recent files |
| `K` | Show hover docs |
| `gd` | Go to definition |
| `gr` | Find references |
| `Space rn` | Rename symbol |
| `Space ca` | Code action |
| `Space cf` | Format file |

### Navigation

| Key | Action |
|---|---|
| `Shift+L` | Next buffer |
| `Shift+H` | Previous buffer |
| `Alt+1..9` | Jump to buffer 1–9 |
| `s` | Flash jump (type 2 chars to jump anywhere) |
| `Ctrl+D` | Multi-cursor (VS Code Ctrl+D) |
| `Space fp` | Switch project |
| `Space ha` | Add file to Harpoon |
| `Space hh` | Harpoon file menu |

### Git

| Key | Action |
|---|---|
| `Space gg` | LazyGit (full TUI) |
| `Space gs` | Git status (Telescope) |
| `Space gc` | Git commits (Telescope) |
| `Space gb` | Git branches (Telescope) |
| `Space gp` | Preview hunk |
| `Space gS` | Stage hunk |
| `]h` / `[h` | Next / prev hunk |
| `Space gbl` | Blame current line |

### Diagnostics

| Key | Action |
|---|---|
| `Space xx` | Toggle diagnostics panel |
| `Space cd` | Show line diagnostics |
| `]d` / `[d` | Next / prev diagnostic |
| `]e` / `[e` | Next / prev error |
| `Space fd` | Search diagnostics |

### Debugging

| Key | Action |
|---|---|
| `F5` | Start / Continue debug |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |
| `Space db` | Toggle breakpoint |
| `Space dB` | Conditional breakpoint |
| `Space du` | Toggle debug UI |

### Testing

| Key | Action |
|---|---|
| `Space tr` | Run nearest test |
| `Space tR` | Run all tests in file |
| `Space ts` | Test summary panel |
| `Space to` | Test output |

---

## Workspace Management

### Sessions

Sessions are **automatically saved per project directory**. When you open Neovim in a directory that has a saved session, it restores your buffers, splits, and cursor positions.

| Key | Action |
|---|---|
| `Space Sr` | Restore session manually |
| `Space Ss` | Save session manually |
| `Space Sd` | Delete session |

### Projects

Use `<leader>fp` to open the Projects picker (powered by `telescope-project.nvim`).

Projects are detected automatically from `~/projects`, `~/work`, and `~/code`. Add your directories in `lua/plugins/utils.lua`:

```lua
project = {
  base_dirs = {
    "~/projects",
    "~/my-custom-dir",
  },
}
```

### Splits & Panels

| Key | Action |
|---|---|
| `Space sv` | Split vertical |
| `Space sh` | Split horizontal |
| `Space se` | Equalize split sizes |
| `Space sc` | Close split |
| `Alt+Arrow` | Focus split by direction |
| `Ctrl+Arrow` | Resize split |

---

## Debugging

### Quick Start

1. Open a file
2. Set a breakpoint: `<leader>db`
3. Press `F5` to start
4. The debug UI opens automatically
5. Use `F10` (step over), `F11` (step into), `F12` (step out)
6. Hover a variable and press `<leader>de` to evaluate

### Supported Languages

| Language | Adapter | Notes |
|---|---|---|
| JavaScript/Node | `js-debug-adapter` | Chrome attach supported |
| TypeScript | `js-debug-adapter` | Same adapter as JS |
| PHP | `php-debug-adapter` | Requires Xdebug 3 |
| Python | `debugpy` | `python -m debugpy` |
| Go | `delve` | |
| C/C++ | `codelldb` | |
| Rust | `codelldb` | |

### VS Code launch.json

DAP reads `.vscode/launch.json` automatically. Existing VS Code debug configs work out of the box.

---

## Testing

Run tests without leaving the editor:

```
<leader>tr   — Run test under cursor
<leader>tR   — Run entire test file
<leader>ts   — Toggle test summary sidebar
<leader>to   — View test output
```

Results appear inline as virtual text (✓ pass, ✗ fail).

---

## Plugin Architecture

All plugins are defined in `lua/plugins/` as arrays of lazy.nvim specs.

- `ui.lua` — Visual layer
- `lsp.lua` — Language intelligence
- `utils.lua` — Productivity tools
- `ai.lua` — AI integrations

**Adding a plugin:**

```lua
-- In the appropriate file, add a new entry:
{
  "author/plugin-name",
  event = "BufReadPost",   -- Load trigger
  opts  = { ... },         -- Config options
},
```

**Removing a plugin:**

Delete or comment out its spec block. Run `:Lazy clean` to uninstall.

**Updating plugins:**

```vim
:Lazy update
```

Or press `U` inside the Lazy UI (`<leader>L`).

---

## Performance

| Metric | Target | How |
|---|---|---|
| Startup time | < 80ms | All plugins lazy-loaded |
| First file open | < 200ms | LSP lazy-attaches |
| Memory usage | < 60MB | Disabled unused providers |
| Plugin count | ~60 | Quality over quantity |

**Measure startup time:**

```bash
nvim --startuptime /tmp/nvim-startup.log +q
tail -20 /tmp/nvim-startup.log
```

**Profile at runtime:**

```vim
:Lazy profile
```

---

## Updating

This config is updated regularly. To pull latest changes:

```bash
cd ~/.config/nvim
git pull
```

Then update plugins:

```vim
:Lazy update
```

Update LSP servers:

```vim
:MasonUpdate
```

---

## Troubleshooting

<<<<<<< HEAD
This project is open source under the repository license. See: LICENSE (Apache)
=======
### Plugins not loading

```vim
:Lazy          ← Check status
:Lazy restore  ← Restore from lockfile
:Lazy clean    ← Remove unused
```

### LSP not attaching

```vim
:LspInfo       ← Check active servers for this buffer
:Mason         ← Check server installation status
:checkhealth   ← Run full health check
```

### Treesitter errors

```vim
:TSUpdate      ← Update all parsers
:TSInstall all ← Install missing parsers
```

### Fonts/icons look broken

Install a Nerd Font v3: https://www.nerdfonts.com/font-downloads

Recommended: **JetBrainsMono Nerd Font**, **FiraCode Nerd Font**, or **CascadiaCode NF**

Set it in your terminal emulator, not in Neovim.

### Slow startup

Run the profile check:

```bash
nvim --startuptime /tmp/startup.log +q && tail -30 /tmp/startup.log
```

If a specific plugin is slow, add `lazy = true` with an appropriate trigger.
>>>>>>> 72fcf52 (docs(readme): complete rewrite — full IDE documentation)

---

## Changelog

All changes are documented by commit. This repo follows a daily-update workflow:

```
feat:  New feature or plugin
fix:   Bug fix
perf:  Performance improvement  
refactor: Code reorganization
docs:  README or comment update
chore: Dependency updates (Lazy update, MasonUpdate)
```

---

<div align="center">

Built with ❤️ by Girolamo · Updated daily · PRs welcome

</div>
