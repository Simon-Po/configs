-- lua/plugins/astrolsp.lua
---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---------------------------------------------------------------------------
    -- Core feature toggles
    ---------------------------------------------------------------------------
    features = {
      codelens = true,          -- refresh code lens on start
      inlay_hints = false,      -- off by default (turn on if you like)
      semantic_tokens = true,   -- semantic highlight
      -- note: format-on-save is configured below in `formatting`
    },

    ---------------------------------------------------------------------------
    -- Formatting behavior
    ---------------------------------------------------------------------------
    formatting = {
      format_on_save = {
        enabled = true,         -- global toggle
        allow_filetypes = { "go" },  -- example allowlist
        ignore_filetypes = {},       -- add any you want to skip
      },
      disabled = {
        -- example: disable lua_ls formatting if you prefer StyLua/null-ls
        -- "lua_ls",
      },
      timeout_ms = 1500,
    },

    ---------------------------------------------------------------------------
    -- Per-server configuration (passed to lspconfig)
    ---------------------------------------------------------------------------
    ---@diagnostic disable: missing-fields
    config = {
      -- ElixirLS requires a working command; set the absolute path if not on $PATH
      -- See: nvim-lspconfig elixirls docs
      -- https://www.andersevenrud.net/neovim.github.io/lsp/configurations/elixirls/
      elixirls = {
        -- If ElixirLS is on your PATH, you can use just "elixir-ls" or "language_server.sh"
        -- cmd = { "elixir-ls" },
        cmd = { "/Users/spohl/.vscode/extensions/jakebecker.elixir-ls-0.29.3/elixir-ls-release/language_server.sh" },
        filetypes = { "elixir", "eelixir" },
        root_dir = require("lspconfig.util").root_pattern("mix.exs", ".git"),
        settings = {
          elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = true,
          },
        },
      },

      -- Erlang LS: ensure the binary from erlang-ls is on PATH
      -- lspconfig id is "erlangls"
      -- https://www.andersevenrud.net/neovim.github.io/lsp/configurations/erlangls/
      erlangls = {
        -- if needed, set cmd explicitly, e.g.:
        -- cmd = { "/usr/local/bin/erlang_ls" },
      },

      -- SWI-Prolog language server (prolog_ls)
      -- (install the SWI-Prolog LSP; if not on PATH, set cmd explicitly)
      -- https://github.com/jamesnvc/lsp_server
      prolog_ls = {
        -- Example stdio entrypoint if you need to point to swipl:
        -- cmd = {
        --   "swipl", "-g", "use_module(library(prolog_lsp))",
        --   "-g", "prolog_lsp:stdio", "-t", "halt"
        -- },
      },

      -- Example: tweak clangd if you want utf-8 offset encoding
      clangd = {
  cmd = { "clangd", "--compile-commands-dir=./build" },
  init_options = {
    compilationDatabasePath = ".",
  },
  capabilities = { offsetEncoding = "utf-8" },
},
    },

    ---------------------------------------------------------------------------
    -- Optional LSP client handler tweaks (UI/UX)
    ---------------------------------------------------------------------------
    lsp_handlers = {
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
    },

    ---------------------------------------------------------------------------
    -- Extra autocmds for LSP-attached buffers
    ---------------------------------------------------------------------------
    autocmds = {
      lsp_document_highlight = {
        cond = "textDocument/documentHighlight",
        {
          event = { "CursorHold", "CursorHoldI" },
          desc = "LSP: document highlight under cursor",
          callback = function() pcall(vim.lsp.buf.document_highlight) end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "LSP: clear document highlights",
          callback = function() pcall(vim.lsp.buf.clear_references) end,
        },
      },
    },

    ---------------------------------------------------------------------------
    -- Keymaps applied on LSP attach
    ---------------------------------------------------------------------------
    mappings = {
      n = {
        -- your requests:
        gd = { function() vim.lsp.buf.definition() end, desc = "Go to definition",   cond = "textDocument/definition" },
        gh = { function() vim.lsp.buf.hover() end,       desc = "Hover symbol",       cond = "textDocument/hover" },
        gw = { function() vim.diagnostic.open_float(nil, { focusable = false }) end,
               desc = "Show diagnostics under cursor" },

        -- you can add more here if you want (rename, code actions, etc.)
        -- gr = { function() vim.lsp.buf.references() end, desc = "References", cond = "textDocument/references" },
        -- ga = { function() vim.lsp.buf.code_action() end, desc = "Code action", cond = "textDocument/codeAction" },
      },
    },

    ---------------------------------------------------------------------------
    -- Server list to initialize (others come from packs; keep this focused)
    ---------------------------------------------------------------------------
    servers = {
      "elixirls",
      "erlangls",
      "prolog_ls",
      -- C/C++/Go/Rust/TS/JS are provided by your AstroCommunity packs;
      -- no need to duplicate them here unless you want to override.
    },

    ---------------------------------------------------------------------------
    -- Custom on_attach (runs after Astro’s default attach)
    ---------------------------------------------------------------------------
    on_attach = function(client, bufnr)
      -- Example: disable semantic tokens on specific servers if you prefer
      -- if client.name == "clangd" then client.server_capabilities.semanticTokensProvider = nil end
    end,

    ---------------------------------------------------------------------------
    -- Handlers table lets you override or disable setup of certain servers
    ---------------------------------------------------------------------------
    handlers = {
      -- Default handler: use lspconfig to set up any server in `servers`
      function(server, opts) require("lspconfig")[server].setup(opts) end,

      -- If you use rustaceanvim via astrocommunity.pack.rust, you can disable rust_analyzer setup here:
      -- rust_analyzer = false,
    },
  },
}
