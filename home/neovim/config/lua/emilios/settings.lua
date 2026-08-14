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
vim.cmd('set termguicolors')
vim.cmd('colorscheme alabaster')
vim.cmd('set background=light')

o.termguicolors = true

-- transparent background: drop the bg but keep the colorscheme's fg.
-- (nvim_set_hl replaces the whole group, so we have to read it back first --
-- clearing Normal's fg leaves plugins like diffview with no color to derive
-- their file names from, and they fall back to white.)
local function transparent_bg(group)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  hl.bg, hl.ctermbg = nil, nil
  vim.api.nvim_set_hl(0, group, hl)
end

transparent_bg("Normal")
transparent_bg("NormalNC")

vim.cmd("set cmdheight=0")
-- General keymaps
--

keymap.set('n', ';', ':')


-- Disable noisy diagnostic virtual text
vim.diagnostic.config({ virtual_text = false })
