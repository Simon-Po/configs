
-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "jellybeans-mono",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = {
        -- general override
        Normal = { bg = "#181818" },
        -- Add winbar overrides
        WinBar = { bg = "#2a2a2a" },     -- lighter than pure black
        WinBarNC = { bg = "#1f1f1f" },   -- for non-current windows
        TabLine = { bg = "#2a2a2a" },
        TabLineSel = { bg = "#3a3a3a" },
      },
      -- if you want theme-specific overrides
      jellybeans = {
        WinBar = { bg = "#2a2a2a" },
        WinBarNC = { bg = "#1f1f1f" },
        TabLine = { bg = "#2a2a2a" },
        TabLineSel = { bg = "#3a3a3a" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
