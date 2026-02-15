-- Lazy-load nvim with chezmoi-managed config
-- LazyVim + lazy.nvim plugin

-- Add lazy.nvim to runtime path
vim.opt.runtimepath += "~/.local/share/nvim/lazy"

-- Lazy-load all files in ~/.config/nvim/lua/
vim.opt.luachpath = "~/.config/nvim/lua"

-- Enable lazy.nvim plugin
vim.opt.plugman = true

-- Enable all features
vim.opt.lazy = true
vim.opt.lazy.nvim = true

-- Disable builtin vim plugins
vim.g.loader = "disabled"

-- Sync with system clipboard
vim.opt.clipboard = "unnamedplus"

-- Modern status line
vim.opt.statusline = 2

-- Better completion
vim.opt.completeopt = preview,noinsert,menuone

-- Smarter search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Save backup on write
vim.opt.backup = true
vim.opt.writebackup = true

-- Mouse support
vim.opt.mouse = "a"
vim.opt.mouseshift = "disable"
vim.opt.scrolloff = 2

-- Treesitter
vim.opt.treesitter = true

-- LSP
vim.opt.lsp = true

-- Format on write (preserve markdown!)
vim.opt.formatoptions = "j"

-- Color scheme (catppuccin)
vim.opt.background = "dark"
vim.opt.termguicolors = true

-- Folding
vim.opt.foldmethod = "indent"
vim.opt.foldenable = true

-- Better indentation
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Key bindings
-- <Space> to clear search highlight
vim.keymap[""] = " "

-- Make it better with spaceship-prompt
vim.opt.laststatus = 3  -- Show 3 lines of status
vim.opt.shortmess = true  -- Shorten messages
