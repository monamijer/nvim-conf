Markdown

# 🚀 Modern Neovim Config (Arch Linux Based)

A modular, fast, and aesthetics-focused Neovim configuration built with **Lazy.nvim**. This setup is optimized for Python development and lightning-fast project navigation.

## 🛠️ Features

- **Package Manager**: [Lazy.nvim](https://github.com/folke/lazy.nvim) for blazing fast startup.
- **LSP Support**: Full IDE-like features via `nvim-lspconfig`.
- **Python Integration**: Specialized setup for `Pyright` (autocompletion, type checking).
- **Advanced Search**: [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for fuzzy finding and live grep.
- **UI Enhancements**: Rounded borders, diagnostic icons, and Nerd Font support.

## 📦 Prerequisites

Ensure the following are installed on your Arch Linux system:

```bash
# Core tools
sudo pacman -S neovim ripgrep fd git

# Python LSP server
npm install -g pyright

# Recommended: A Nerd Font for icons (e.g., JetBrainsMono Nerd Font)
# pacman -S ttf-jetbrains-mono-nerd

🚀 Installation

    Clone this repository into your Neovim configuration directory:

Bash

git clone https://github.com/monamijer/nvim-conf.git) ~/.config/nvim

    Launch Neovim:

Bash

nvim

Plugins will be automatically installed on the first launch.
⌨️ Keybindings

The Leader key is set to Space.
Key	Action	Plugin
<Leader>ff	Find Files by name	Telescope
<Leader>fg	Live Grep (search text in files)	Telescope
<Leader>fw	Search word under cursor	Telescope
gd	Go to Definition	LSP
K	Hover Documentation	LSP
<Leader>rn	Smart Rename	LSP
<Leader>ca	Code Actions	LSP
📂 Project Structure
Plaintext

~/.config/nvim/
├── init.lua          # Main entry point & Bootstrap
└── lua/
    └── plugin/       # Modular plugin configurations
        ├── lsp.lua   # Language Server settings
        └── search.lua # Navigation & Fuzzy finder

🤝 Contributing

Contributions are welcome! To contribute:

    Fork the project.

    Create a Feature Branch (git checkout -b feature/AmazingFeature).

    Commit your changes (git commit -m 'Add some AmazingFeature').

    Push to the branch (git push origin feature/AmazingFeature).

    Open a Pull Request.

Built with ❤️ for the Arch Linux community.
