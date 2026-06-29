-- =============================================================================
--  plugins/utils.lua
--  Productivity, Git, Search, Sessions, Multi-cursor, DAP, Testing
-- =============================================================================

return {

  -- ===========================================================================
  -- TELESCOPE
  -- ===========================================================================
  {
    "nvim-telescope/telescope.nvim",
    tag          = "0.1.8",
    cmd          = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")
      local themes    = require("telescope.themes")

      telescope.setup({
        defaults = {
          prompt_prefix    = "  ",
          selection_caret  = "  ",
          path_display     = { "truncate" },
          sorting_strategy = "ascending",
          layout_config    = {
            horizontal     = { prompt_position = "top", preview_width = 0.55 },
            width          = 0.87,
            height         = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"]  = actions.cycle_history_next,
              ["<C-p>"]  = actions.cycle_history_prev,
              ["<C-j>"]  = actions.move_selection_next,
              ["<C-k>"]  = actions.move_selection_previous,
              ["<C-c>"]  = actions.close,
              ["<CR>"]   = actions.select_default,
              ["<C-x>"]  = actions.select_horizontal,
              ["<C-v>"]  = actions.select_vertical,
              ["<C-t>"]  = actions.select_tab,
              ["<C-u>"]  = actions.preview_scrolling_up,
              ["<C-d>"]  = actions.preview_scrolling_down,
              ["<Tab>"]  = actions.toggle_selection + actions.move_selection_worse,
              ["<C-q>"]  = actions.send_to_qflist + actions.open_qflist,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"]  = actions.select_default,
              ["j"]     = actions.move_selection_next,
              ["k"]     = actions.move_selection_previous,
              ["q"]     = actions.close,
            },
          },
        },
        pickers = {
          find_files = { hidden = true, follow = true },
          live_grep  = { additional_args = { "--hidden", "--glob=!.git" } },
          buffers    = { sort_lastused = true, sort_mru = true },
        },
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
          ["ui-select"] = { themes.get_dropdown({ winblend = 10 }) },
          project = {
            -- FIX: empty base_dirs — add your own paths here once they exist
            -- e.g. "~/projects" after you run: mkdir ~/projects
            base_dirs           = {},
            hidden_files        = true,
            theme               = "dropdown",
            order_by            = "asc",
            sync_with_nvim_tree = true,
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("file_browser")
      telescope.load_extension("project")
    end,
  },

  -- ===========================================================================
  -- GITSIGNS
  -- ===========================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signcolumn              = true,
      current_line_blame      = true,
      current_line_blame_opts = {
        virt_text     = true,
        virt_text_pos = "eol",
        delay         = 400,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",
      preview_config               = { border = "rounded" },
    },
  },

  -- LazyGit
  {
    "kdheepak/lazygit.nvim",
    cmd          = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys         = { { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" } },
  },

  -- ===========================================================================
  -- SESSION MANAGEMENT
  -- ===========================================================================
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts  = {
      dir     = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize" },
    },
    config = function(_, opts)
      local p = require("persistence")
      p.setup(opts)
      vim.api.nvim_create_user_command("SessionSave",    function() p.save() end, {})
      vim.api.nvim_create_user_command("SessionRestore", function() p.load() end, {})
      vim.api.nvim_create_user_command("SessionDelete",  function() p.stop() end, {})
    end,
  },

  -- ===========================================================================
  -- PROJECT DETECTION
  -- ===========================================================================
  {
    "ahmedkhalf/project.nvim",
    lazy   = false,
    config = function()
      require("project_nvim").setup({
        manual_mode       = false,
        detection_methods = { "lsp", "pattern" },
        patterns          = {
          ".git", "_darcs", ".hg", ".bzr", ".svn",
          "Makefile", "package.json", "composer.json",
          "artisan", "cargo.toml", "go.mod", "pyproject.toml",
        },
        silent_chdir      = true,
        scope_chdir       = "global",
        -- FIX: exclude_dirs prevents errors on non-existent paths
        exclude_dirs      = {},
        show_hidden       = false,
      })
    end,
  },

  -- ===========================================================================
  -- MULTI-CURSOR (VS Code Ctrl+D)
  -- ===========================================================================
  {
    "mg979/vim-visual-multi",
    event  = "BufReadPost",
    branch = "master",
    init   = function()
      vim.g.VM_leader                   = "\\"
      vim.g.VM_maps                     = {}
      vim.g.VM_maps["Find Under"]       = "<C-d>"
      vim.g.VM_maps["Find Subword Under"] = "<C-d>"
      vim.g.VM_show_warnings            = 0
    end,
  },

  -- ===========================================================================
  -- SPECTRE — Project-wide find & replace
  -- ===========================================================================
  {
    "nvim-pack/nvim-spectre",
    cmd          = "Spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>fR", function() require("spectre").open() end, desc = "Replace in files" },
    },
    opts = { open_cmd = "noswapfile vnew" },
  },

  -- ===========================================================================
  -- HARPOON 2
  -- ===========================================================================
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():append() end,  desc = "Harpoon: add" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: menu" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
    },
    opts = {},
  },

  -- ===========================================================================
  -- DAP — Debugger
  -- ===========================================================================
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<F5>",       function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
      { "<F10>",      function() require("dap").step_over() end,         desc = "Debug: Step Over" },
      { "<F11>",      function() require("dap").step_into() end,         desc = "Debug: Step Into" },
      { "<F12>",      function() require("dap").step_out() end,          desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Breakpoint" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "Debug: Toggle UI" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Debug: Eval" },
    },
    config = function()
      local dap   = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        icons   = { expanded = "", collapsed = "", current_frame = "" },
        layouts = {
          { elements = {
              { id = "scopes",      size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.25 },
            }, size = 40, position = "left" },
          { elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            }, size = 10, position = "bottom" },
        },
      })

      require("nvim-dap-virtual-text").setup({ enabled = true })

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end
    end,
  },

  -- DAP auto-installer via Mason
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed   = { "js-debug-adapter", "php-debug-adapter", "codelldb" },
      automatic_installation = true,
      handlers           = {},
    },
  },

  -- ===========================================================================
  -- NEOTEST
  -- ===========================================================================
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>tr", function() require("neotest").run.run() end,                   desc = "Test: Run nearest" },
      { "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run file" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,            desc = "Test: Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Output" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({ jestCommand = "npx jest" }),
          require("neotest-python")({ dap = { justMyCode = false } }),
        },
        status = { virtual_text = true },
        icons  = { passed = "✓", failed = "✗", running = "↻", skipped = "○" },
      })
    end,
  },

  -- ===========================================================================
  -- REFACTORING
  -- ===========================================================================
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>re", function() require("refactoring").refactor("Extract Function") end,  mode = "v", desc = "Extract function" },
      { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end,  mode = "v", desc = "Extract variable" },
      { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, mode = { "n", "v" }, desc = "Inline variable" },
    },
    opts = {},
  },

  -- ===========================================================================
  -- FLASH — Jump anywhere with 2 chars
  -- ===========================================================================
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = { modes = { char = { jump_labels = true } } },
    keys  = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,        desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,  desc = "Flash Treesitter" },
    },
  },

  -- ===========================================================================
  -- MINI.BUFREMOVE — safe buffer delete
  -- ===========================================================================
  {
    "echasnovski/mini.bufremove",
    version = false,
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete buffer" },
    },
  },

}
