-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }

local cmp_nvim_lsp = require "cmp_nvim_lsp"
local lspconfig = require "lspconfig"

-- vim.api.nvim_create_autocmd({"FileType"}, {
--   pattern = "pico",
--   callback = function()
--     require("pico8_ls").start_or_attach({})
--   end,
--   desc = "Start pico8-ls"
-- })

lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = cmp_nvim_lsp.default_capabilities(),
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
    "--clang-tidy",
    "--cross-file-rename",
    "--background-index",
    "--fallback-style=WebKit",
  },
}

lspconfig.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = true,
          maxLineLength = 120
        }
      }
    }
  }
}

lspconfig.jdtls.setup {}

require("presence").setup {
  enable = false,
  -- General options
  auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
  neovim_image_text = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
  main_image = "neovim", -- Main image display (either "neovim" or "file")
  log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
  debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
  enable_line_number = false, -- Displays the current line number instead of the current project
  blacklist = { "CodeGuessing", "Code_Guessing", "Homeworks", ".*"}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
  buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
  file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
  show_time = true, -- Show the timer

  -- Rich Presence text options
  editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
  file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
  git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
  plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
  reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
  workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
  line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
}

require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

-- vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.diagnostic.open_float()<CR><cmd>lua vim.diagnostic.open_float()<CR>")
vim.opt.wrap = false
vim.wo.wrap = false

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local sn = ls.snippet_node
local f = ls.function_node
local ri = function (insert_node_id)
    return f(function (args) return args[1][1] end, insert_node_id)
end

ls.add_snippets("python", {
  s("main", {
    t({"def main():", "    "}), i(0, "pass"), t({"", "", "if __name__ == '__main__':", "    main()"})
  }),
})

ls.add_snippets("cpp", {
  s("for", {
    t("for("), i(1, "std::size_t"), t(" "), i(2, "i"), t(" = "), i(3, "0"), t("; "), ri(2), t(" < "), i(4, "length"), t("; ++"), ri(2), t({")", "{", "    "}), i(0), t({"", "}"})
  }),
  s("fora", {
    t("for(auto& "), i(1, "item"), t(" : "), i(2, "collection"), t({")", "{", "    ", "}"})
  }),
  s("forca", {
    t("for(const auto& "), i(1, "item"), t(" : "), i(2, "collection"), t({")", "{", "    ", "}"})
  }),
  s("forp", {
    t("for(const auto& item : "), i(1, "collection"), t({")", "{", "    std::cout << item << \", \";", "}", "std::cout << '\\n';"})
  })
})

-- vim.keymap.set('n', '<leader>le', generate_enum_tostring_array, { noremap = true })
vim.keymap.set('i', '<C-Tab>', 'copilot#Accept("\\<CR>")', {
          expr = true,
          replace_keycodes = false
        })
        vim.g.copilot_no_tab_map = true

