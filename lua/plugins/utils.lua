return {
  -- Nvim-Tree (File Explorer)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30, side = "left" },
      })
      vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle Explorer" })
    end,
  },

  -- Telescope (Fuzzy Finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Search text" })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "List buffers" })
    end,
  },

  -- Treesitter (Syntax Highlighting)
  --
  -- {
 -- "nvim-treesitter/nvim-treesitter",
 -- build = ":TSUpdate",
 -- config = function()
 --   local configs = require("nvim-treesitter.configs")
 --  configs.setup({
 --    ensure_installed = { "lua", "javascript", "html", "css", "json", "typescript" },
 --    highlight = { enable = true },
 --  })
 -- end,
 --},
 
 {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    
    local ts = require("nvim-treesitter")
    ts.setup({
      ensure_installed = { "lua", "javascript", "html", "css" },
      highlight = { enable = true },

      indent = { enable = true },
    })
  end,
},

  -- ToggleTerm (The VS Code-like Terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]], -- Shortcut to toggle (Ctrl + Backslash)
        hide_numbers = true,
        shade_terminals = true,
        direction = 'horizontal', -- Opens at the bottom like VS Code
        close_on_exit = true,
        shell = vim.o.shell,
      })
    end,
  },

  -- GitHub Copilot (Native Lua version)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-l>", -- Alt + L to accept suggestion
          },
        },
      })
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require("nvim-autopairs").setup({}) end,
  }
}
