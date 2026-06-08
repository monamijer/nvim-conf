-- =============================================================================
--  plugins/ui.lua
--  Complete UI layer: theme · dashboard · statusline · bufferline ·
--  explorer · notifications · icons · indent guides · scrollbar · UI polish
-- =============================================================================

return {

  -- ===========================================================================
  -- THEME — Tokyo Night (polished, consistent across all UI components)
  -- ===========================================================================
  {
    "folke/tokyonight.nvim",
    lazy    = false,
    priority = 1000,
    opts = {
      style        = "night",      -- night / storm / moon / day
      transparent  = true,
      terminal_colors = true,
      styles = {
        comments    = { italic = true },
        keywords    = { italic = true },
        functions   = {},
        variables   = {},
        sidebars    = "dark",
        floats      = "dark",
      },
      sidebars     = { "qf", "help", "terminal", "NvimTree", "Trouble" },
      on_highlights = function(hl, c)
        -- Brighter indent scope line
        hl.IblScope = { fg = c.blue }
        -- Subtle CursorLine
        hl.CursorLine = { bg = c.bg_highlight }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight-night")
    end,
  },

  -- ===========================================================================
  -- ICONS — Must load first, everything else depends on it
  -- ===========================================================================
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    priority = 999,
    opts = { default = true },
  },

  -- ===========================================================================
  -- DASHBOARD — Premium welcome screen
  -- ===========================================================================
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha   = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Header art
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "                                                     ",
        "        ⚡  Next-Generation IDE  ·  nvim-conf        ",
        "                                                     ",
      }

      -- Quick-action buttons
      dashboard.section.buttons.val = {
        dashboard.button("n",  "  New file",          "<cmd>ene<cr>"),
        dashboard.button("SPC ff", "  Find file",     "<cmd>Telescope find_files<cr>"),
        dashboard.button("SPC fr", "  Recent files",  "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("SPC fg", "󰍉  Live grep",     "<cmd>Telescope live_grep<cr>"),
        dashboard.button("SPC fp", "  Projects",      "<cmd>Telescope projects<cr>"),
        dashboard.button("SPC Sr", "  Restore session","<cmd>SessionRestore<cr>"),
        dashboard.button("L",  "󰒲  Plugin manager",   "<cmd>Lazy<cr>"),
        dashboard.button("M",  "  Mason (LSPs)",      "<cmd>Mason<cr>"),
        dashboard.button("q",  "  Quit",              "<cmd>qa<cr>"),
      }

      -- Footer: version + stats
      local function footer()
        local version  = vim.version()
        local plugins  = require("lazy").stats().count
        local loaded   = require("lazy").stats().loaded
        return string.format(
          "  Neovim v%d.%d.%d   ·  %d/%d plugins loaded",
          version.major, version.minor, version.patch, loaded, plugins
        )
      end

      dashboard.section.footer.val  = footer()
      dashboard.section.footer.opts = { hl = "Type", position = "center" }
      dashboard.section.header.opts = { hl = "Include", position = "center" }

      alpha.setup(dashboard.config)

      -- Re-render footer after Lazy finishes
      vim.api.nvim_create_autocmd("User", {
        pattern  = "LazyVimStarted",
        callback = function()
          dashboard.section.footer.val = footer()
          pcall(vim.cmd, "AlphaRedraw")
        end,
      })
    end,
  },

  -- ===========================================================================
  -- STATUSLINE — Lualine (rich, informative, fast)
  -- ===========================================================================
  {
    "nvim-lualine/lualine.nvim",
    event        = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                  = "tokyonight",
        globalstatus           = true,
        section_separators     = { left = "", right = "" },
        component_separators   = { left = "", right = "" },
        disabled_filetypes     = { statusline = { "alpha", "dashboard" } },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = {
          { "branch", icon = "" },
          { "diff",   symbols = { added = " ", modified = " ", removed = " " } },
        },
        lualine_c = {
          { "filename",
            path    = 1,   -- Relative path
            symbols = { modified = "  ", readonly = "  ", unnamed = "  " },
          },
        },
        lualine_x = {
          -- Copilot status
          {
            function()
              local ok, copilot = pcall(require, "copilot.api")
              if not ok then return "" end
              local status = copilot.status.data.status
              local icons = { Normal = " ", InProgress = " ", Warning = " " }
              return (icons[status] or " ") .. "Copilot"
            end,
            color = { fg = "#6272a4" },
          },
          { "diagnostics",
            sources  = { "nvim_diagnostic" },
            symbols  = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },

  -- ===========================================================================
  -- BUFFERLINE — VS Code-style tab bar
  -- ===========================================================================
  {
    "akinsho/bufferline.nvim",
    version      = "*",
    event        = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode            = "buffers",
        numbers         = "none",
        diagnostics     = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warning = " " }
          local ret   = (diag.error and icons.error .. diag.error .. " " or "")
                      .. (diag.warning and icons.warning .. diag.warning or "")
          return vim.trim(ret)
        end,
        show_buffer_icons      = true,
        show_buffer_close_icons= true,
        show_close_icon        = false,
        separator_style        = "slant",
        enforce_regular_tabs   = false,
        always_show_bufferline = true,
        hover = { enabled = true, delay = 200, reveal = { "close" } },
        offsets = {
          { filetype = "NvimTree", text = " Explorer",
            highlight = "Directory", text_align = "left", separator = true },
        },
      },
    },
  },

  -- ===========================================================================
  -- FILE EXPLORER — nvim-tree (VS Code-like sidebar)
  -- ===========================================================================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd  = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    opts = {
      auto_reload_on_write = true,
      hijack_cursor        = true,
      sort = { sorter = "case_sensitive" },
      view = {
        width          = 35,
        side           = "left",
        adaptive_size  = false,
        preserve_window_proportions = true,
      },
      renderer = {
        group_empty   = true,
        highlight_git = true,
        icons = {
          show = { git = true, folder = true, file = true, folder_arrow = true },
          glyphs = {
            default   = "",
            symlink   = "",
            git = {
              unstaged  = "✗",
              staged    = "✓",
              unmerged  = "",
              renamed   = "➜",
              untracked = "★",
              deleted   = "",
              ignored   = "◌",
            },
          },
        },
      },
      git = { enable = true, ignore = false },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = { error = " ", warning = " ", hint = " ", info = " " },
      },
      actions = {
        open_file = {
          quit_on_open     = false,
          resize_window    = false,
          window_picker    = { enable = true },
        },
      },
      filters = {
        dotfiles = false,
        custom   = { "^.git$", "node_modules", ".cache" },
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local opt = { buffer = bufnr, noremap = true, silent = true, nowait = true }
        -- Default bindings
        api.config.mappings.default_on_attach(bufnr)
        -- Additional bindings
        vim.keymap.set("n", "l", api.node.open.edit,             opt)
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opt)
        vim.keymap.set("n", "H", api.tree.toggle_hidden_filter,  opt)
        vim.keymap.set("n", "?", api.tree.toggle_help,           opt)
      end,
    },
  },

  -- ===========================================================================
  -- FLOATING TERMINAL — toggleterm
  -- ===========================================================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd     = "ToggleTerm",
    keys    = { "<C-`>", "<leader>tt", "<leader>th", "<leader>tv" },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then return 18
        elseif term.direction == "vertical" then return math.floor(vim.o.columns * 0.35)
        end
      end,
      shade_terminals  = true,
      shading_factor   = 2,
      persist_size     = true,
      persist_mode     = true,
      direction        = "float",
      close_on_exit    = true,
      shell            = vim.o.shell,
      auto_scroll      = true,
      float_opts = {
        border   = "curved",
        winblend = 8,
        width    = math.floor(vim.o.columns * 0.85),
        height   = math.floor(vim.o.lines   * 0.80),
      },
    },
  },

  -- ===========================================================================
  -- NOTIFICATIONS — noice (beautiful command-line & notifications)
  -- ===========================================================================
  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },
        signature = { enabled = false }, -- Handled by lsp_signature
      },
      presets = {
        bottom_search         = true,   -- Search at bottom
        command_palette       = true,   -- Command palette style
        long_message_to_split = true,   -- Long messages → split
        inc_rename            = true,   -- Inline rename UI
      },
    },
  },

  -- Notification backend
  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = {
      timeout    = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width  = function() return math.floor(vim.o.columns * 0.75) end,
      on_open    = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
      render   = "default",
      stages   = "fade_in_slide_out",
      icons    = { DEBUG = "", ERROR = "", INFO = "", TRACE = "✎", WARN = "" },
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- ===========================================================================
  -- WHICH-KEY — Shortcut discovery (VS Code Ctrl+Shift+P equivalent hint layer)
  -- ===========================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks     = true,
        registers = true,
        spelling  = { enabled = true, suggestions = 20 },
      },
      window = {
        border   = "rounded",
        position = "bottom",
        margin   = { 1, 0, 1, 0 },
        padding  = { 1, 2, 1, 2 },
        winblend = 0,
      },
      layout = {
        height  = { min = 4, max = 25 },
        width   = { min = 20, max = 50 },
        spacing = 3,
        align   = "left",
      },
      ignore_missing = false,
      show_help      = true,
      show_keys      = true,
    },
  },

  -- ===========================================================================
  -- INDENT GUIDES — Visual indentation lines (VS Code equivalent)
  -- ===========================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = "BufReadPost",
    opts = {
      indent = {
        char     = "│",
        tab_char = "│",
      },
      scope = {
        enabled    = true,
        show_start = false,
        show_end   = false,
        highlight  = { "Function", "Label" },
      },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "NvimTree",
          "Trouble", "lazy", "mason", "notify",
          "toggleterm", "lazyterm",
        },
      },
    },
  },

  -- ===========================================================================
  -- SMOOTH SCROLLING
  -- ===========================================================================
  {
    "karb94/neoscroll.nvim",
    event = "BufReadPost",
    opts = {
      mappings             = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor          = true,
      stop_eof             = true,
      respect_scrolloff    = false,
      cursor_scrolls_alone = true,
      easing               = "quadratic",
    },
  },

  -- ===========================================================================
  -- SCROLLBAR — Diagnostic + search indicator in gutter
  -- ===========================================================================
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    opts = {
      show          = true,
      show_in_active_only = false,
      set_highlights = true,
      throttle_ms   = 100,
      handle = { color = "#4a5374" },
      marks = {
        Search      = { color = "#ff9e64" },
        Error       = { color = "#f7768e" },
        Warn        = { color = "#e0af68" },
        Info        = { color = "#0db9d7" },
        Hint        = { color = "#1abc9c" },
        Misc        = { color = "#9d7cd8" },
        GitAdd      = { color = "#9ece6a" },
        GitChange   = { color = "#7aa2f7" },
        GitDelete   = { color = "#f7768e" },
      },
      handlers = {
        cursor         = true,
        diagnostic     = true,
        gitsigns       = true,
        handle         = true,
        search         = false,
      },
    },
  },

  -- ===========================================================================
  -- COLOR HIGHLIGHTING — Show CSS/Tailwind colors inline
  -- ===========================================================================
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB      = true,
        RRGGBB   = true,
        names    = true,
        css      = true,
        tailwind = "both",
        mode     = "background",
      },
    },
  },

  -- ===========================================================================
  -- TODO COMMENTS — Highlight and search TODO/FIXME/HACK etc.
  -- ===========================================================================
  {
    "folke/todo-comments.nvim",
    event        = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs     = true,
      keywords  = {
        FIX  = { icon = " ", color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󰥔 ", alt  = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰎚 ", color = "hint",   alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test",   alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },

  -- ===========================================================================
  -- DRESSING — Beautiful input / select UI (replaces ugly vim.input)
  -- ===========================================================================
  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {
      input = {
        default_prompt = "➤ ",
        win_options    = { winblend = 10 },
      },
      select = {
        backend  = { "telescope", "fzf", "builtin" },
        builtin  = { border = "rounded" },
        telescope = require("telescope.themes").get_dropdown,
      },
    },
  },

  -- ===========================================================================
  -- TROUBLE — Diagnostics / references panel
  -- ===========================================================================
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd  = { "TroubleToggle", "Trouble" },
    opts = {
      position          = "bottom",
      height            = 12,
      icons             = true,
      mode              = "workspace_diagnostics",
      fold_open         = "",
      fold_closed       = "",
      use_diagnostic_signs = true,
      signs = {
        error   = " ",
        warning = " ",
        hint    = " ",
        information = " ",
        other   = "﫠",
      },
    },
  },

  -- ===========================================================================
  -- WINBAR — Breadcrumb navigation bar at top of buffer
  -- ===========================================================================
  {
    "utilyre/barbecue.nvim",
    event        = "VeryLazy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_navic = true,
      show_dirname = false,
      show_basename = true,
      show_modified = false,
      theme = "tokyonight",
      symbols = {
        separator = " ",
      },
    },
  },

}
