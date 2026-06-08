-- =============================================================================
--  plugins/lsp.lua
--  Full language-intelligence stack:
--  Mason · LSPConfig · none-ls · nvim-cmp · Treesitter
--  Languages: JS/TS/React/Next · Vue · Svelte · PHP/Laravel ·
--             HTML/CSS/SCSS/Tailwind · Lua · Python · C/C++ · Rust · Go
-- =============================================================================

return {

  -- ===========================================================================
  -- MASON — Portable LSP / DAP / linter / formatter installer
  -- ===========================================================================
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border  = "rounded",
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ===========================================================================
  -- MASON-LSPCONFIG — Auto-install + auto-configure LSP servers
  -- ===========================================================================
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "SmiteshP/nvim-navic",
    },
    config = function()
      local lspconfig   = require("lspconfig")
      local capabilities = vim.tbl_deep_extend("force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Folding capability (used by nvim-ufo)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly     = true,
      }

      -- Shared on_attach for ALL servers
      local function on_attach(client, bufnr)
        -- Breadcrumb navigation
        if client.server_capabilities.documentSymbolProvider then
          local ok, navic = pcall(require, "nvim-navic")
          if ok then navic.attach(client, bufnr) end
        end

        -- Highlight references under cursor
        if client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group, buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group, buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Inlay hints (Neovim 0.10+)
        if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      -- Format-on-save autocmd group
      local fmt_group = vim.api.nvim_create_augroup("LspFormatOnSave", {})

      local function make_on_attach(extra_attach)
        return function(client, bufnr)
          on_attach(client, bufnr)
          if extra_attach then extra_attach(client, bufnr) end

          -- Format on save
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group    = fmt_group,
              buffer   = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr    = bufnr,
                  timeout_ms = 3000,
                  filter = function(c)
                    -- Prefer null-ls / none-ls for formatting when available
                    return c.name == "null-ls" or c.name ~= "tsserver"
                  end,
                })
              end,
            })
          end
        end
      end

      -- Diagnostic signs & UI
      local diagnostic_icons = {
        Error = " ", Warn = " ", Hint = "󰌵 ", Info = " "
      }
      for type, icon in pairs(diagnostic_icons) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          source   = "if_many",
          prefix   = "●",
        },
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        signs          = true,
        underline      = true,
        update_in_insert = false,
        severity_sort  = true,
      })

      -- ===========================================================================
      -- Server Definitions
      -- ===========================================================================
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- JS / TS / Web
          "ts_ls",        -- TypeScript / JavaScript (replaces tsserver)
          "eslint",
          "html",
          "cssls",
          "emmet_ls",
          "tailwindcss",
          -- Vue / Svelte
          "volar",
          "svelte",
          -- PHP
          "intelephense",
          -- Lua
          "lua_ls",
          -- Python
          "pyright",
          -- C / C++
          "clangd",
          -- Rust
          "rust_analyzer",
          -- Go
          "gopls",
          -- JSON / YAML
          "jsonls",
          "yamlls",
          -- Bash
          "bashls",
          -- Docker
          "dockerls",
          -- Markdown
          "marksman",
        },
        automatic_installation = true,

        handlers = {

          -- Default handler (all servers not listed below)
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
              on_attach    = make_on_attach(),
            })
          end,

          -- ----------------------------------------------------------------
          -- Lua
          -- ----------------------------------------------------------------
          lua_ls = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              on_attach    = make_on_attach(),
              settings = {
                Lua = {
                  runtime    = { version = "LuaJIT" },
                  workspace  = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  diagnostics  = { globals = { "vim" } },
                  telemetry    = { enable = false },
                  hint         = { enable = true },
                },
              },
            })
          end,

          -- ----------------------------------------------------------------
          -- TypeScript / JavaScript (ts_ls)
          -- ----------------------------------------------------------------
          ts_ls = function()
            lspconfig.ts_ls.setup({
              capabilities = capabilities,
              on_attach    = make_on_attach(function(client, _)
                -- Disable tsserver formatting (use prettier via null-ls)
                client.server_capabilities.documentFormattingProvider = false
              end),
              settings = {
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints            = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints    = true,
                    includeInlayVariableTypeHints             = true,
                    includeInlayPropertyDeclarationTypeHints  = true,
                    includeInlayFunctionLikeReturnTypeHints   = true,
                    includeInlayEnumMemberValueHints          = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints            = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints    = true,
                    includeInlayVariableTypeHints             = true,
                  },
                },
              },
            })
          end,

          -- ----------------------------------------------------------------
          -- ESLint
          -- ----------------------------------------------------------------
          eslint = function()
            lspconfig.eslint.setup({
              capabilities = capabilities,
              on_attach    = make_on_attach(function(client, bufnr)
                -- ESLint can fix-all on save
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer   = bufnr,
                  callback = function() vim.cmd("EslintFixAll") end,
                })
              end),
              root_dir = lspconfig.util.root_pattern(
                ".eslintrc", ".eslintrc.js", ".eslintrc.json",
                "eslint.config.js", "eslint.config.mjs", "package.json"
              ),
            })
          end,

          -- ----------------------------------------------------------------
          -- Tailwind CSS
          -- ----------------------------------------------------------------
          tailwindcss = function()
            lspconfig.tailwindcss.setup({
              capabilities = capabilities,
              on_attach    = make_on_attach(),
              root_dir     = lspconfig.util.root_pattern(
                "tailwind.config.js", "tailwind.config.ts",
                "postcss.config.js", "package.json"
              ),
              settings = {
                tailwindCSS = {
                  classAttributes = { "class", "className", "classList", "ngClass" },
                  lint = {
                    cssConflict            = "warning",
                    invalidApply           = "error",
                    invalidConfigPath      = "error",
                    invalidScreen          = "error",
                    invalidTailwindDirective = "error",
                    invalidVariant         = "error",
                    recommendedVariantOrder = "warning",
                  },
                },
              },
            })
          end,

          -- ----------------------------------------------------------------
          -- Emmet (HTML/CSS smart expansions like VS Code)
          -- ----------------------------------------------------------------
          emmet_ls = function()
            lspconfig.emmet_ls.setup({
              capabilities = capabilities,
              on_attach    = make_on_attach(),
              filetypes    = {
                "html", "css", "scss", "less", "sass",
                "javascript", "javascriptreact",
                "typescript", "typescriptreact",
                "vue", "svelte", "pug", "php", "blade",
              },
              init_options = {
                html = {
                  options = { ["bem.enabled"] = true },
                },
              },
            })
          end,

          -- ----------------------------------------------------------------
          -- PHP — Intelephense (PhpStorm-class intelligence)
          -- ----------------------------------------------------------------
          intelephense = function()
            lspconfig.intelephense.setup({
              capabilities = capabilities,
              on_attach    = make_on_attach(function(client, _)
                client.server_capabilities.documentFormattingProvider = false
              end),
              settings = {
                intelephense = {
                  stubs = {
                    "apache", "bcmath", "bz2", "Core", "curl", "date",
                    "dom", "fileinfo", "filter", "hash", "iconv", "intl",
                    "json", "mbstring", "mcrypt", "mysql", "mysqli",
                    "password", "pcntl", "pcre", "PDO", "pdo_mysql",
                    "Reflection", "session", "SimpleXML", "soap",
                    "sockets", "sodium", "SPL", "standard", "tokenizer",
                    "xml", "xdebug", "xmlwriter", "zip", "zlib",
                    -- Laravel stubs
                    "laravel",
                  },
                  environment = {
                    phpVersion = "8.2",
                  },
                  files = {
                    maxSize = 5000000,
                    exclude = { "**/vendor/**", "**/node_modules/**" },
                  },
                  completion = {
                    triggerParameterHints = true,
                    insertUseDeclaration  = true,
                    fullyQualifyGlobalConstantsAndFunctions = false,
                  },
                },
              },
            })
          end,

          -- ----------------------------------------------------------------
          -- C / C++ — Clangd (CLion-class)
          -- ----------------------------------------------------------------
          clangd = function()
            lspconfig.clangd.setup({
              capabilities = vim.tbl_deep_extend("force", capabilities, {
                offsetEncoding = { "utf-16" },
              }),
              on_attach = make_on_attach(),
              cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--completion-style=detailed",
                "--header-insertion=iwyu",
                "--suggest-missing-includes",
              },
            })
          end,

          -- ----------------------------------------------------------------
          -- JSON
          -- ----------------------------------------------------------------
          jsonls = function()
            lspconfig.jsonls.setup({
              capabilities = capabilities,
              on_attach    = make_on_attach(),
              settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              },
            })
          end,

          -- ----------------------------------------------------------------
          -- YAML
          -- ----------------------------------------------------------------
          yamlls = function()
            lspconfig.yamlls.setup({
              capabilities = capabilities,
              on_attach    = make_on_attach(),
              settings = {
                yaml = {
                  schemaStore = { enable = false, url = "" },
                  schemas     = require("schemastore").yaml.schemas(),
                },
              },
            })
          end,

        }, -- end handlers
      }) -- end mason-lspconfig.setup
    end, -- end config
  },

  -- ===========================================================================
  -- NONE-LS (null-ls) — Formatters & linters not provided by LSP servers
  -- ===========================================================================
  {
    "nvimtools/none-ls.nvim",
    event        = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls-extras.nvim" },
    config = function()
      local nls = require("null-ls")

      nls.setup({
        border  = "rounded",
        sources = {
          -- Formatters
          nls.builtins.formatting.prettier.with({
            extra_filetypes = { "svelte", "pug", "blade" },
            prefer_local    = "node_modules/.bin",
          }),
          nls.builtins.formatting.stylua,          -- Lua
          nls.builtins.formatting.phpcsfixer.with({ -- PHP (PSR-12)
            extra_args = { "--rules=@PSR12" },
          }),
          nls.builtins.formatting.clang_format,    -- C/C++
          nls.builtins.formatting.black,            -- Python
          nls.builtins.formatting.isort,            -- Python imports
          nls.builtins.formatting.shfmt,            -- Shell

          -- Diagnostics / Linters
          nls.builtins.diagnostics.phpcs,
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.diagnostics.hadolint,        -- Dockerfile

          -- Code actions
          nls.builtins.code_actions.refactoring,
        },
      })
    end,
  },

  -- ===========================================================================
  -- TREESITTER — Semantic syntax highlighting + structural operations
  -- ===========================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build        = ":TSUpdate",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      ensure_installed = {
        -- Web
        "html", "css", "scss", "javascript", "typescript",
        "tsx", "vue", "svelte",
        -- PHP
        "php", "phpdoc",
        -- Systems
        "c", "cpp", "rust", "go", "gomod",
        -- Scripting
        "python", "lua", "bash",
        -- Config / data
        "json", "json5", "jsonc", "yaml", "toml", "ini",
        "xml", "graphql",
        -- Docs
        "markdown", "markdown_inline",
        -- Infra
        "dockerfile", "terraform",
        -- Neovim
        "vim", "vimdoc", "query",
        -- Templates
        "pug",
      },
      auto_install  = true,
      highlight     = { enable = true, additional_vim_regex_highlighting = false },
      indent        = { enable = true },
      -- Auto-close & rename HTML/JSX tags
      autotag       = { enable = true },
      -- Context-aware comments (works in JSX, Vue SFC, etc.)
      context_commentstring = {
        enable         = true,
        enable_autocmd = false,
      },
      -- Text objects: select function body, parameter, class…
      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },
        move = {
          enable    = true,
          set_jumps = true,
          goto_next_start     = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
          goto_next_end       = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
          goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
          goto_previous_end   = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
        },
        swap = {
          enable = true,
          swap_next     = { ["<leader>cp"] = "@parameter.inner" },
          swap_previous = { ["<leader>cP"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Sticky function context at top of screen
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts  = {
      enable            = true,
      max_lines         = 3,
      min_window_height = 20,
      mode              = "cursor",
      trim_scope        = "outer",
    },
  },

  -- ===========================================================================
  -- COMPLETION ENGINE — nvim-cmp with full source chain
  -- ===========================================================================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Load VS Code snippets (Laravel, React, etc.)
      require("luasnip.loaders.from_vscode").lazy_load()
      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" }
      })

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
          vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          completion    = cmp.config.window.bordered({ border = "rounded", winhighlight = "Normal:NormalFloat,CursorLine:PmenuSel" }),
          documentation = cmp.config.window.bordered({ border = "rounded" }),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode           = "symbol_text",
            maxwidth       = 50,
            ellipsis_char  = "…",
            symbol_map     = { Copilot = "" },
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<S-CR>"]    = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp",               priority = 1000 },
          { name = "nvim_lsp_signature_help",priority = 900  },
          { name = "luasnip",                priority = 800  },
          { name = "copilot",                priority = 700  },
          { name = "buffer",                 priority = 500,
            option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end } },
          { name = "path",                   priority = 400  },
        }),
        experimental = { ghost_text = { hl_group = "LspCodeLens" } },
      })

      -- Cmdline completion ( / search )
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      -- Cmdline completion ( : commands )
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
        ),
      })
    end,
  },

  -- ===========================================================================
  -- SCHEMA STORE — JSON/YAML schema validation (package.json, docker-compose…)
  -- ===========================================================================
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- ===========================================================================
  -- AUTO-PAIRS — Smart bracket/quote pairing
  -- ===========================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts       = true,   -- Treesitter-aware
      ts_config      = {
        lua  = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      -- Feed pairs into cmp
      local ok_cmp, cmp = pcall(require, "cmp")
      local ok_ap,  ap  = pcall(require, "nvim-autopairs.completion.cmp")
      if ok_cmp and ok_ap then
        cmp.event:on("confirm_done", ap.on_confirm_done())
      end
    end,
  },

  -- ===========================================================================
  -- COMMENT — Smart comment toggling (JSX / Vue SFC aware)
  -- ===========================================================================
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = {
      pre_hook = function(ctx)
        local ok, ts_cs = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
        if ok then return ts_cs.create_pre_hook()(ctx) end
      end,
    },
  },

  -- ===========================================================================
  -- SURROUND — Add / change / delete surrounding pairs
  -- ===========================================================================
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "BufReadPost",
    opts    = {},
  },

  -- ===========================================================================
  -- LSP SIGNATURE — Parameter hints as you type
  -- ===========================================================================
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      bind         = true,
      handler_opts = { border = "rounded" },
      hint_prefix  = "󰌵 ",
      floating_window = true,
      hi_parameter = "LspSignatureActiveParameter",
    },
  },

}
