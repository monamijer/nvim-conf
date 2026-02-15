# 🚀 Modern Neovim IDE Config

A modular, fast, and aesthetics-focused configuration built on Neovim with Lazy.nvim.

This project transforms Neovim into a **modern, dynamic IDE** — inspired by VS Code ergonomics — while preserving Neovim’s speed, hackability, and philosophy.

Designed for developers who want:

✅ IDE-like navigation & workflow
✅ smooth UI and animations
✅ AI assistance
✅ modern developer ergonomics
✅ cross-platform usability

---

![nvim bar overview](./screenshots/nvimbar-y.png)

---

# 🔗 Source Code

👉 **Project Repository**
https://github.com/monamijer/nvim-conf

Browse the full configuration, commit history, and modules — everything is readable, hackable, and designed to teach.

---

## ✨ Features Overview

### ⚡ Core IDE Experience

* Fast plugin management via Lazy.nvim
* Built-in LSP workflow
* Python development via Pyright
* ergonomic keybindings

---

### 🔍 Advanced Navigation

Powered by Telescope.nvim

* fuzzy search
* live grep
* buffer navigation
* recent files

---

### 🧠 AI Assistance

Integrated GitHub Copilot

* inline suggestions
* smart acceptance keys
* safe lazy loading

---

### 🎨 Modern UI

* TokyoNight theme
* dashboard startup screen
* statusline & buffer tabs
* smooth scrolling
* git indicators
* autopairs
* keymap hints

---

### 📁 Sidebar & Terminal

* nvim-tree.lua → adaptive sidebar with icons & git info
* toggleterm.nvim → floating or bottom terminal sessions

---

### 🧬 Syntax Intelligence

Powered by nvim-treesitter

* modern highlighting
* smart indentation
* structural awareness

---

![python overview](./screenshots/nvim-py.png)

![neovim config overview](./screenshots/nvim1.png)

![config overview](./screenshots/nvim2.png)

![config overview](./screenshots/nvim4.png)

![config overview](./screenshots/nvimbar-x.png)

---

# 📚 Documentation & Learning

This configuration is meant to be **learnable and hackable**.

Core editor documentation
→ https://neovim.io/doc/

Plugin manager guide
→ https://github.com/folke/lazy.nvim

Search & navigation
→ https://github.com/nvim-telescope/telescope.nvim

Syntax engine
→ https://github.com/nvim-treesitter/nvim-treesitter

File explorer
→ https://github.com/nvim-tree/nvim-tree.lua

Terminal manager
→ https://github.com/akinsho/toggleterm.nvim

AI assistant
→ https://docs.github.com/copilot

---

# 📦 Prerequisites (Cross-Platform)

Install core tools:

### Arch Linux

```
sudo pacman -S neovim ripgrep fd git
```

### Fedora

```
sudo dnf install neovim ripgrep fd-find git
```

### Debian / Ubuntu

```
sudo apt install neovim ripgrep fd-find git
```

### Windows (PowerShell)

```
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep sharkdp.fd
```

Python LSP:

```
npm install -g pyright
```

---

# 🚀 Installation

👉 Click to clone the repository:
https://github.com/monamijer/nvim-conf

### Linux / macOS

```
git clone https://github.com/monamijer/nvim-conf.git ~/.config/nvim
```

### Windows

```
git clone https://github.com/monamijer/nvim-conf.git %LOCALAPPDATA%\nvim
```

Launch Neovim:

```
nvim
```

Plugins install automatically on first run.

---

# ⌨ Keybindings Overview

Leader key → **Space**

### Navigation

| Key          | Action         |
| ------------ | -------------- |
| `<leader>ff` | Find files     |
| `<leader>fg` | Live grep      |
| `<leader>fw` | Search word    |
| `<leader>fb` | Buffers        |
| `<C-b>`      | Sidebar toggle |

### LSP

| Key          | Action      |
| ------------ | ----------- |
| `gd`         | Definition  |
| `K`          | Hover docs  |
| `<leader>rn` | Rename      |
| `<leader>ca` | Code action |

### Terminal

| Key                   | Action          |
| --------------------- | --------------- |
| `<C-\>` / `<leader>t` | Toggle terminal |

### Editing

| Key               | Action      |
| ----------------- | ----------- |
| `<C-s>`           | Save        |
| `<C-z>` / `<C-y>` | Undo / redo |

---

# 📂 Project Structure

```
~/.config/nvim/
├── init.lua
├── lazy-lock.json
├── coc-settings.json
├── README.md
├── LICENSE
├── screenshots/
└── lua/
      ├── core/
      │   ├── keymaps.lua
      │   ├── options.lua
      └── plugins/
          ├── ui.lua
          ├── lsp.lua
          └── utils.lua
```

---

# 🐛 Support & Troubleshooting

Inside Neovim run:

```
:Lazy sync
:checkhealth
```

If issues persist:

* update Neovim
* reinstall dependencies
* clear plugin cache

👉 **Report bugs / request help:**
https://github.com/monamijer/nvim-conf/issues

Please include:

* OS
* Neovim version
* error messages

---

# 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push
5. Open a pull request

Bug fixes, documentation improvements, and ideas are appreciated.

---

# 📜 License & Copyright

This project is open source under the repository license.

See:

LICENSE → included in this repository

---

# ✨ Philosophy

This configuration merges:

⚡ Neovim performance
🎨 modern IDE aesthetics
🧠 developer intelligence
🚀 ergonomic workflow

while staying:

✔ modular
✔ hackable
✔ beginner-friendly
✔ cross-platform

Make it yours. Learn from it. Extend it.

---

Enjoy hacking your editor 🚀
