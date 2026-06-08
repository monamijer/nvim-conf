-- =============================================================================
--  plugins/utils.lua
--  Productivity, Git, Search, Sessions, Multi-cursor, Snippets, DAP
-- =============================================================================

return {

  -- ===========================================================================
  -- TELESCOPE — Fuzzy finder (the command center)
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
          prompt_prefix  = "  ",
          selection_caret = "  ",
          path_display   = { "truncate" },
          sorting_strategy = "ascending",
          layout_config  = {
            horizontal = { prompt_position = "top", preview_width = 0.55, results_width = 0.8 },
            vertical   = { mirror = false },
            width      = 0.87,
            height     = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"]    = actions.cycle_history_next,
              ["<C-p>"]    = actions.cycle_history_prev,
              ["<C-j>"]    = actions.move_selection_next,
              ["<C-k>"]    = actions.move_selection_previous,
              ["<C-c>"]    = actions.close,
              ["<Down>"]   = actions.move_selection_next,
              ["<Up>"]     = actions.move_selection_previous,
              ["<CR>"]     = actions.select_default,
              ["<C-x>"]    = actions.select_horizontal,
              ["<C-v>"]    = actions.select_vertical,
              ["<C-t>"]    = actions.select_tab,
              ["<C-u>"]    = actions.preview_scrolling_up,
              ["<C-d>"]    = actions.preview_scrolling_down,
              ["<Tab>"]    = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"]  = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"]    = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"]    = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"]    = actions.complete_tag,
              ["<C-_>"]    = actions.which_key,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"]  = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["j"]     = actions.move_selection_next,
              ["k"]     = actions.move_selection_previous,
              ["H"]     = actions.move_to_top,
              ["M"]     = actions.move_to_middle,
              ["L"]     = actions.move_to_bottom,
              ["?"]     = actions.which_key,
            },
          },
        },
        pickers = {
          find_files       = { hidden = true, follow = true },
          live_grep        = { additional_args = { "--hidden", "--glob=!.git" } },
          buffers          = { sort_lastused = true, sort_mru = true },
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
            base_dirs = {
              "~/projects",
              "~/work",
              "~/code",
            },
            hidden_files    = true,
            theme           = "dropdown",
            order_by        = "asc",
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
  -- GIT — Gitsigns (inline git blame, diff, hunk navigation)
  -- ===========================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signcolumn              = true,
      numhl                   = false,
      linehl                  = false,
      word_diff               = false,
      watch_gitdir            = { follow_files = true },
      attach_to_untracked     = true,
      current_line_blame      = true,
      current_line_blame_opts = {
        virt_text         = true,
        virt_text_pos     = "eol",
        delay             = 400,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",
      preview_config = { border = "rounded" },
    },
  },

  -- Lazygit integration
  {
    "kdheepak/lazygit.nvim",
    cmd          = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -- ===========================================================================
  -- SESSION MANAGEMENT — auto-save/restore per directory
  -- ===========================================================================
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir     = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = function() vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" }) end,
    },
    config = function(_, opts)
      local p = require("persistence")
      p.setup(opts)
      -- Expose simple commands used by keymaps
      vim.api.nvim_create_user_command("SessionSave",    function() p.save() end,    {})
      vim.api.nvim_create_user_command("SessionRestore", function() p.load() end,    {})
      vim.api.nvim_create_user_command("SessionDelete",  function() p.stop() end,    {})
    end,
  },

  -- ===========================================================================
  -- PROJECT DETECTION — auto-set cwd on open
  -- ===========================================================================
  {
    "ahmedkhalf/project.nvim",
    lazy   = false,
    config = function()
      require("project_nvim").setup({
        manual_mode     = false,
        detection_methods = { "lsp", "pattern" },
        patterns        = {
          ".git", "_darcs", ".hg", ".bzr", ".svn",
          "Makefile", "package.json", "composer.json",
          "artisan",              -- Laravel
          "cargo.toml",           -- Rust
          "go.mod",               -- Go
          "pyproject.toml",       -- Python
        },
        ignore_lsp      = {},
        exclude_dirs    = { "~/.cargo/*" },
        show_hidden     = false,
        silent_chdir    = true,
        scope_chdir     = "global",
      })
    end,
  },

  -- ===========================================================================
  -- MULTI-CURSOR — vim-visual-multi (VS Code Ctrl+D equivalent)
  -- ===========================================================================
  {
    "mg979/vim-visual-multi",
    event  = "BufReadPost",
    branch = "master",
    init = function()
      vim.g.VM_leader              = "\\"
      vim.g.VM_maps                = {}
      vim.g.VM_maps["Find Under"]  = "<C-d>"   -- VS Code Ctrl+D
      vim.g.VM_maps["Find Subword Under"] = "<C-d>"
      vim.g.VM_highlight_matches   = "underline"
      vim.g.VM_theme               = "iceblue"
      vim.g.VM_show_warnings       = 0
    end,
  },

  -- ===========================================================================
  -- SPECTRE — Project-wide find & replace (with regex)
  -- ===========================================================================
  {
    "nvim-pack/nvim-spectre",
    build        = false,
    cmd          = "Spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>fR", function() require("spectre").open() end,               desc = "Replace in files (Spectre)" },
      { "<leader>fw", function() require("spectre").open_visual({ select_word = true }) end, mode = "n", desc = "Search current word" },
      { "<leader>fw", function() require("spectre").open_visual() end,        mode = "v", desc = "Search selection" },
    },
    opts = { open_cmd = "noswapfile vnew" },
  },

  -- ===========================================================================
  -- HARPOON 2 — Bookmark files for rapid navigation
  -- ===========================================================================
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():append() end,        desc = "Harpoon: add" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: menu" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end,       desc = "Harpoon 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end,       desc = "Harpoon 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end,       desc = "Harpoon 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end,       desc = "Harpoon 4" },
    },
    opts = {},
  },

  -- ===========================================================================
  -- DAP — Debugger (VS Code launch.json compatible)
  -- ===========================================================================
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mxsdev/nvim-dap-vscode-js",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<F5>",       function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
      { "<F10>",      function() require("dap").step_over() end,         desc = "Debug: Step Over" },
      { "<F11>",      function() require("dap").step_into() end,         desc = "Debug: Step Into" },
      { "<F12>",      function() require("dap").step_out() end,          desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Debug: Conditional breakpoint" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "Debug: Toggle UI" },
      { "<leader>de", function() require("dapui").eval() end,            mode = { "n", "v" }, desc = "Debug: Eval" },
    },
    config = function()
      local dap    = require("dap")
      local dapui  = require("dapui")

      -- DAP UI
      dapui.setup({
        icons    = { expanded = "", collapsed = "", current_frame = "" },
        layouts  = {
          { elements = {
              { id = "scopes",      size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.25 },
            },
            size     = 40,
            position = "left",
          },
          { elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size     = 10,
            position = "bottom",
          },
        },
      })

      -- Virtual text
      require("nvim-dap-virtual-text").setup({
        enabled                 = true,
        commented               = false,
        virt_text_pos           = "eol",
        all_frames              = false,
        highlight_new_as_changed = false,
      })

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

      -- Python
      local ok_py = pcall(require, "dap-python")
      if ok_py then
        require("dap-python").setup("python")
      end

      -- Go
      local ok_go = pcall(require, "dap-go")
      if ok_go then require("dap-go").setup() end

      -- JS / TS (vscode-js-debug)
      local ok_js = pcall(require, "dap-vscode-js")
      if ok_js then
        require("dap-vscode-js").setup({
          debugger_cmd = { "js-debug-adapter" },
          adapters     = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        })
        for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
          dap.configurations[lang] = {
            { type = "pwa-node",  request = "launch", name = "Launch Node",
              program = "${file}", cwd = "${workspaceFolder}" },
            { type = "pwa-node",  request = "attach", name = "Attach Node",
              processId = require("dap.utils").pick_process, cwd = "${workspaceFolder}" },
            { type = "pwa-chrome",request = "launch", name = "Launch Chrome",
              url = "http://localhost:3000", webRoot = "${workspaceFolder}" },
          }
        end
      end

      -- PHP (xdebug)
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }
      dap.configurations.php = {
        { type = "php", request = "launch", name = "Listen for XDebug",
          port = 9003, pathMappings = { ["/var/www/html"] = "${workspaceFolder}" } },
      }
    end,
  },

  -- ===========================================================================
  -- NEOTEST — Test runner (Jest, PHPUnit, Pytest, Vitest…)
  -- ===========================================================================
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
      "olimorris/neotest-phpunit",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>tr", function() require("neotest").run.run() end,                          desc = "Test: Run nearest" },
      { "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end,        desc = "Test: Run file" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,                  desc = "Test: Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end,     desc = "Test: Output" },
      { "<leader>tw", function() require("neotest").run.run({ jestCommand = "jest --watch" }) end, desc = "Test: Watch" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "npx jest",
            env = { CI = true },
          }),
          require("neotest-python")({ dap = { justMyCode = false } }),
          require("neotest-phpunit"),
        },
        output    = { open_on_run = false },
        quickfix  = { open = false },
        status    = { virtual_text = true },
        icons     = { passed = "✓", failed = "✗", running = "↻", skipped = "○" },
      })
    end,
  },

  -- ===========================================================================
  -- MASON + DAP/LINT auto-installer
  -- ===========================================================================
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = {
        "js-debug-adapter",
        "php-debug-adapter",
        "python",
        "delve",        -- Go
        "codelldb",     -- C/C++/Rust
      },
      automatic_installation = true,
      handlers = {},
    },
  },

  -- ===========================================================================
  -- REFACTORING — Extract function/variable (JetBrains-class refactor)
  -- ===========================================================================
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>re", function() require("refactoring").refactor("Extract Function") end,         mode = "v", desc = "Extract function" },
      { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end,         mode = "v", desc = "Extract variable" },
      { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end,  mode = { "n", "v" }, desc = "Inline variable" },
      { "<leader>rr", function() require("telescope").extensions.refactoring.refactors() end, mode = { "n", "v" }, desc = "Refactoring menu" },
    },
    opts = {},
  },

  -- ===========================================================================
  -- FLASH — Supercharged f/t/s motions (faster navigation)
  -- ===========================================================================
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = {
      modes = {
        char = { jump_labels = true },
      },
    },
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash jump" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,         desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,             desc = "Flash remote" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end,  desc = "Flash TS search" },
      { "<C-s>", mode = "c",               function() require("flash").toggle() end,             desc = "Flash toggle search" },
    },
  },

  -- ===========================================================================
  -- YANKY — Clipboard ring (cycle through yank history)
  -- ===========================================================================
  {
    "gbprod/yanky.nvim",
    event        = "BufReadPost",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {
      ring         = { history_length = 100, storage = "sqlite", sync_with_numbered_registers = true },
      picker       = { select = { action = nil }, telescope = { mappings = nil } },
      system_clipboard = { sync_with_ring = true },
    },
    keys = {
      { "p",     "<Plug>(YankyPutAfter)",  mode = { "n", "x" }, desc = "Put after" },
      { "P",     "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
      { "<C-p>", "<Plug>(YankyCycleForward)",  desc = "Cycle yank forward" },
      { "<C-n>", "<Plug>(YankyCycleBackward)", desc = "Cycle yank backward" },
    },
  },

  -- ===========================================================================
  -- MINI.NVIM — Collection of small utility modules
  -- ===========================================================================
  {
    "echasnovski/mini.nvim",
    version = false,
    event   = "VeryLazy",
    config = function()
      -- Better f/F/t/T labels
      require("mini.animate").setup({
        scroll = { enable = false }, -- handled by neoscroll
      })
      -- Buffer delete without closing the window
      require("mini.bufremove").setup()
      vim.keymap.set("n", "<leader>bd", function()
        require("mini.bufremove").delete(0, false)
      end, { desc = "Delete buffer" })
    end,
  },

}
