-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        -- foo = "fooscript",
      },
      filename = {
        -- [".foorc"] = "fooscript",
      },
      pattern = {
        -- [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        tabstop = 4,
        shiftwidth = 4,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        ["<Leader>m"] = { desc = "Custom" },
        ["<Leader>mo"] = { desc = "OpenCode" },
        ["<Leader>mc"] = { desc = "Claude Code" },
        ["<Leader>ma"] = { "<cmd>AerialNavToggle<CR>", desc = "Toggle Aerial Nav" },
        ["<Leader>mm"] = {
          function()
            if vim.opt.relativenumber:get() then
              vim.opt.relativenumber = false
            else
              vim.opt.relativenumber = true
            end
          end,
          desc = "Toggle relativenumber",
        },

        -- ["<Leader>md"] = { "<Plug>(doge-generate)", desc = "Generate docstrings" },
        ["<leader>md"] = { "<cmd>DogeGenerate<CR>", desc = "Generate documentation comments" },
        ["<leader>me"] = {
          function()
            local h = require "helpers"
            h.generate_enum_tostring_array()
          end,
          desc = "Generate enum to string array.",
        },
        ["<Leader>moc"] = { function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Ask opencode…" },
        ["<Leader>mos"] = { function() require("opencode").select() end, desc = "Select opencode…" },
        ["<Leader>mot"] = { function() require("opencode").toggle() end, desc = "Toggle opencode" },
        ["<Leader>mor"] = { function() return require("opencode").operator("@this ") end, desc = "Add range to opencode", expr = true },
        ["<Leader>moy"] = { function() return require("opencode").operator("@this ") .. "_" end, desc = "Add line to opencode", expr = true },
        ["<Leader>mok"] = { function() require("opencode").command("session.half.page.up") end, desc = "Scroll opencode up" },
        ["<Leader>mol"] = { function() require("opencode").command("session.half.page.down") end, desc = "Scroll opencode down" },

        ["<Leader>mcc"] = { "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        ["<Leader>mcf"] = { "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        ["<Leader>mcr"] = { "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
        ["<Leader>mcC"] = { "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        ["<Leader>mcm"] = { "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
        ["<Leader>mcb"] = { "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        ["<Leader>mca"] = { "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        ["<Leader>mcd"] = { "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
        ["<leader>mcs"] = { "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude" },
        -- ["<Leader>mcs"] = { "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file", ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },}

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },
      },
      x = {
        ["<Leader>m"] = { desc = "Custom" },
        ["<Leader>moc"] = { function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Ask opencode…" },
        ["<Leader>mos"] = { function() require("opencode").select() end, desc = "Select opencode…" },
        ["<Leader>mor"] = { function() return require("opencode").operator("@this ") end, desc = "Add range to opencode", expr = true },
      },
      t = {
        ["<Leader>mo"] = { desc = "Custom" },
        ["<Leader>mot"] = { function() require("opencode").toggle() end, desc = "Toggle opencode" },
      },
      v = {
        ["<leader>mcs"] = { "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude" },
      }
    },
  },
}
