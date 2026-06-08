-- =============================================================================
--  plugins/ai.lua
--  AI-native development layer:
--  GitHub Copilot · CodeCompanion (Claude / GPT-4 / Gemini / Ollama)
-- =============================================================================

return {

  -- ===========================================================================
  -- GITHUB COPILOT — Inline ghost-text completions
  -- ===========================================================================
  {
    "zbirenbaum/copilot.lua",
    cmd   = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled    = true,
        auto_refresh = true,
        keymap     = { jump_prev = "[[", jump_next = "]]", accept = "<CR>", refresh = "gr", open = "<M-CR>" },
        layout     = { position = "bottom", ratio = 0.4 },
      },
      suggestion = {
        enabled      = true,
        auto_trigger = true,
        debounce     = 75,
        keymap = {
          accept       = false,   -- Handled in keymaps.lua (Ctrl+J)
          accept_word  = "<C-Right>",
          accept_line  = "<C-Down>",
          next         = false,
          prev         = false,
          dismiss      = false,
        },
      },
      filetypes = {
        yaml      = true,
        markdown  = true,
        help      = false,
        gitcommit = true,
        gitrebase = false,
        ["*"]     = true,
      },
      copilot_node_command = "node",
      server_opts_overrides = {},
    },
  },

  -- Copilot cmp source (shows in completion menu)
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "zbirenbaum/copilot.lua",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- ===========================================================================
  -- CODECOMPANION — Multi-provider AI chat + inline actions
  --  Supports: Anthropic Claude, OpenAI, Gemini, Ollama, Azure OpenAI
  -- ===========================================================================
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    cmd  = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>",   mode = { "n", "v" }, desc = "AI: Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat<cr>",      mode = { "n", "v" }, desc = "AI: Chat" },
      { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = "v",          desc = "AI: Explain" },
      { "<leader>af", "<cmd>CodeCompanion /fix<cr>",     mode = "v",          desc = "AI: Fix" },
      { "<leader>ar", "<cmd>CodeCompanion /refactor<cr>",mode = "v",          desc = "AI: Refactor" },
      { "<leader>at", "<cmd>CodeCompanion /tests<cr>",   mode = "v",          desc = "AI: Tests" },
      { "<leader>ad", "<cmd>CodeCompanion /docstring<cr>",mode = "n",         desc = "AI: Docstring" },
      { "<leader>ao", "<cmd>CodeCompanion /optimize<cr>",mode = "v",          desc = "AI: Optimize" },
      { "<leader>aR", "<cmd>CodeCompanion /review<cr>",  mode = "v",          desc = "AI: Review" },
    },
    opts = {
      -- -----------------------------------------------------------------------
      -- Adapters — configure each provider
      -- Set API keys via environment variables (never hardcode):
      --   ANTHROPIC_API_KEY, OPENAI_API_KEY, GEMINI_API_KEY
      -- -----------------------------------------------------------------------
      adapters = {
        -- Anthropic Claude (default — most capable)
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              model = {
                default = "claude-opus-4-5",
              },
            },
          })
        end,

        -- OpenAI GPT-4o
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "gpt-4o",
              },
            },
          })
        end,

        -- Google Gemini
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.0-flash-exp",
              },
            },
          })
        end,

        -- Local Ollama (privacy-first, offline)
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "codellama:latest",
              },
              num_ctx = {
                default = 16384,
              },
            },
          })
        end,
      },

      -- Default adapter to use
      strategies = {
        chat    = { adapter = "anthropic" },
        inline  = { adapter = "copilot" },  -- Inline: copilot (fastest)
        agent   = { adapter = "anthropic" },
      },

      -- -----------------------------------------------------------------------
      -- Slash commands (the /commands in chat)
      -- -----------------------------------------------------------------------
      prompt_library = {
        ["Explain Code"] = {
          strategy = "chat",
          description = "Get an explanation for the selected code",
          prompts = {
            {
              role    = "system",
              content = "You are an expert developer. Explain clearly and concisely.",
            },
            {
              role    = "user",
              content = function(context)
                return "Explain this " .. context.filetype .. " code:\n\n```"
                  .. context.filetype .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```"
              end,
            },
          },
        },
        ["Fix Code"] = {
          strategy = "inline",
          description = "Fix the selected code",
          prompts = {
            {
              role    = "system",
              content = "You are an expert developer. Fix bugs. Return ONLY the corrected code without explanation.",
            },
            {
              role    = "user",
              content = function(context)
                return "Fix this " .. context.filetype .. " code:\n\n```"
                  .. context.filetype .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```"
              end,
            },
          },
        },
        ["Generate Tests"] = {
          strategy = "chat",
          description = "Generate unit tests for selected code",
          prompts = {
            {
              role    = "system",
              content = "You are a test engineer. Write comprehensive unit tests.",
            },
            {
              role    = "user",
              content = function(context)
                return "Write unit tests for this " .. context.filetype .. " code:\n\n```"
                  .. context.filetype .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```"
              end,
            },
          },
        },
        ["Refactor Code"] = {
          strategy = "inline",
          description = "Refactor the selected code",
          prompts = {
            {
              role    = "system",
              content = "You are a senior engineer. Refactor for readability, performance, and best practices. Return ONLY the refactored code.",
            },
            {
              role    = "user",
              content = function(context)
                return "Refactor this " .. context.filetype .. " code:\n\n```"
                  .. context.filetype .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```"
              end,
            },
          },
        },
        ["Generate Docstring"] = {
          strategy = "inline",
          description = "Generate documentation for function/class",
          prompts = {
            {
              role    = "user",
              content = function(context)
                return "Generate a JSDoc/PHPDoc/docstring for this "
                  .. context.filetype .. " code:\n\n```"
                  .. context.filetype .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```\nReturn ONLY the documentation comment."
              end,
            },
          },
        },
        ["Code Review"] = {
          strategy = "chat",
          description = "Perform a code review",
          prompts = {
            {
              role    = "system",
              content = "You are a senior code reviewer. Evaluate: correctness, security, performance, maintainability, and best practices.",
            },
            {
              role    = "user",
              content = function(context)
                return "Review this " .. context.filetype .. " code:\n\n```"
                  .. context.filetype .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```"
              end,
            },
          },
        },
      },

      -- UI configuration
      display = {
        action_palette = {
          width   = 95,
          height  = 10,
          prompt  = "Prompt ",
          provider = "telescope",
        },
        chat = {
          window = {
            layout   = "vertical",
            width    = 0.35,
            height   = 0.5,
            relative = "editor",
            border   = "rounded",
          },
          show_settings = true,
          show_token_count = true,
        },
        inline = {
          layout = "vertical",
        },
      },
    },
  },

}
