local g = vim.g
local keymap = vim.keymap
local o = vim.o

-- show block cursor instead of blinking line on insert mode
o.guicursor = "i:block"

-- map space as leader key
keymap.set('', '<Space>', '<Nop>', { noremap = true, silent = true })
g.mapleader = ' '
g.maplocalleader = ' '

o.shiftwidth = 2   -- add 2 spaces at every indent level
o.expandtab = true -- always convert tab to spaces

o.relativenumber = true
o.number = true


-- incremental live completion
o.inccommand = 'nosplit'

-- don't highlight search results
o.hlsearch = false

-- don't save when switching buffers
o.hidden = true

-- enable mouse mode
o.mouse = 'a'
--
-- keep indent level when wrapping a line
o.breakindent = true

-- save undo history
o.undofile = true

-- ignore casing in search unless using /c or if the search contains an uppercase char
o.ignorecase = true
o.smartcase = true


-- always show sign column (where numbers, folds, etc, are)
o.signcolumn = 'yes'

-- theme
vim.cmd('colorscheme rose-pine')

o.termguicolors = true

-- General keymaps
--

keymap.set('n', ';', ':')
