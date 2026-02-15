# 🚀 Modern Neovim IDE Config

A modular, fast, and aesthetics-focused Neovim configuration built with **Neovim** and **Lazy.nvim**.

This setup aims to feel like a **next-generation IDE** — smooth, dynamic, visually rich — while staying lightweight, hackable, and cross-platform.

It is designed for developers who want:

✅ VS Code-like sidebar & terminal behavior
✅ Smooth animations
✅ AI assistance
✅ Modern UI components
✅ Advanced navigation & search
✅ Python-ready IDE workflow

---

![nvim bar overview](./screenshots/nvimbar-y.png)

---

## 🛠️ Features

### ⚡ Core IDE Experience

* Ultra-fast plugin management via Lazy.nvim
* LSP integration for diagnostics & refactoring
* Python development via Pyright
* Smart editing workflow

---

### 🔍 Advanced Navigation

Powered by **Telescope.nvim**

* fuzzy file search
* live grep
* buffer navigation
* recent files

---

### 🧠 AI Coding Assistant

Integrated **GitHub Copilot**

* inline suggestions
* ergonomic acceptance keymaps
* safe loading

---

### 🎨 Modern UI System

* TokyoNight theme
* dashboard startup screen
* dynamic statusline
* buffer tabs
* smooth scrolling
* git indicators
* autopairs
* keymap helper popups

---

### 📁 Sidebar & Terminal (IDE-style)

* **nvim-tree.lua**

  * adaptive sidebar
  * git icons
  * collapsible navigation

* **toggleterm.nvim**

  * floating or bottom terminal
  * resizable sessions
  * persistent workflow

---

![python overview](./screenshots/nvim-py.png)

---

### 🧬 Syntax Intelligence

Powered by **nvim-treesitter**

* modern highlighting
* incremental selection
* indentation awareness

---

![neovim config overview](./screenshots/nvim1.png)

![config overview](./screenshots/nvim2.png)

![config overview](./screenshots/nvim4.png)

![config overview](./screenshots/nvimbar-x.png)

---

## 📦 Prerequisites (Cross-Platform)

Install core dependencies:

### 🐧 Arch Linux

```bash
sudo pacman -S neovim ripgrep fd git
```

### 🐧 Fedora

```bash
sudo dnf install neovim ripgrep fd-find git
```

### 🐧 Debian / Ubuntu

```bash
sudo apt install neovim ripgrep fd-find git
```

### 🪟 Windows

Install:

* Neovim (official installer or winget)
* Git
* ripgrep
* fd

Example (PowerShell):

```powershell
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep sharkdp.fd
```

Python LSP:

```bash
npm install -g pyright
```

---

## 🚀 Installation

Clone into your Neovim config directory:

### Linux / macOS

```bash
git clone https://github.com/monamijer/nvim-conf.git ~/.config/nvim
```

### Windows

```powershell
git clone https://github.com/monamijer/nvim-conf.git $env:LOCALAPPDATA\nvim
```

Launch Neovim:

```bash
nvim
```

Plugins install automatically on first run.

---

## ⌨️ Keybindings Overview

Leader key → **Space**

### Navigation

| Key          | Action         |
| ------------ | -------------- |
| `<leader>ff` | Find files     |
| `<leader>fg` | Live grep      |
| `<leader>fw` | Search word    |
| `<leader>fb` | Buffers        |
| `<C-b>`      | Toggle sidebar |

### LSP

| Key          | Action           |
| ------------ | ---------------- |
| `gd`         | Go to definition |
| `K`          | Hover docs       |
| `<leader>rn` | Rename           |
| `<leader>ca` | Code actions     |

### Terminal

| Key                   | Action          |
| --------------------- | --------------- |
| `<C-\>` / `<leader>t` | Toggle terminal |

### Editing

| Key               | Action            |
| ----------------- | ----------------- |
| `<C-s>`           | Save              |
| `<C-z>` / `<C-y>` | Undo / redo       |
| Copilot key       | Accept suggestion |

---

## 📂 Project Structure

```
~/.config/nvim/
├── init.lua                      # Main entry point loaded by Neovim
├── lazy-lock.json                # Lazy.nvim lockfile
├── coc-settings.json             # Copilot / CoC settings
├── README.md                     # Project documentation
├── LICENSE                       # License file
├── screenshots/                  # UI and showcase screenshots
└── lua/                          # Lua configuration modules
      ├── core/
      │   ├── keymaps.lua
      │   ├── options.lua
      └── plugins/
          ├── ui.lua
          ├── lsp.lua
          └── utils.lua
```

---

## 🐛 Troubleshooting

If something breaks:

```
:Lazy sync
:checkhealth
```

Common fixes:

* update Neovim
* reinstall dependencies
* clear plugin cache

Report issues on GitHub with:

* OS version
* Neovim version
* error message

---

## 🤝 Contributing

All contributions are welcome:

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push
5. Open pull request

Bug reports and improvements are encouraged.

---

## ✨ Philosophy

This configuration exists to blend:

⚡ Neovim speed
🎨 modern UI polish
🧠 IDE intelligence
🚀 developer ergonomics

while remaining:

✔ modular
✔ hackable
✔ cross-platform
✔ lightweight

Make it yours. Build on it. Experiment.

---

Enjoy hacking your editor 🚀
