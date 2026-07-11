-- Charles H. Leggett's Neovim config.
-- Starting clean, with lazy.nvim for plugin management.

-- Leader keys must be set BEFORE lazy.nvim loads.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- A few sensible defaults. Extend as you like.
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Bootstrap lazy.nvim (auto-installs into stdpath("data") on first launch).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications. Add plugins to `spec`, then run :Lazy to manage them.
require("lazy").setup({
  spec = {
    -- Example plugin (a colorscheme) so you can confirm plugin management works.
    -- Remove or swap this for your own; run :Lazy after editing.
    {
      "folke/tokyonight.nvim",
      lazy = false,   -- load during startup
      priority = 1000, -- load before other plugins
      config = function()
        vim.cmd.colorscheme("tokyonight")
      end,
    },

    -- Add more plugins here, for example:
    -- { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    -- { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    -- { "neovim/nvim-lspconfig" },
  },

  -- Don't auto-check for plugin updates on startup; run :Lazy check yourself.
  checker = { enabled = false },
})
