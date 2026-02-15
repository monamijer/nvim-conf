# 🚀 Modern Neovim IDE Config (Arch Linux Based)

A modular, fast, and aesthetics-focused Neovim configuration built with **Neovim** and **Lazy.nvim**.

This setup aims to feel like a **next-generation IDE** — smooth, dynamic, visually rich — while staying lightweight and hackable.

It now includes:

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

* **Plugin Manager**: Lazy.nvim — ultra fast startup & lazy loading
* **LSP Integration** — IDE-style diagnostics, navigation & refactoring
* **Python Support** via Pyright (type checking + completion)

---

### 🔍 Advanced Navigation

* **Telescope.nvim**

  * fuzzy file search
  * live grep
  * buffer navigation
  * recent files

---

### 🧠 AI Coding Assistant

* **GitHub Copilot**

  * inline suggestions
  * smart acceptance keymaps
  * safe loading

---

### 🎨 Modern UI System

* **TokyoNight theme**
* Dashboard welcome screen
* Dynamic statusline
* Buffer tabs
* Scroll animations
* Visual git indicators
* Treesitter highlighting & smart indentation
* Autopairs
* Keymap helper popups

---

### 📁 Sidebar & Terminal (IDE-style)

* **nvim-tree.lua**

  * adaptive width
  * icons + git status
  * collapsible navigation

* **toggleterm.nvim**

  * floating or bottom terminal
  * resizable
  * persistent sessions

---

![python overview](./screenshots/nvim-py.png)

---

### 🧬 Syntax Intelligence

* **nvim-treesitter**

  * modern highlighting
  * incremental selection
  * indentation awareness

---

![neovim config overview](./screenshots/nvim1.png)

![config overview](./screenshots/nvim2.png)

![config overview](./screenshots/nvim4.png)

![config overview](./screenshots/nvimbar-x.png)

---

## 📦 Prerequisites

Install dependencies on Arch Linux:

```bash
# Core tools
sudo pacman -S neovim ripgrep fd git

# Python LSP server
npm install -g pyright
```

---

## 🚀 Installation

Clone into your Neovim config directory:

```bash
git clone https://github.com/monamijer/nvim-conf.git ~/.config/nvim

# or SSH
git clone git@github.com:monamijer/nvim-cong.git ~/.config/nvim
```

Launch Neovim:

```bash
nvim
```

Plugins install automatically on first run.

---

## ⌨️ Keybindings

Leader key = **Space**

### Navigation & Search

| Key          | Action         |
| ------------ | -------------- |
| `<leader>ff` | Find files     |
| `<leader>fg` | Live grep      |
| `<leader>fw` | Search word    |
| `<leader>fb` | Buffers        |
| `<C-b>`      | Toggle sidebar |

---

### LSP IDE Controls

| Key          | Action           |
| ------------ | ---------------- |
| `gd`         | Go to definition |
| `K`          | Hover docs       |
| `<leader>rn` | Rename symbol    |
| `<leader>ca` | Code actions     |

---

### Terminal

| Key                    | Action          |
| ---------------------- | --------------- |
| `<C-\>` or `<leader>t` | Toggle terminal |

---

### Editing Enhancements

| Key               | Action                    |
| ----------------- | ------------------------- |
| `<C-s>`           | Save                      |
| `<C-z>` / `<C-y>` | Undo / redo               |
| `<M-l>`           | Accept Copilot suggestion |

---

## 📂 Project Structure

```
~/.config/nvim/
├── init.lua
└── lua/
    ├── keymaps.lua
    ├── utils.lua
    └── plugin/
        ├── lsp.lua
        └── ui.lua
```

---

## 🤝 Contributing

Contributions welcome!

1. Fork the repo
2. Create branch
3. Commit changes
4. Push
5. Open PR

---

## ✨ Philosophy

This config aims to blend:

⚡ Neovim speed
🎨 modern UI polish
🧠 IDE intelligence
🚀 developer ergonomics

All without sacrificing modularity or performance.

---

Enjoy hacking your editor.
Make it yours. 🚀
