-- DELETE the first line: if true then return {} end
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "elixir",
      "heex",
      "eex",
      "proto",
      "c",
      "cpp",
      "rust",
      "go",
      "javascript",
      "typescript",
      "erlang",
      "prolog",
    },
  },
}
