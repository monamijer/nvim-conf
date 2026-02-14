return {
  -- =============================================================================
  -- THEME
  -- =============================================================================
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  -- =============================================================================
  -- INDENT GUIDES
  -- =============================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = { filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" } },
    },
  },

  -- =============================================================================
  -- SMOOTH SCROLL
  -- =============================================================================
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scroll_step = 1,
      })
    end,
  },

  -- =============================================================================
  -- DASHBOARD
  -- =============================================================================
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      local dashboard = require("alpha.themes.startify")
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

  -- =============================================================================
  -- FILE EXPLORER (SIDEBAR)
  -- =============================================================================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 35,
          adaptive_size = true,
          side = "left",
          mappings = {
            list = {
              { key = "h", action = "close_node" },
              { key = "l", action = "edit" },
              { key = "H", action = "toggle_hidden" },
            },
          },
        },
        renderer = {
          icons = { show = { git = true, folder = true, file = true, folder_arrow = true } },
        },
        git = { enable = true },
        actions = { open_file = { quit_on_open = false } },
      })
    end,
  },

  -- =============================================================================
  -- STATUSLINE
  -- =============================================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          section_separators = {"", ""},
          component_separators = {"", ""},
          globalstatus = true,
        },
        sections = {
          lualine_a = {"mode"},
          lualine_b = {"branch", "diff", "diagnostics"},
          lualine_c = {"filename"},
          lualine_x = {"encoding", "fileformat", "filetype"},
          lualine_y = {"progress"},
          lualine_z = {"location"},
        },
      })
    end,
  },

  -- =============================================================================
  -- BUFFERLINE
  -- =============================================================================
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "both",
          diagnostics = "nvim_lsp",
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = false,
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          separator_style = "slant",
          offsets = {
            { filetype = "NvimTree", text = "Explorer", highlight = "Directory", text_align = "left" },
          },
        }
      })
    end,
  },

  -- =============================================================================
  -- FLOATING TERMINAL
  -- =============================================================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<leader>t]],
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        direction = "float",
        float_opts = {
          border = "curved",
          winblend = 10,
          highlights = { border = "Normal", background = "Normal" },
        },
        persist_size = true,
      })
    end,
  },

  -- =============================================================================
  -- SCROLLBAR (VISUAL INDICATOR)
  -- =============================================================================
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup({
        show = true,
        handle = { color = "#ff9e64" },
        marks = { Search = { color = "#ff9e64" }, Error = { color = "#ff5370" } },
      })
    end
  },
}
