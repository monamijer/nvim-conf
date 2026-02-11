return {
  -- TokyoNight Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  -- 1. Indent guides (VS Code like lines)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│", -- The vertical line character
        tab_char = "│",
      },
      scope = {
        enabled = true, -- Highlights the current code block line
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason",
        },
      },
    },
  },
  -- 2. Neoscroll (Fluid, smooth scrolling)
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup({
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,          -- Hide cursor while scrolling
        stop_eof = true,             -- Stop at end of file
        respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin
        cursor_scroll_step = 1,      -- Step size when scrolling with cursor
      })
    end,
  },

  -- Dashboard (Greeting Screen)
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
       local dashboard = require("alpha.themes.startify")
       -- Set header (You can put any text here)
       dashboard.section.header.val = {
           [[                               __                ]],
           [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
           [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
           [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
           [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
           [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
       }
       require("alpha").setup(dashboard.config)
    end
  },

  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "tokyonight" } })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({})
    end,
  },
}
