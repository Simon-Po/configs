-- AstroCommunity: import any community modules here
---@type LazySpec
return {
  "AstroNvim/astrocommunity",
{ import = "astrocommunity.colorscheme.tokyonight-nvim" },
{ import = "astrocommunity.colorscheme.catppuccin" },
  -- existing
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.elixir-phoenix" },

  -- add these:
  { import = "astrocommunity.pack.cpp" }, -- covers C/C++ (clangd + codelldb)
  { import = "astrocommunity.pack.rust" }, -- rust-analyzer via rustaceanvim
  { import = "astrocommunity.pack.go" }, -- gopls, delve, etc.
  { import = "astrocommunity.pack.typescript" }, -- tsserver/typescript-tools
}
