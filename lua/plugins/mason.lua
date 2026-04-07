-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",
        "clangd",
        "cmake-language-server",
        -- "ruff",
        "python-lsp-server",
        -- "pyright",
        "rust-analyzer",
        "jdtls",

        -- install formatters
        "prettier",
        "stylua",
        "pico8-ls",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}
