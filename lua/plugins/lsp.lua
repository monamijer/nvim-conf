return {
  -- 1. Mason for managing external tools
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- 2. None-ls for Prettier (The Formatter)
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier, -- HTML, JS, CSS, JSON
          null_ls.builtins.formatting.stylua,   -- Lua formatting
        },
      })
    end,
  },

  -- 3. Mason LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Create an automation group for formatting
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "emmet_ls", "pyright", "eslint", "html", "cssls" },
        handlers = {
          -- Default handler for all servers
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                -- Automatic Format on Save Logic
                if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                  vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                      vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                  })
                end
              end,
            })
          end,

          -- Keep your specific ESLint and Lua logic here
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = { Lua = { diagnostics = { globals = { "vim" } } } },
            })
          end,

          ["eslint"] = function()
            lspconfig.eslint.setup({
              capabilities = capabilities,
              root_dir = lspconfig.util.root_pattern(".eslintrc", "eslint.config.js", "package.json"),
              on_new_config = function(config, new_root_dir)
                config.settings.workspaceFolder = { chdir = true, uri = vim.uri_from_fname(new_root_dir) }
              end,
            })
          end,
        },
      })
    end,
  },

  -- 4. Completion Engine (Snippet support for HTML)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets", -- Important for VS Code snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load VS Code style snippets (like the ! for HTML)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })
    end,
  },
}
